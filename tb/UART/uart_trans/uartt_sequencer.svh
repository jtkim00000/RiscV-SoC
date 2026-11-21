class uartt_sequencer extends uvm_sequencer #(uartt_item);
    `uvm_component_utils(uartt_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : uartt_sequencer