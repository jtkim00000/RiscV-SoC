module mem_wb (mem_wb_if.DUT mem_wb_if);

    always_ff @(mem_wb_if.clk) begin
        mem_wb_if.Instr_W <= mem_wb_if.Instr_M;
        mem_wb_if.Imm_W <= mem_wb_if.Imm_M;
        mem_wb_if.ALU_W <= mem_wb_if.ALU_M;
        mem_wb_if.MEM_W <= mem_wb_if.MEM_M;
        mem_wb_if.MUL_W <= mem_wb_if.MUL_M;
        mem_wb_if.PC_Plus_4_W <= mem_wb_if.PC_Plus_4_M;
        mem_wb_if.REG_MUX_W <= mem_wb_if.REG_MUX_M;
        mem_wb_if.REG_EN_W <= mem_wb_if.REG_EN_M;
    end

endmodule : mem_wb