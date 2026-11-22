class uartr_driver extends uvm_driver #(uartr_item);
    `uvm_component_utils(uartr_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual uart_receiver_if.TEST vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual uart_receiver_if.TEST)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface uartr_if")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        uartr_item tr;

        forever begin
            seq_item_port.get_next_item(tr);

            @(vif.uartr_cb);
            vif.uartr_cb.reset <= tr.reset;
            vif.uartr_cb.rx <= tr.rx;

            @(vif.uartr_cb);

            seq_item_port.item_done();

        end
        
    endtask : run_phase

endclass : uartr_driver