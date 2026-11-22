class uartr_item extends uvm_sequence_item;

    rand bit [7:0] send_data;
    bit bad_stop = 0;

    logic rx;
    logic reset;
    logic [7:0] data;
    logic valid;
    logic framing_error;

    `uvm_object_utils_begin(uartr_item)
        `uvm_field_int(send_data, UVM_ALL_ON)
        `uvm_field_int(reset, UVM_ALL_ON)
        `uvm_field_int(rx, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(valid, UVM_ALL_ON)
        `uvm_field_int(framing_error, UVM_ALL_ON)
        `uvm_field_int(bad_stop, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "uartr_item");
        super.new(name);
    endfunction

endclass : uartr_item