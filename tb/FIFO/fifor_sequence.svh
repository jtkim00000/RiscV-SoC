class fifor_sequence extends uvm_sequence #(fifor_item);
    `uvm_object_utils(fifor_sequence)

    function new(string name = "fifor_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat (500) begin
            req = fifor_item::type_id::create("req");
            start_item(req);
            if (!req.randomize())
                `uvm_fatal("FIFOR_RAND", "Could not randomize FIFO Receiver item")
            finish_item(req);
        end
    endtask : body

endclass : fifor_sequence