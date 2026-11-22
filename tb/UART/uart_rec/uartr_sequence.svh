class uartr_sequence extends uvm_sequence #(uartr_item);
    `uvm_object_utils(uartr_sequence)

    function new(string name = "uartr_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat (50) begin
            req = uartr_item::type_id::create("req");
            start_item(req);
            if (!req.randomize())
                `uvm_fatal("UARTR_RAND", "Could not randomize UARTR item")
            finish_item(req);
        end
    endtask : body

endclass : uartr_sequence