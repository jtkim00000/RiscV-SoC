class uartt_driver extends uvm_driver #(uartt_item);
    `uvm_component_utils(uartt_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual uart_transmitter_if.TEST vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual uart_transmitter_if.TEST)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Didn't get handle to virtual interface uartt_if")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        uartt_item tr;

        forever begin
            seq_item_port.get_next_item(tr);

            @(vif.uartt_cb);
            vif.uartt_cb.reset <= tr.reset;
            vif.uartt_cb.start <= tr.start;
            vif.uartt_cb.data <= tr.data;

            @(vif.uartt_cb);

            seq_item_port.item_done();

        end
        
    endtask : run_phase

endclass : uartt_driver