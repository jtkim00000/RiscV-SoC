module control_unit (control_unit_if.DUT control_unitif);
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = control_unitif.instr[6:0];
    assign funct3 = control_unitif.instr[14:12];
    assign funct7 = control_unitif.instr[31:25];

    always_comb begin
        case(opcode)
            7'b0110011: begin //Register-Register AL
                control_unitif.reg_en = 1'b1; 
                control_unitif.alumux1 = 1'b1; control_unitif.alumux2 = 1'b0;
                control_unitif.jump = 1'b0; control_unitif.br_en = 1'b0; control_unitif.jalr = 1'b0;
                control_unitif.we = 1'b0; control_unitif.sz = 1'b0; control_unitif.num_bytes = 2'b00;
                case(funct7)
                    7'd1: begin // multiply
                        control_unitif.regmux = 3'b100;
                        control_unitif.mul_sel = funct3;
                        control_unitif.alu_sel = 4'd0;
                    end
                    default: begin // alu
                        control_unitif.regmux = 3'b001;
                        control_unitif.mul_sel = 3'd0;
                        case(funct3)
                            3'd0: begin
                                case(funct7)
                                    7'd0: control_unitif.alu_sel = 4'b0000;
                                    7'd32: control_unitif.alu_sel = 4'b0001;
                                    default: control_unitif.alu_sel = 4'b0000;
                                endcase
                            end
                            3'd4: control_unitif.alu_sel = 4'b0010;
                            3'd6: control_unitif.alu_sel = 4'b0011;
                            3'd7: control_unitif.alu_sel = 4'b0100;
                            3'd1: control_unitif.alu_sel = 4'b0101;
                            3'd5: begin
                                case(funct7)
                                    7'd0: control_unitif.alu_sel = 4'b0110;
                                    7'd32: control_unitif.alu_sel = 4'b0111;
                                    default: control_unitif.alu_sel = 4'b0000;
                                endcase
                            end
                            3'd2: control_unitif.alu_sel = 4'b1000;
                            3'd3: control_unitif.alu_sel = 4'b1001;
                            default: control_unitif.alu_sel = 4'b0000;
                        endcase
                    end
                endcase
            end
            7'b0010011: begin //Register-Immediate AL
                control_unitif.reg_en = 1'b1; control_unitif.regmux = 3'b001;
                control_unitif.alumux1 = 1'b1; control_unitif.alumux2 = 1'b1; control_unitif.mul_sel = 3'b000;
                control_unitif.jump = 1'b0; control_unitif.br_en = 1'b0; control_unitif.jalr = 1'b0;
                control_unitif.we = 1'b0; control_unitif.sz = 1'b0; control_unitif.num_bytes = 2'b00;
                case(funct3)
                    3'd0: control_unitif.alu_sel = 4'b0000;
                    3'd4: control_unitif.alu_sel = 4'b0010;
                    3'd6: control_unitif.alu_sel = 4'b0011;
                    3'd7: control_unitif.alu_sel = 4'b0100;
                    3'd1: control_unitif.alu_sel = 4'b0101;
                    3'd5: begin
                        case(funct7)
                            7'd0: control_unitif.alu_sel = 4'b0110;
                            7'd32: control_unitif.alu_sel = 4'b0111;
                            default: control_unitif.alu_sel = 4'b0000;
                        endcase
                    end
                    3'd2: control_unitif.alu_sel = 4'b1000;
                    3'd3: control_unitif.alu_sel = 4'b1001;
                    default: control_unitif.alu_sel = 4'b0000;
                endcase
            end
            7'b0000011: begin //Load
                control_unitif.reg_en = 1'b1; control_unitif.regmux = 3'b010;
                control_unitif.alumux1 = 1'b1; control_unitif.alumux2 = 1'b1; control_unitif.alu_sel = 4'b0000; control_unitif.mul_sel = 3'b000;
                control_unitif.jump = 1'b0; control_unitif.br_en = 1'b0; control_unitif.jalr = 1'b0;
                control_unitif.we = 1'b0;
                case(funct3)
                    3'd0: begin 
                        control_unitif.num_bytes = 2'b00;
                        control_unitif.sz = 1'b1;
                    end
                    3'd1: begin 
                        control_unitif.num_bytes = 2'b01;
                        control_unitif.sz = 1'b1;
                    end
                    3'd2: begin 
                        control_unitif.num_bytes = 2'b11;
                        control_unitif.sz = 1'b0;
                    end
                    3'd4: begin 
                        control_unitif.num_bytes = 2'b00;
                        control_unitif.sz = 1'b0;
                    end
                    3'd5: begin 
                        control_unitif.num_bytes = 2'b01;
                        control_unitif.sz = 1'b0;
                    end
                    default: begin 
                        control_unitif.num_bytes = 2'b11;
                        control_unitif.sz = 1'b0;
                    end
                endcase
            end
            7'b0100011: begin //Store
                control_unitif.reg_en = 1'b0; control_unitif.regmux = 3'b000;
                control_unitif.alumux1 = 1'b1; control_unitif.alumux2 = 1'b1; control_unitif.alu_sel = 4'b0000; control_unitif.mul_sel = 3'b000;
                control_unitif.jump = 1'b0; control_unitif.br_en = 1'b0; control_unitif.jalr = 1'b0;
                control_unitif.we = 1'b1; control_unitif.sz = 1'b0;
                case(funct3)
                    3'd0: control_unitif.num_bytes = 2'b00;
                    3'd1: control_unitif.num_bytes = 2'b01;
                    3'd2: control_unitif.num_bytes = 2'b11;
                    default: control_unitif.num_bytes = 2'b11;
                endcase
            end
            7'b1100011: begin //Branch
                control_unitif.reg_en = 1'b0; control_unitif.regmux = 3'b000;
                control_unitif.alumux1 = 1'b1; control_unitif.alumux2 = 1'b0; control_unitif.mul_sel = 3'b000;
                control_unitif.jump = 1'b0; control_unitif.br_en = 1'b1; control_unitif.jalr = 1'b0;
                control_unitif.we = 1'b0; control_unitif.sz = 1'b0; control_unitif.num_bytes = 2'b00;
                case(funct3)
                    3'd0: control_unitif.alu_sel = 4'b1010;
                    3'd1: control_unitif.alu_sel = 4'b1011;
                    3'd4: control_unitif.alu_sel = 4'b1100;
                    3'd5: control_unitif.alu_sel = 4'b1101;
                    3'd6: control_unitif.alu_sel = 4'b1110;
                    3'd7: control_unitif.alu_sel = 4'b1111;
                    default: control_unitif.alu_sel = 4'b0000;
                endcase

            end
            7'b1101111: begin //JAL
                control_unitif.reg_en = 1'b1; control_unitif.regmux = 3'b000;
                control_unitif.alumux1 = 1'b0; control_unitif.alumux2 = 1'b1; control_unitif.alu_sel = 4'b0000; control_unitif.mul_sel = 3'b000;
                control_unitif.jump = 1'b1; control_unitif.br_en = 1'b0; control_unitif.jalr = 1'b0;
                control_unitif.we = 1'b0; control_unitif.sz = 1'b0; control_unitif.num_bytes = 2'b00;
            end
            7'b1100111: begin //control_unitif.jalr
                control_unitif.reg_en = 1'b1; control_unitif.regmux = 3'b000;
                control_unitif.alumux1 = 1'b1; control_unitif.alumux2 = 1'b1; control_unitif.alu_sel = 4'b0000; control_unitif.mul_sel = 3'b000;
                control_unitif.jump = 1'b1; control_unitif.br_en = 1'b0; control_unitif.jalr = 1'b1;
                control_unitif.we = 1'b0; control_unitif.sz = 1'b0; control_unitif.num_bytes = 2'b00;
            end
            7'b0110111: begin //LUI
                control_unitif.reg_en = 1'b1; control_unitif.regmux = 3'b011;
                control_unitif.alumux1 = 1'b0; control_unitif.alumux2 = 1'b0; control_unitif.alu_sel = 4'b0000; control_unitif.mul_sel = 3'b000;
                control_unitif.jump = 1'b0; control_unitif.br_en = 1'b0; control_unitif.jalr = 1'b0;
                control_unitif.we = 1'b0; control_unitif.sz = 1'b0; control_unitif.num_bytes = 2'b00;
            end
            7'b0010111: begin //AUIPC
                control_unitif.reg_en = 1'b1; control_unitif.regmux = 3'b001;
                control_unitif.alumux1 = 1'b0; control_unitif.alumux2 = 1'b1; control_unitif.alu_sel = 4'b0000; control_unitif.mul_sel = 3'b000;
                control_unitif.jump = 1'b0; control_unitif.br_en = 1'b0; control_unitif.jalr = 1'b0;
                control_unitif.we = 1'b0; control_unitif.sz = 1'b0; control_unitif.num_bytes = 2'b00;
            end
            default: begin
                control_unitif.reg_en = 1'b0;
                control_unitif.regmux = 3'b000;
                control_unitif.alumux1 = 1'b0;
                control_unitif.alumux2 = 1'b0;
                control_unitif.alu_sel = 4'b0000; control_unitif.mul_sel = 3'b000;
                control_unitif.jump = 1'b0;
                control_unitif.br_en = 1'b0;
                control_unitif.jalr = 1'b0;
                control_unitif.we = 1'b0;
                control_unitif.sz = 1'b0;
                control_unitif.num_bytes = 2'b00;
            end
        endcase
    end

endmodule