class mux_sequence extends uvm_sequence #(mux_item);
    `uvm_object_utils(mux_sequence)

    function new(string name = "mux_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        req = mux_item::type_id::create("req");
        repeat (50) begin
            start_item(req);
            if(!req.randomize())
                `uvm_fatal("MUX_RAND", "Could not randomize this mux item")
            finish_item(req);
        end
    endtask : body

endclass : mux_sequence