class control_unit_item extends uvm_sequence_item;
    
    rand bit [31:0] instr;
    randc bit [6:0] opcode;
    rand bit [2:0] funct3;
    rand bit [6:0] funct7;
    
    logic reg_en;
    logic [2:0] regmux;
    logic alumux1;
    logic alumux2;
    logic [3:0] alu_sel;
    logic [2:0] mul_sel;
    logic jump;
    logic br_en;
    logic jalr;
    logic we;
    logic sz;
    logic [1:0] num_bytes;

    constraint instr_opcode_c {
        opcode inside {
            7'b0110011,
            7'b0010011,
            7'b0000011,
            7'b1100111,
            // 7'b1110011, ebrake and ecall not implemented for now
            7'b0100011,
            7'b1100011,
            7'b0110111,
            7'b0010111,
            7'b1101111
        };
    }

    constraint instr_func3_c {
        if (opcode == 7'b0000011) {
            funct3 inside {
                3'b000,
                3'b001,
                3'b010,
                3'b100,
                3'b101
            };
        } else if (opcode == 7'b1100111) {
            funct3 == 3'b000;
        } else if (opcode == 7'b0100011) {
            funct3 inside {
                3'b000,
                3'b001,
                3'b010
            };
        } else if (opcode == 7'b1100011) {
            funct3 inside {
                3'b000,
                3'b001,
                3'b100,
                3'b101,
                3'b110,
                3'b111
            };
        } 
    }

    constraint instr_funct7_c {
        if (opcode == 7'b0110011) {
            // Register-register: base integer or M extension.
            funct7 inside {
                7'b0000000,
                7'b0000001,
                7'b0100000
            };

            // funct7=0x20 is legal only for SUB and SRA.
            if (funct7 == 7'b0100000)
                funct3 inside {3'b000, 3'b101};
        }

        if (opcode == 7'b0010011) {
            // SLLI
            if (funct3 == 3'b001)
                funct7 == 7'b0000000;

            // SRLI or SRAI
            if (funct3 == 3'b101)
                funct7 inside {7'b0000000, 7'b0100000};
        }
    }

    constraint instr_c {
        instr[6:0] == opcode;
        instr[31:25] == funct7;
        instr[14:12] == funct3;
    }

    `uvm_object_utils_begin(control_unit_item)
        `uvm_field_int(instr, UVM_ALL_ON)
        `uvm_field_int(opcode, UVM_ALL_ON)
        `uvm_field_int(reg_en, UVM_ALL_ON)
        `uvm_field_int(regmux, UVM_ALL_ON)
        `uvm_field_int(alumux1, UVM_ALL_ON)
        `uvm_field_int(alumux2, UVM_ALL_ON)
        `uvm_field_int(alu_sel, UVM_ALL_ON)
        `uvm_field_int(mul_sel, UVM_ALL_ON)
        `uvm_field_int(jump, UVM_ALL_ON)
        `uvm_field_int(br_en, UVM_ALL_ON)
        `uvm_field_int(jalr, UVM_ALL_ON)
        `uvm_field_int(we, UVM_ALL_ON)
        `uvm_field_int(sz, UVM_ALL_ON)
        `uvm_field_int(num_bytes, UVM_ALL_ON)

    `uvm_object_utils_end

    function new(string name = "control_unit_item");
        super.new(name);
    endfunction : new

endclass : control_unit_item