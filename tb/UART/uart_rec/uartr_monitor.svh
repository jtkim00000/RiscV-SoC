class uartr_monitor extends uvm_monitor;
    `uvm_component_utils(uartr_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual uart_receiver_if.MONITOR vif;

    uvm_analysis_port #(uartr_item) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon_analysis_port = new("mon_analysis_port", this);

        if(!uvm_config_db #(virtual uart_receiver_if.MONITOR)::get(this, "", "vif", vif)) begin
            `uvm_error(get_type_name(), "Didn't get handle to virtual interface uartr_if")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        uartr_item tr;

        if(vif == null)
            return;

        forever begin
            @(vif.uartr_cbm);

            tr = uartr_item::type_id::create("tr", this);

            tr.reset = vif.uartr_cbm.reset;
            tr.rx = vif.uartr_cbm.rx;
            tr.data = vif.uartr_cbm.data;
            tr.valid = vif.uartr_cbm.valid;
            tr.framing_error = vif.uartr_cbm.framing_error;

            mon_analysis_port.write(tr);
        end

    endtask : run_phase

endclass : uartr_monitor