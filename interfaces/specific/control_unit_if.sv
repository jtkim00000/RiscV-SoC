interface control_unit_if (input bit clk);
    logic [31:0] instr;
    logic reg_en;
    logic [2:0] regmux;
    logic alumux1;
    logic alumux2;
    logic [3:0] alu_sel;
    logic [2:0] mul_sel;
    logic jump;
    logic br_en;
    logic jalr;
    logic we;
    logic sz;
    logic [1:0] num_bytes;

    clocking control_unit_cb @(negedge clk);
        default output #0;
        output instr;
    endclocking : control_unit_cb

    clocking control_unit_cbm @(posedge clk);
        default input #1step;
        input instr, reg_en, regmux, alumux1, alumux2, alu_sel, mul_sel, jump, br_en, jalr, we, sz, num_bytes;
    endclocking : control_unit_cbm

    modport TEST (clocking control_unit_cb);
    
    modport MONITOR (clocking control_unit_cbm);

    modport DUT (
        input instr,
        output reg_en, regmux, alumux1, alumux2, alu_sel, mul_sel, jump, br_en, jalr, we, sz, num_bytes
    );

endinterface : control_unit_if