class sram_sequencer extends uvm_sequencer #(sram_item);
    `uvm_component_utils(sram_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : sram_sequencer