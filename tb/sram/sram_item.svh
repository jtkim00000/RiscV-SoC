class sram_item extends uvm_sequence_item;

    rand bit write_enable, sz;
    rand bit [1:0] num_bytes;
    rand bit [31:0] write_data;
    randc bit [31:0] addr; // limit to specific addresses for simulation
    logic [31:0] read_data;

    constraint write_data_c {
        addr < 15;    // Limit to 16 addresses for simulation
        num_bytes != 2'b10; // can't read or write 3 bytes
    }

    `uvm_object_utils_begin(sram_item)
        `uvm_field_int(write_enable, UVM_ALL_ON)
        `uvm_field_int(sz, UVM_ALL_ON)
        `uvm_field_int(num_bytes, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(write_data, UVM_ALL_ON)
        `uvm_field_int(read_data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "sram_item");
        super.new(name);
    endfunction

endclass : sram_item