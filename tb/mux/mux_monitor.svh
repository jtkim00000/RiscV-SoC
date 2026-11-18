class mux_monitor extends uvm_monitor;
    `uvm_component_utils(mux_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual mux_if #(.DATA_WIDTH(32), .INPUT_WIDTH(4)).MONITOR vif;

    uvm_analysis_port #(mux_item_t) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon_analysis_port = new("mon_analysis_port", this);

        if(!uvm_config_db #(virtual mux_if #(.DATA_WIDTH(32), .INPUT_WIDTH(4)).MONITOR)::get(this, "", "vif", vif))
            `uvm_error(get_type_name(), "Didn't get handle to virtual interface mux_if");
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        mux_item_t tr;

        if(vif == null)
            return;

        forever begin
            @(vif.mux_cbm);

            tr = mux_item_t::type_id::create("tr", this);

            tr.data_in = vif.mux_cbm.data_in;
            tr.sel = vif.mux_cbm.sel;
            tr.data_out = vif.mux_cbm.data_out;

            mon_analysis_port.write(tr);
        end

    endtask : run_phase

endclass : mux_monitor