module cpu (input bit clk, input bit reset, output logic [7:0] debug_led);

    // ========================================
    //  docs/single-cycle-cpu-datapath.pdf
    // ========================================

    // ========================================
    //  INSTANTIATING INTERFACES
    // ========================================

    pc_if program_counter_if (.clk(clk));

    sram_if instruction_memory_if (.clk(clk));

    sram_if data_memory_if (.clk(clk));

    control_unit_if control_unit_if (.clk(clk));

    immediate_generator_if immediate_generator_if (.clk(clk));

    alu_if alu_if (.clk(clk));

    register_file_if register_file_if (.clk(clk));

    mul_if mul_if (.clk(clk));

    mux_if #(
        .DATA_WIDTH(32),
        .INPUT_WIDTH(5)
    ) regmux_if (.clk(clk));

    mux_if #(
        .DATA_WIDTH(32),
        .INPUT_WIDTH(2)
    ) alumux1_if (.clk(clk));

    mux_if #(
        .DATA_WIDTH(32),
        .INPUT_WIDTH(2)
    ) alumux2_if (.clk(clk));

    mux_if #(
        .DATA_WIDTH(32),
        .INPUT_WIDTH(2)
    ) jumpmux_if (.clk(clk));

    mux_if #(
        .DATA_WIDTH(32),
        .INPUT_WIDTH(2)
    ) jalrmux_if (.clk(clk));

    mux_if #(
        .DATA_WIDTH(32),
        .INPUT_WIDTH(2)
    ) brmux_if (.clk(clk));

    adder_if pc_adder_if (.clk(clk));

    adder_if pc_plus4_if (.clk(clk));

    // ========================================
    //  INSTANTIATING MODULES
    // ========================================

    pc program_counter (program_counter_if.DUT);
    
    sram #(
        .INIT_FILE0("C:/Users/jance/Documents/Github/RiscV-SoC/tb/programs/cpu_led_counter_bank0.hex"),
        .INIT_FILE1("C:/Users/jance/Documents/Github/RiscV-SoC/tb/programs/cpu_led_counter_bank1.hex"),
        .INIT_FILE2("C:/Users/jance/Documents/Github/RiscV-SoC/tb/programs/cpu_led_counter_bank2.hex"),
        .INIT_FILE3("C:/Users/jance/Documents/Github/RiscV-SoC/tb/programs/cpu_led_counter_bank3.hex")
    ) instruction_memory (
        instruction_memory_if.DUT
    );

    sram data_memory (data_memory_if.DUT);

    control_unit control_unit (control_unit_if.DUT);

    immediate_generator immediate_generator (immediate_generator_if.DUT);

    alu alu (alu_if.DUT);

    register_file register_file (register_file_if.DUT);

    mul mul (mul_if.DUT);

    mux regmux (regmux_if.DUT);

    mux alumux1 (alumux1_if.DUT);

    mux alumux2 (alumux2_if.DUT);

    mux jumpmux (jumpmux_if.DUT);

    mux jalrmux (jalrmux_if.DUT);

    mux brmux (brmux_if.DUT);

    adder pc_adder (pc_adder_if.DUT);

    adder pc_plus4 (pc_plus4_if.DUT);

    // ========================================
    //  WIRING CONNECTIONS
    // ========================================

    assign debug_led = register_file_if.debug_x1[25:18];

    // Program Counter
    assign program_counter_if.reset = reset;
    assign program_counter_if.write_data = jumpmux_if.data_out;

    // Instruction Memory
    assign instruction_memory_if.write_enable = 1'b0; // temporary
    assign instruction_memory_if.sz = 1'b0;
    assign instruction_memory_if.num_bytes = 2'b11;
    assign instruction_memory_if.addr = program_counter_if.read_data;
    assign instruction_memory_if.write_data = 32'd0; // temporary

    // Control Unit
    assign control_unit_if.instr = instruction_memory_if.read_data;

    // Data Memory
    assign data_memory_if.write_enable = !reset && control_unit_if.we;
    assign data_memory_if.sz = control_unit_if.sz;
    assign data_memory_if.num_bytes = control_unit_if.num_bytes;
    assign data_memory_if.addr = alu_if.s;
    assign data_memory_if.write_data = register_file_if.rs2;

    // Immediate Generator
    assign immediate_generator_if.instruction = instruction_memory_if.read_data;

    // Arithmetic Logic Unit
    assign alu_if.a = alumux1_if.data_out;
    assign alu_if.b = alumux2_if.data_out;
    assign alu_if.sel = control_unit_if.alu_sel;

    // Register File
    assign register_file_if.write_enable = !reset && control_unit_if.reg_en;
    assign register_file_if.rs1_addr = instruction_memory_if.read_data[19:15];
    assign register_file_if.rs2_addr = instruction_memory_if.read_data[24:20];
    assign register_file_if.write_addr = instruction_memory_if.read_data[11:7];
    assign register_file_if.write_data = regmux_if.data_out;

    // Multiply Unit
    assign mul_if.sel = control_unit_if.mul_sel;
    assign mul_if.rs1 = register_file_if.rs1;
    assign mul_if.rs2 = register_file_if.rs2;

    // Register File Mux
    assign regmux_if.data_in = {mul_if.data_out, immediate_generator_if.immediate, data_memory_if.read_data, alu_if.s, pc_plus4_if.s};
    assign regmux_if.sel = control_unit_if.regmux;

    // ALU Mux 1
    assign alumux1_if.data_in = {register_file_if.rs1, program_counter_if.read_data};
    assign alumux1_if.sel = control_unit_if.alumux1;

    // ALU Mux 2
    assign alumux2_if.data_in = {immediate_generator_if.immediate, register_file_if.rs2};
    assign alumux2_if.sel = control_unit_if.alumux2;

    // Jump Mux
    assign jumpmux_if.data_in = {jalrmux_if.data_out, pc_adder_if.s};
    assign jumpmux_if.sel = control_unit_if.jump;

    // Jalr Mux
    assign jalrmux_if.data_in = {{alu_if.s[31:1], 1'b0}, alu_if.s};
    assign jalrmux_if.sel = control_unit_if.jalr;

    // Branch Mux
    assign brmux_if.data_in = {immediate_generator_if.immediate, 32'd4};
    assign brmux_if.sel = (control_unit_if.br_en & alu_if.s[0]);

    // Program Counter Address Adder
    assign pc_adder_if.a = brmux_if.data_out;
    assign pc_adder_if.b = program_counter_if.read_data;

    // Program Counter Address Adder
    assign pc_plus4_if.a = 32'd4;
    assign pc_plus4_if.b = program_counter_if.read_data;

endmodule : cpu