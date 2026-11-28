interface if_id_if (input bit clk);

    logic FLUSH_E;
    logic [31:0] Instr_F, Instr_D;
    logic [31:0] PC_F, PC_D;
    logic [31:0] PC_Plus_4_F, PC_Plus_4_D;

    clocking ex_mem_cb @(posedge clk);
        default input #1step output #0;
        input Instr_D, PC_D, PC_Plus_4_D;
        output FLUSH_E, Instr_F, PC_F, PC_Plus_4_F;
    endclocking : ex_mem_cb

    clocking ex_mem_cbm @(posedge clk);
        default input #1step;
        input FLUSH_E, Instr_F, PC_F, PC_Plus_4_F, Instr_D, PC_D, PC_Plus_4_D
    endclocking : ex_mem_cbm

    modport DUT (
        input clk, FLUSH_E, Instr_F, PC_F, PC_Plus_4_F,
        output Instr_D, PC_D, PC_Plus_4_D
    );

    modport TEST (clocking ex_mem_cb);

    modport MONIOR (clocking ex_mem_cbm);

endinterface : if_id_if