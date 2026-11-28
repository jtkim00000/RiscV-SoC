module id_ex (id_ex_if.DUT id_ex_if);

    always_ff @(posedge id_ex_if.clk) begin
        if(id_ex_if.FLUSH_E) begin
            id_ex_if.PC_E <= 32'd0;
            id_ex_if.Instr_E <= 32'd0;
            id_ex_if.Imm_E <= 32'd0;
            id_ex_if.RS1_E <= 32'd0;
            id_ex_if.RS2_E <= 32'd0;
            id_ex_if.PC_Plus_4_E <= 32'd0;
            id_ex_if.REG_MUX_E <= 2'd0;
            id_ex_if.REG_EN_E <= 1'b0;
            id_ex_if.WE_E <= 1'b0;
            id_ex_if.SZ_E <= 1'b0;
            id_ex_if.NUM_BYTES_E <= 2'd0;
            id_ex_if.JUMP_E <= 1'b0;
            id_ex_if.JALR_E <= 1'b0;
            id_ex_if.ALU_SEL_E <= 4'd0;
            id_ex_if.ALUMUX1_E <= 1'b0;
            id_ex_if.ALUMUX2_E <= 1'b0;
            id_ex_if.BR_EN_E <= 1'b0;
            id_ex_if.MUL_SEL_E <= 3'd0;
        end
        else begin
            id_ex_if.PC_E <= id_ex_if.PC_D;
            id_ex_if.Instr_E <= id_ex_if.Instr_D;
            id_ex_if.Imm_E <= id_ex_if.Imm_D;
            id_ex_if.RS1_E <= id_ex_if.RS1_D;
            id_ex_if.RS2_E <= id_ex_if.RS2_D;
            id_ex_if.PC_Plus_4_E <= id_ex_if.PC_Plus_4_D;
            id_ex_if.REG_MUX_E <= id_ex_if.REG_MUX_D;
            id_ex_if.REG_EN_E <= id_ex_if.REG_EN_D;
            id_ex_if.WE_E <= id_ex_if.WE_D;
            id_ex_if.SZ_E <= id_ex_if.SZ_D;
            id_ex_if.NUM_BYTES_E <= id_ex_if.NUM_BYTES_D;
            id_ex_if.JUMP_E <= id_ex_if.JUMP_D;
            id_ex_if.JALR_E <= id_ex_if.JALR_D;
            id_ex_if.ALU_SEL_E <= id_ex_if.ALU_SEL_D;
            id_ex_if.ALUMUX1_E <= id_ex_if.ALUMUX1_D;
            id_ex_if.ALUMUX2_E <= id_ex_if.ALUMUX2_D;
            id_ex_if.BR_EN_E <= id_ex_if.BR_EN_D;
            id_ex_if.MUL_SEL_E <= id_ex_if.MUL_SEL_D;
        end
    end

endmodule : id_ex