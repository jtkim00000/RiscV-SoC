class uartt_item extends uvm_sequence_item;

    rand bit reset, start;
    rand bit [7:0] data;
    logic tx;
    logic busy;
    
    constraint reset_dist_c {
        reset dist {
            0 := 95,
            1 := 5
        };
    }

    `uvm_object_utils_begin(uartt_item)
        `uvm_field_int(reset, UVM_ALL_ON)
        `uvm_field_int(start, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(tx, UVM_ALL_ON)
        `uvm_field_int(busy, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "uartt_item");
        super.new(name);
    endfunction

endclass : uartt_item