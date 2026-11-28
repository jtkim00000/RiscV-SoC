module if_id (if_id_if.DUT if_id_if);

    always_ff @(posedge if_id_if.clk) begin
        if(if_id_if.FLUSH_E) begin
            if_id_if.Instr_D <= 32'd0;
            if_id_if.PC_D <= 32'd0;
            if_id_if.PC_Plus_4_D <= 32'd0;
        end
        else begin
            if_id_if.Instr_D <= if_id_if.Instr_F;
            if_id_if.PC_D <= if_id_if.PC_F;
            if_id_if.PC_Plus_4_D <= if_id_if.PC_Plus_4_F;
        end
    end

endmodule : if_id