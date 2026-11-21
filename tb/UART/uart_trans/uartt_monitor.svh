class uartt_monitor extends uvm_monitor;
    `uvm_component_utils(uartt_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual uart_transmitter_if.MONITOR vif;

    uvm_analysis_port #(uartt_item) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon_analysis_port = new("mon_analysis_port", this);

        if(!uvm_config_db #(virtual uart_transmitter_if.MONITOR)::get(this, "", "vif", vif)) begin
            `uvm_error(get_type_name(), "Didn't get handle to virtual interface uartt_if")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        uartt_item tr;

        if(vif == null)
            return;

        forever begin
            @(vif.uartt_cbm);

            tr = uartt_item::type_id::create("tr", this);

            tr.reset = vif.uartt_cbm.reset;
            tr.start = vif.uartt_cbm.start;
            tr.data = vif.uartt_cbm.data;
            tr.tx = vif.uartt_cbm.tx;
            tr.busy = vif.uartt_cbm.busy;

            mon_analysis_port.write(tr);
        end

    endtask : run_phase

endclass : uartt_monitor