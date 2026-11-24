class fifor_driver extends uvm_driver #(fifor_item);
    `uvm_component_utils(fifor_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual fifo_receiver_if.TEST vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual fifo_receiver_if.TEST)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface fifor_if")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        fifor_item tr;

        forever begin
            seq_item_port.get_next_item(tr);

            @(vif.fifor_cb);
            vif.fifor_cb.reset <= tr.reset;
            vif.fifor_cb.read <= tr.read;
            vif.fifor_cb.write <= tr.write;
            vif.fifor_cb.write_data <= tr.write_data;

            @(vif.fifor_cb);

            seq_item_port.item_done();

        end
        
    endtask : run_phase

endclass : fifor_driver