class sram_monitor extends uvm_monitor;
    `uvm_component_utils(sram_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual sram_if.MONITOR vif;

    uvm_analysis_port #(sram_item) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon_analysis_port = new("mon_analysis_port", this);

        if(!uvm_config_db #(virtual sram_if.MONITOR)::get(this, "", "vif", vif)) begin
            `uvm_error(get_type_name(), "Didn't get handle to virtual interface sram_if")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        sram_item tr;

        if(vif == null)
            return;

        forever begin
            @(vif.sram_cbm);

            tr = sram_item::type_id::create("tr", this);

            tr.write_enable = vif.sram_cbm.write_enable;
            tr.num_bytes = vif.sram_cbm.num_bytes;
            tr.sz = vif.sram_cbm.sz;
            tr.addr = vif.sram_cbm.addr;
            tr.write_data = vif.sram_cbm.write_data;
            tr.read_data = vif.sram_cbm.read_data;

            mon_analysis_port.write(tr);
        end

    endtask : run_phase

endclass : sram_monitor