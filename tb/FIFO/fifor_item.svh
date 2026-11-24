class fifor_item extends uvm_sequence_item;

    rand bit reset;
    rand bit read;
    rand bit write;
    rand bit [31:0] write_data;
    logic [31:0] read_data;
    logic empty;
    logic full;


    constraint dist_reset_c {
        reset dist {
            reset := 5,
            reset := 95
        };
    }

    `uvm_object_utils_begin(fifor_item)
        `uvm_field_int(reset, UVM_ALL_ON)
        `uvm_field_int(read, UVM_ALL_ON)
        `uvm_field_int(write, UVM_ALL_ON)
        `uvm_field_int(write_data, UVM_ALL_ON)
        `uvm_field_int(read_data, UVM_ALL_ON)
        `uvm_field_int(empty, UVM_ALL_ON)
        `uvm_field_int(full, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "fifor_item");
        super.new(name);
    endfunction

endclass : fifor_item