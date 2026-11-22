class uartr_item extends uvm_sequence_item;

    rand bit reset, rx;
    logic [7:0] data;
    logic valid;
    logic framing_error;
    
    constraint reset_dist_c {
        reset dist {
            0 := 999,
            1 := 1
        };
    }

    `uvm_object_utils_begin(uartr_item)
        `uvm_field_int(reset, UVM_ALL_ON)
        `uvm_field_int(rx, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(valid, UVM_ALL_ON)
        `uvm_field_int(framing_error, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "uartr_item");
        super.new(name);
    endfunction

endclass : uartr_item