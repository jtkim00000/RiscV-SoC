class mux_item #(
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned INPUT_WIDTH = 2,
    parameter int unsigned SELECT_BITS =
        (INPUT_WIDTH > 1) ? $clog2(INPUT_WIDTH) : 1
) extends uvm_sequence_item;
    
    rand bit [DATA_WIDTH*INPUT_WIDTH-1:0] data_in;
    rand bit [SELECT_BITS-1:0]            sel;

    logic [DATA_WIDTH-1:0] data_out;

    constraint selection_c {
        sel < INPUT_WIDTH;
    }

    `uvm_object_param_utils_begin(
        mux_item #(DATA_WIDTH, INPUT_WIDTH, SELECT_BITS))
        `uvm_field_int(data_in,  UVM_ALL_ON)
        `uvm_field_int(sel,      UVM_ALL_ON)
        `uvm_field_int(data_out, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "mux_item");
        super.new(name);
    endfunction : new

endclass : mux_item