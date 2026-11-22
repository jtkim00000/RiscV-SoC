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

    int unsigned timeout_cycles = 100_000;

    task wait_for_busy(bit target);
        repeat (timeout_cycles) begin
            @(vif.uartt_cb);

            if (vif.uartt_cb.busy === target)
                return;
        end

        `uvm_fatal("UARTT_TIMEOUT", $sformatf("Timed out waiting for busy=%b", target))
    endtask : wait_for_busy


    virtual task run_phase(uvm_phase phase);
        uartt_item tr;

        @(vif.uartt_cb);
        vif.uartt_cb.start <= 1'b0;
        vif.uartt_cb.data  <= 8'd0;
        vif.uartt_cb.reset <= 1'b1;

        repeat (2) @(vif.uartt_cb);
        vif.uartt_cb.reset <= 1'b0;

        forever begin
            seq_item_port.get_next_item(tr);

            wait_for_busy(1'b0);

            vif.uartt_cb.data  <= tr.data;
            vif.uartt_cb.start <= 1'b1;

            @(vif.uartt_cb);
            vif.uartt_cb.start <= 1'b0;

            wait_for_busy(1'b1);
            wait_for_busy(1'b0);

            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : uartt_driver