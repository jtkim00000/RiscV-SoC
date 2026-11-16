class mux_driver extends uvm_driver #(mux_item);
    `uvm_component_utils(mux_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual mux_if.TEST vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual mux_if.TEST)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual intereface mux_if");
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        mux_item tr;

        forever begin
            seq_item_port.get_next_item(tr);

            @(vif.mux_cb)
            vif.mux_cb.data_in <= tr.data_in;
            vif.mux_cb.sel <= tr.sel;

            @(vif.mux_cb)
            seq_item_port.item_done();
        end

    endtask : run_phase

endclass : mux_driver