class uartr_sequencer extends uvm_sequencer #(uartr_item);
    `uvm_component_utils(uartr_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : uartr_sequencer