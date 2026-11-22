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

    int unsigned clks_per_bit = 868;

    task drive_bit(bit value);
        vif.uartr_cb.rx <= value;
        repeat (clks_per_bit) @(vif.uartr_cb);
    endtask : drive_bit

    virtual task run_phase(uvm_phase phase);
        uartr_item tr;

        @(vif.uartr_cb);
        vif.uartr_cb.rx    <= 1'b1;
        vif.uartr_cb.reset <= 1'b1;

        repeat (2) @(vif.uartr_cb);
        vif.uartr_cb.reset <= 1'b0;

        repeat (4) @(vif.uartr_cb);

        forever begin
            seq_item_port.get_next_item(tr);

            @(vif.uartr_cb);

            drive_bit(1'b0); 

            for (int i = 0; i < 8; i++)
                drive_bit(tr.send_data[i]);

            drive_bit(tr.bad_stop ? 1'b0 : 1'b1);

            drive_bit(1'b1);
            drive_bit(1'b1);

            seq_item_port.item_done();
        end
    endtask : run_phase
endclass : uartr_driver