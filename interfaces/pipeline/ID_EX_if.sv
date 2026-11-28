interface id_ex_if (input bit clk);

    logic FLUSH_E;
    logic [31:0] PC_D, PC_E;
    logic [31:0] Instr_D, Instr_E;
    logic [31:0] Imm_D, Imm_E;
    logic [31:0] RS1_D, RS1_E;
    logic [31:0] RS2_D, RS2_E;
    logic [31:0] PC_Plus_4_D, PC_Plus_4_E;

    logic [1:0] REG_MUX_D, REG_MUX_E;
    logic REG_EN_D, REG_EN_E;
    logic WE_D, WE_E;
    logic SZ_D, SZ_E;
    logic [1:0] NUM_BYTES_D, NUM_BYTES_E;
    logic JUMP_D, JUMP_E;
    logic JALR_D, JALR_E;
    logic [3:0] ALU_SEL_D, ALU_SEL_E;
    logic ALUMUX1_D, ALUMUX1_E;
    logic ALUMUX2_D, ALUMUX2_E;
    logic BR_EN_D, BR_EN_E;
    logic [2:0] MUL_SEL_D, MUL_SEL_E;

    clocking id_ex_cb @(posedge clk)
        default input #1step output #0;
        input PC_E, Instr_E, Imm_E, RS1_E, RS2_E, PC_Plus_4_E;
        input REG_MUX_E, REG_EN_E, WE_E, SZ_E, NUM_BYTES_E, JUMP_E, JALR_E, ALU_SEL_E, ALUMUX1_E, ALUMUX2_E, BR_EN_E, MUL_SEL_E;
        output FLUSH_E, PC_D, Instr_D, Imm_D, RS1_D, RS2_D, PC_Plus_4_D;
        output REG_MUX_D, REG_EN_D, WE_D, SZ_D, NUM_BYTES_D, JUMP_D, JALR_D, ALU_SEL_D, ALUMUX1_D, ALUMUX2_D, BR_EN_D, MUL_SEL_E;
    endclocking : id_ex_cb

    clocking id_ex_cbm @(posedge clk)
        default input #1step;
        input FLUSH_E, PC_D, Instr_D, Imm_D, RS1_D, RS2_D,PC_Plus_4_D, PC_E, Instr_E, Imm_E, RS1_E, RS2_E, PC_Plus_4_E;
        input REG_MUX_D, REG_EN_D, WE_D, SZ_D, NUM_BYTES_D, JUMP_D, JALR_D, ALU_SEL_D, ALUMUX1_D, ALUMUX2_D, BR_EN_D;
        input REG_MUX_E, REG_EN_E, WE_E, SZ_E, NUM_BYTES_E, JUMP_E, JALR_E, ALU_SEL_E, ALUMUX1_E, ALUMUX2_E, BR_EN_E;
    endclocking : id_ex_cbm

    modport DUT (
        input clk, FLUSH_E, PC_D, Instr_D, Imm_D, RS1_D, RS2_D, PC_Plus_4_D, 
        REG_MUX_D, REG_EN_D, WE_D, SZ_D, NUM_BYTES_D, JUMP_D, JALR_D, ALU_SEL_D, ALUMUX1_D, ALUMUX2_D, BR_EN_D, MUL_SEL_D,
        output PC_E, Instr_E, Imm_E, RS1_E, RS2_E, PC_Plus_4_E, 
        REG_MUX_E, REG_EN_E, WE_E, SZ_E, NUM_BYTES_E, JUMP_E, JALR_E, ALU_SEL_E, ALUMUX1_E, ALUMUX2_E, BR_EN_E, MUL_SEL_E
    );

    modport TEST (clocking id_ex_cb);

    modport MONITOR (clocking id_ex_cbm);

endinterface : id_ex_if