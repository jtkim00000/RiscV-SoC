class uartt_sequence extends uvm_sequence #(uartt_item);
    `uvm_object_utils(uartt_sequence)

    function new(string name = "uartt_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat (50) begin
            req = uartt_item::type_id::create("req");
            start_item(req);
            if (!req.randomize())
                `uvm_fatal("UARTT_RAND", "Could not randomize UARTT item")
            finish_item(req);
        end
    endtask : body

endclass : uartt_sequence