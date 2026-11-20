class control_unit_coverage extends uvm_subscriber #(control_unit_item);
    `uvm_component_utils(control_unit_coverage)

    covergroup cg_control_unit_transaction with function sample(
        bit [6:0] opcode,
        bit [2:0] funct3,
        bit [6:0] funct7
    );
        option.per_instance = 1;

        cp_opcode: coverpoint opcode {
            bins arithmetic     = {7'b0110011};
            bins arithmetic_imm = {7'b0010011};
            bins load           = {7'b0000011};
            bins jalr           = {7'b1100111};
            bins system_op      = {7'b1110011};
            bins store          = {7'b0100011};
            bins branch         = {7'b1100011};
            bins lui            = {7'b0110111};
            bins auipc          = {7'b0010111};
            bins jal            = {7'b1101111};
            bins invalid_opcode = {7'b0000000};
        }

        // Register-register instructions:
        // concatenation = {7-bit funct7, 3-bit funct3}.
        cp_register_op: coverpoint {funct7, funct3}
            iff (opcode == 7'b0110011) {

            // funct7=0, each funct3 gets a separate bin.
            bins base_ops[] = {[10'h000:10'h007]};

            // funct7=1, each funct3 gets a separate bin.
            bins mul_div_ops[] = {[10'h008:10'h00F]};

            // funct7=0x20 is legal only for these two.
            bins sub = {10'h100};
            bins sra = {10'h105};
        }

        // Non-shift immediate arithmetic:
        // bits [31:25] belong to the immediate, so don't restrict them.
        cp_immediate_op: coverpoint funct3
            iff (opcode == 7'b0010011) {
            bins addi  = {3'b000};
            bins slti  = {3'b010};
            bins sltiu = {3'b011};
            bins xori  = {3'b100};
            bins ori   = {3'b110};
            bins andi  = {3'b111};
        }

        // Shift-immediate instructions do use funct7.
        cp_immediate_shift: coverpoint {funct7, funct3}
            iff (opcode == 7'b0010011 &&
                 funct3 inside {3'b001, 3'b101}) {
            bins slli = {10'h001};
            bins srli = {10'h005};
            bins srai = {10'h105};
        }

        cp_load: coverpoint funct3
            iff (opcode == 7'b0000011) {
            bins lb  = {3'b000};
            bins lh  = {3'b001};
            bins lw  = {3'b010};
            bins lbu = {3'b100};
            bins lhu = {3'b101};
        }

        cp_store: coverpoint funct3
            iff (opcode == 7'b0100011) {
            bins sb = {3'b000};
            bins sh = {3'b001};
            bins sw = {3'b010};
        }

        cp_branch: coverpoint funct3
            iff (opcode == 7'b1100011) {
            bins beq  = {3'b000};
            bins bne  = {3'b001};
            bins blt  = {3'b100};
            bins bge  = {3'b101};
            bins bltu = {3'b110};
            bins bgeu = {3'b111};
        }

        cp_jalr: coverpoint funct3
            iff (opcode == 7'b1100111) {
            bins jalr = {3'b000};
        }

        // This covers only the SYSTEM funct3 category,
        // not individual instructions such as ECALL/EBREAK.
        cp_system: coverpoint funct3
            iff (opcode == 7'b1110011) {
            bins privileged_category = {3'b000};
        }

    endgroup : cg_control_unit_transaction

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_control_unit_transaction = new();
    endfunction : new

    virtual function void write(control_unit_item t);
        // Derive fields from the instruction actually observed.
        cg_control_unit_transaction.sample(
            t.instr[6:0],
            t.instr[14:12],
            t.instr[31:25]
        );
    endfunction : write

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("CONTROL_COVERAGE",
            $sformatf("Functional coverage: %0.2f%%",
                      cg_control_unit_transaction.get_inst_coverage()),
            UVM_LOW)
    endfunction : report_phase

endclass : control_unit_coverage