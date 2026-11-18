class sram_driver extends uvm_driver #(sram_item);
    `uvm_component_utils(sram_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual sram_if.TEST vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual sram_if.TEST)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface sram_if")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        sram_item tr;

        forever begin
            seq_item_port.get_next_item(tr);

            @(vif.sram_cb);
            vif.sram_cb.write_enable <= tr.write_enable;
            vif.sram_cb.sz <= tr.sz;
            vif.sram_cb.num_bytes <= tr.num_bytes;
            vif.sram_cb.addr <= tr.addr;
            vif.sram_cb.write_data <= tr.write_data;

            @(vif.sram_cb);

            seq_item_port.item_done();

        end
        
    endtask : run_phase

endclass : sram_driver