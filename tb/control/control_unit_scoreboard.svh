class control_unit_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(control_unit_scoreboard)

    uvm_analysis_imp #(
        control_unit_item,
        control_unit_scoreboard
    ) ap_imp;

    int unsigned check_count = 0;
    int unsigned mismatch_count = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction : build_phase

    virtual function void write(control_unit_item tr);
        logic [6:0] opcode;
        logic [2:0] funct3;
        logic [6:0] funct7;
        control_unit_item expected;

        opcode = tr.instr[6:0];
        funct3 = tr.instr[14:12];
        funct7 = tr.instr[31:25];

        expected = control_unit_item::type_id::create("expected");

        expected.instr = tr.instr;

        // These are stimulus helper fields, not DUT outputs.
        // Copy them so they cannot cause unrelated compare failures.
        expected.opcode = tr.opcode;
        expected.funct3 = tr.funct3;
        expected.funct7 = tr.funct7;

        case (opcode)
            7'b0110011: begin // Register-register ALU or M extension
                expected.reg_en = 1'b1;
                expected.alumux1 = 1'b1;
                expected.alumux2 = 1'b0;
                expected.jump = 1'b0;
                expected.br_en = 1'b0;
                expected.jalr = tr.jalr;
                expected.we = 1'b0;
                expected.sz = tr.sz;
                expected.num_bytes = tr.num_bytes;

                if (funct7 == 7'd1) begin
                    expected.regmux = 3'b100;
                    expected.mul_sel = funct3;
                    expected.alu_sel = tr.alu_sel;
                end
                else begin
                    expected.regmux = 3'b001;
                    expected.mul_sel = tr.mul_sel;

                    case (funct3)
                        3'd0: begin
                            case (funct7)
                                7'd0:  expected.alu_sel = 4'b0000;
                                7'd32: expected.alu_sel = 4'b0001;
                                default: begin
                                    `uvm_error("CONTROL_ERROR",
                                        "Register arithmetic encoding not specified")
                                    return;
                                end
                            endcase
                        end

                        3'd1: expected.alu_sel = 4'b0101;
                        3'd2: expected.alu_sel = 4'b1000;
                        3'd3: expected.alu_sel = 4'b1001;
                        3'd4: expected.alu_sel = 4'b0010;

                        3'd5: begin
                            case (funct7)
                                7'd0:  expected.alu_sel = 4'b0110;
                                7'd32: expected.alu_sel = 4'b0111;
                                default: begin
                                    `uvm_error("CONTROL_ERROR",
                                        "Register shift encoding not specified")
                                    return;
                                end
                            endcase
                        end

                        3'd6: expected.alu_sel = 4'b0011;
                        3'd7: expected.alu_sel = 4'b0100;
                    endcase
                end
            end

            7'b0010011: begin // Register-immediate arithmetic
                expected.reg_en = 1'b1;
                expected.regmux = 3'b001;
                expected.alumux1 = 1'b1;
                expected.alumux2 = 1'b1;
                expected.jump = 1'b0;
                expected.br_en = 1'b0;
                expected.jalr = tr.jalr;
                expected.we = 1'b0;
                expected.sz = tr.sz;
                expected.num_bytes = tr.num_bytes;
                expected.mul_sel = tr.mul_sel;

                case (funct3)
                    3'd0: expected.alu_sel = 4'b0000;
                    3'd1: expected.alu_sel = 4'b0101;
                    3'd2: expected.alu_sel = 4'b1000;
                    3'd3: expected.alu_sel = 4'b1001;
                    3'd4: expected.alu_sel = 4'b0010;

                    3'd5: begin
                        case (funct7)
                            7'd0:  expected.alu_sel = 4'b0110;
                            7'd32: expected.alu_sel = 4'b0111;
                            default: begin
                                `uvm_error("CONTROL_ERROR",
                                    "Immediate shift encoding not specified")
                                return;
                            end
                        endcase
                    end

                    3'd6: expected.alu_sel = 4'b0011;
                    3'd7: expected.alu_sel = 4'b0100;
                endcase
            end

            7'b0000011: begin // Load
                expected.reg_en = 1'b1;
                expected.regmux = 3'b010;
                expected.alumux1 = 1'b1;
                expected.alumux2 = 1'b1;
                expected.alu_sel = 4'b0000;
                expected.jump = 1'b0;
                expected.br_en = 1'b0;
                expected.jalr = tr.jalr;
                expected.we = 1'b0;
                expected.mul_sel = tr.mul_sel;

                case (funct3)
                    3'd0: begin // LB
                        expected.sz = 1'b1;
                        expected.num_bytes = 2'b00;
                    end
                    3'd1: begin // LH
                        expected.sz = 1'b1;
                        expected.num_bytes = 2'b01;
                    end
                    3'd2: begin // LW
                        expected.sz = tr.sz;
                        expected.num_bytes = 2'b11;
                    end
                    3'd4: begin // LBU
                        expected.sz = 1'b0;
                        expected.num_bytes = 2'b00;
                    end
                    3'd5: begin // LHU
                        expected.sz = 1'b0;
                        expected.num_bytes = 2'b01;
                    end
                    default: begin
                        `uvm_error("CONTROL_ERROR",
                            "Load encoding not specified")
                        return;
                    end
                endcase
            end

            7'b0100011: begin // Store
                expected.reg_en = 1'b0;
                expected.regmux = tr.regmux;
                expected.alumux1 = 1'b1;
                expected.alumux2 = 1'b1;
                expected.alu_sel = 4'b0000;
                expected.jump = 1'b0;
                expected.br_en = 1'b0;
                expected.jalr = tr.jalr;
                expected.we = 1'b1;
                expected.sz = tr.sz;
                expected.mul_sel = tr.mul_sel;

                case (funct3)
                    3'd0: expected.num_bytes = 2'b00;
                    3'd1: expected.num_bytes = 2'b01;
                    3'd2: expected.num_bytes = 2'b11;
                    default: begin
                        `uvm_error("CONTROL_ERROR",
                            "Store encoding not specified")
                        return;
                    end
                endcase
            end

            7'b1100011: begin // Branch
                expected.reg_en = 1'b0;
                expected.regmux = tr.regmux;
                expected.alumux1 = 1'b1;
                expected.alumux2 = 1'b0;
                expected.jump = 1'b0;
                expected.br_en = 1'b1;
                expected.jalr = tr.jalr;
                expected.we = 1'b0;
                expected.sz = tr.sz;
                expected.num_bytes = tr.num_bytes;
                expected.mul_sel = tr.mul_sel;

                case (funct3)
                    3'd0: expected.alu_sel = 4'b1010; // BEQ
                    3'd1: expected.alu_sel = 4'b1011; // BNE
                    3'd4: expected.alu_sel = 4'b1100; // BLT
                    3'd5: expected.alu_sel = 4'b1101; // BGE
                    3'd6: expected.alu_sel = 4'b1110; // BLTU
                    3'd7: expected.alu_sel = 4'b1111; // BGEU
                    default: begin
                        `uvm_error("CONTROL_ERROR",
                            "Branch encoding not specified")
                        return;
                    end
                endcase
            end

            7'b1101111: begin // JAL
                expected.reg_en = 1'b1;
                expected.regmux = 3'b000;
                expected.alumux1 = 1'b0;
                expected.alumux2 = 1'b1;
                expected.alu_sel = 4'b0000;
                expected.jump = 1'b1;
                expected.br_en = 1'b0;
                expected.jalr = 1'b0;
                expected.we = 1'b0;
                expected.sz = tr.sz;
                expected.num_bytes = tr.num_bytes;
                expected.mul_sel = tr.mul_sel;
            end

            7'b1100111: begin // JALR
                expected.reg_en = 1'b1;
                expected.regmux = 3'b000;
                expected.alumux1 = 1'b1;
                expected.alumux2 = 1'b1;
                expected.alu_sel = 4'b0000;
                expected.jump = 1'b1;
                expected.br_en = 1'b0;
                expected.jalr = 1'b1;
                expected.we = 1'b0;
                expected.sz = tr.sz;
                expected.num_bytes = tr.num_bytes;
                expected.mul_sel = tr.mul_sel;
            end

            7'b0110111: begin // LUI
                expected.reg_en = 1'b1;
                expected.regmux = 3'b011;
                expected.alumux1 = tr.alumux1;
                expected.alumux2 = tr.alumux2;
                expected.alu_sel = tr.alu_sel;
                expected.jump = 1'b0;
                expected.br_en = 1'b0;
                expected.jalr = tr.jalr;
                expected.we = 1'b0;
                expected.sz = tr.sz;
                expected.num_bytes = tr.num_bytes;
                expected.mul_sel = tr.mul_sel;
            end

            7'b0010111: begin // AUIPC
                expected.reg_en = 1'b1;
                expected.regmux = 3'b001;
                expected.alumux1 = 1'b0;
                expected.alumux2 = 1'b1;
                expected.alu_sel = 4'b0000;
                expected.jump = 1'b0;
                expected.br_en = 1'b0;
                expected.jalr = tr.jalr;
                expected.we = 1'b0;
                expected.sz = tr.sz;
                expected.num_bytes = tr.num_bytes;
                expected.mul_sel = tr.mul_sel;
            end

            default: begin
                `uvm_error("CONTROL_ERROR",
                    $sformatf("Opcode %07b not specified in truth table",
                              opcode))
                return;
            end
        endcase

        // Count only completed comparisons.
        check_count++;

        if (!expected.compare(tr)) begin
            mismatch_count++;
            `uvm_error("CONTROL_MISMATCH",
                $sformatf(
                    "instr=%08h opcode=%07b funct3=%03b funct7=%07b",
                    tr.instr, opcode, funct3, funct7))
        end
    endfunction : write

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("CONTROL_UNIT_SUMMARY",
            $sformatf("Checks: %0d, mismatches: %0d",
                      check_count, mismatch_count),
            UVM_LOW)

        if (check_count == 0)
            `uvm_error("CONTROL_NO_CHECKS",
                       "No control-unit results were checked")
    endfunction : report_phase

endclass : control_unit_scoreboard