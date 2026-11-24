class fifor_monitor extends uvm_monitor;
    `uvm_component_utils(fifor_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual fifo_receiver_if.MONITOR vif;

    uvm_analysis_port #(fifor_item) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon_analysis_port = new("mon_analysis_port", this);

        if(!uvm_config_db #(virtual fifo_receiver_if.MONITOR)::get(this, "", "vif", vif)) begin
            `uvm_error(get_type_name(), "Didn't get handle to virtual interface fifor_if")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        fifor_item tr;

        if(vif == null)
            return;

        forever begin
            @(vif.fifor_cbm);

            tr = fifor_item::type_id::create("tr", this);

            tr.write_data = vif.fifor_cbm.write_data;
            tr.read_data = vif.fifor_cbm.read_data;
            tr.reset = vif.fifor_cbm.reset;
            tr.read = vif.fifor_cbm.read;
            tr.write = vif.fifor_cbm.write;
            tr.empty = vif.fifor_cbm.empty;
            tr.full = vif.fifor_cbm.full;

            mon_analysis_port.write(tr);
        end

    endtask : run_phase

endclass : fifor_monitor