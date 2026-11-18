class mux_sequence extends uvm_sequence #(mux_item);
    `uvm_object_utils(mux_sequence)

    function new(string name = "mux_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        typedef mux_item #(
            .DATA_WIDTH(32),
            .INPUT_WIDTH(4)
        ) mux_item_t;

        mux_item_t req;

        req = mux_item_t::type_id::create("req");
        repeat (50) begin
            start_item(req);
            if(!req.randomize())
                `uvm_fatal("MUX_RAND", "Could not randomize this mux item")
            finish_item(req);
        end
    endtask : body

endclass : mux_sequence