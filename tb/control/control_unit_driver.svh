class control_unit_driver extends uvm_driver #(control_unit_item);
    `uvm_component_utils(control_unit_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual control_unit_if.TEST vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual control_unit_if.TEST)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual intereface control_unit_if");
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        control_unit_item tr;

        forever begin
            seq_item_port.get_next_item(tr);

            @(vif.control_unit_cb)
            vif.control_unit_cb.instr <= tr.instr;

            @(vif.control_unit_cb)
            seq_item_port.item_done();
        end

    endtask : run_phase

endclass : control_unit_driver