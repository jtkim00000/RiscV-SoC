class control_unit_sequence extends uvm_sequence #(control_unit_item);
    `uvm_object_utils(control_unit_sequence)

    function new(string name = "control_unit_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        req = control_unit_item::type_id::create("req");
        repeat (550) begin
            start_item(req);
            if(!req.randomize())
                `uvm_fatal("CONTROL_UNIT_RAND", "Could not randomize this control_unit item")
            finish_item(req);
        end
    endtask : body

endclass : control_unit_sequence