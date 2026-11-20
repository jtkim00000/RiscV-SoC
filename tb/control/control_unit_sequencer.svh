class control_unit_sequencer extends uvm_sequencer #(control_unit_item);
    `uvm_component_utils(control_unit_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : control_unit_sequencer