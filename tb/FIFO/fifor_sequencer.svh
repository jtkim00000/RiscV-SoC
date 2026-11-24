class fifor_sequencer extends uvm_sequencer #(fifor_item);
    `uvm_component_utils(fifor_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : fifor_sequencer