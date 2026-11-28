interface ex_mem_if (input bit clk);

    logic [31:0] Instr_E, Instr_M;
    logic [31:0] Imm_E, Imm_M;
    logic [31:0] ALU_E, ALU_M;
    logic [31:0] MUL_E, MUL_M;
    logic [31:0] RS2_E, RS2_M;
    logic [31:0] PC_Plus_4_E, PC_Plus_4_M;

    logic [1:0] REG_MUX_E, REG_MUX_M;
    logic REG_EN_E, REG_EN_M;
    logic WE_E, WE_M;
    logic SZ_E, SZ_M;
    logic [1:0] NUM_BYTES_E, NUM_BYTES_M;

    clocking ex_mem_cb @(posedge clk)
        default input #1step output #0;
        input Instr_M, Imm_M, ALU_M, MUL_M, RS2_M, PC_Plus_4_M;
        input REG_MUX_M, REG_EN_M, WE_M, SZ_M. NUM_BYTES_M;
        output Instr_E, Imm_E, ALU_E, MUL_E, RS2_E, PC_Plus_4_E;
        output REG_MUX_E, REG_EN_E, WE_E, SZ_E, NUM_BYTES_E;
    endclocking : ex_mem_cb

    clocking ex_mem_cbm @(posedge clk)
        default input #1step;
        input Instr_E, Imm_E, ALU_E, MUL_E, RS2_E, PC_Plus_4_E;
        input REG_MUX_E, REG_EN_E, WE_E, SZ_E, NUM_BYTES_E;
        input Instr_M, Imm_M, ALU_M, MUL_M, RS2_M, PC_Plus_4_M;
        input REG_MUX_M, REG_EN_M, WE_M, SZ_M. NUM_BYTES_M;
    endclocking : ex_mem_cbm

    modport DUT (
        input Instr_E, Imm_E, ALU_E, MUL_E, RS2_E, PC_Plus_4_E,
        REG_MUX_E, REG_EN_E, WE_E, SZ_E, NUM_BYTES_E,
        output Instr_M, Imm_M, ALU_M, MUL_M, RS2_M, PC_Plus_4_M,
        REG_MUX_M, REG_EN_M, WE_M, SZ_M. NUM_BYTES_M
    );

    modport TEST (clocking ex_mem_cb);

    modport MONITOR (clocking ex_mem_cbm);

endinterface : ex_mem_if