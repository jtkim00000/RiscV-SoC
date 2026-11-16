class sram_sequence extends uvm_sequence #(sram_item);
    `uvm_object_utils(sram_sequence)

    function new(string name = "sram_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat (50) begin
            req = sram_item::type_id::create("req");
            start_item(req);
            if (!req.randomize())
                `uvm_fatal("SRAM_RAND", "Could not randomize sram item")
            finish_item(req);
        end
    endtask : body

endclass : sram_sequence