class uartr_sequence extends uvm_sequence #(uartr_item);
    `uvm_object_utils(uartr_sequence)

    function new(string name = "uartr_sequence");
        super.new(name);
    endfunction : new


    virtual task body();
        repeat (100) begin
            req = uartr_item::type_id::create("req");

            start_item(req);

            if (!req.randomize())
                `uvm_fatal("UARTR_RAND", "Could not randomize UART byte")

            req.bad_stop = 0;
            finish_item(req);
        end
    endtask


endclass : uartr_sequence