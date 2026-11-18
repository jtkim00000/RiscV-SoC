class mux_sequencer extends uvm_sequencer #(mux_item_t);
    `uvm_component_utils(mux_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : mux_sequencer