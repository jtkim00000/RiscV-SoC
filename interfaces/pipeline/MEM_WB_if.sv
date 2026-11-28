interface mem_wb_if (input bit clk);

    logic [31:0] Instr_M, Instr_W;
    logic [31:0] Imm_M, Imm_W;
    logic [31:0] ALU_M, ALU_W;
    logic [31:0] MEM_M, MEM_W;
    logic [31:0] MUL_M, MUL_W;
    logic [31:0] PC_Plus_4_M, PC_Plus_4_W;

    logic [1:0] REG_MUX_M, REG_MUX_W;
    logic REG_EN_M, REG_EN_W;

    clocking mem_wb_cb @(posedge clk)
        default input #1step output #0;
        input Instr_W, Imm_W, ALU_W, MEM_W, MUL_W, PC_Plus_4_W, REG_MUX_W, REG_EN_W;
        output Instr_M, Imm_M, ALU_M, MEM_M, MUL_M. PC_Plus_4_M, REG_MUX_M, REG_EN_M;
    endclocking : mem_wb_cb

    clocking mem_wb_cbm @(posedge clk)
        default input #1step output #0;
        input Instr_M, Imm_M, ALU_M, MEM_M, MUL_M. PC_Plus_4_M, REG_MUX_M, REG_EN_M;
        input Instr_W, Imm_W, ALU_W, MEM_W, MUL_W, PC_Plus_4_W, REG_MUX_W, REG_EN_W;
    endclocking : mem_wb_cbm

    modport DUT (
        input Instr_M, Imm_M, ALU_M, MEM_M, MUL_M. PC_Plus_4_M, REG_MUX_M, REG_EN_M,
        output Instr_W, Imm_W, ALU_W, MEM_W, MUL_W, PC_Plus_4_W, REG_MUX_W, REG_EN_W
    );

    modport TEST (clocking mem_wb_cb);

    modport MONITOR (clocking mem_wb_cbm);

endinterface : mem_wb_if