module ex_mem (ex_mem_if.DUT ex_mem_if);

    always_ff @(posedge ex_mem_if.clk) begin
        ex_mem_if.Instr_M <= ex_mem_if.Instr_E;
        ex_mem_if.Imm_M <= ex_mem_if.Imm_E;
        ex_mem_if.ALU_M <= ex_mem_if.ALU_E;
        ex_mem_if.MUL_M <= ex_mem_if.MUL_E;
        ex_mem_if.RS2_M <= ex_mem_if.RS2_E;
        ex_mem_if.PC_Plus_4_M <= ex_mem_if.PC_Plus_4_E;
        ex_mem_if.REG_MUX_M <= ex_mem_if.REG_MUX_E;
        ex_mem_if.REG_MN_M <= ex_mem_if.REG_MN_E;
        ex_mem_if.WE_M <= ex_mem_if.WE_E;
        ex_mem_if.SZ_M <= ex_mem_if.SZ_E;
        ex_mem_if.NUM_BYTES_M <= ex_mem_if.NUM_BYTES_E;
    end

endmodule : ex_mem