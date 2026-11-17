class reg_file_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(reg_file_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    uvm_analysis_imp #(reg_file_item, reg_file_scoreboard) ap_imp;

    logic [31:0] expected_data_rs1;
    logic [31:0] expected_data_rs2;
    bit          expected_valid = 0;
    int unsigned check_count = 0;
    int unsigned mismatch_count = 0;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction : build_phase

    function automatic logic [31:0] model_register_file (
        logic write_enable,
        logic [31:0] write_addr,
        logic [31:0] write_data,
        logic [31:0] rs1_addr,
        logic [31:0] rs2_addr
    );
        static logic [31:0] registers [0:31];

        if(write_enable && (write_addr != 0)) begin
            registers[write_addr] <= write_data;
        end

        if(rs1_addr != 32'd0) begin
            return registers[rs1_addr];
        end
        else if (rs2_addr != 32'd0) begin
            return registers[rs2_addr];
        end

        return 32'd0;

    endfunction : model_register_file

    virtual function void write(reg_file_item tr);
        //two separate reads
        expected_data_rs1 = model_register_file(1'b0, 32'd0, 32'd0, tr.rs1_addr, 32'd0);
        expected_data_rs2 = model_register_file(1'b0, 32'd0, 32'd0, 32'd0, tr.rs2_addr);

        if (tr.write_enable && tr.write_addr != 0) begin    // register-fiel write through
            if (tr.rs1_addr == tr.write_addr)
                expected_data_rs1 = tr.write_data;

            if (tr.rs2_addr == tr.write_addr)
                expected_data_rs2 = tr.write_data;
        end

        if (expected_valid) begin
            ++check_count;

            if (tr.rs1 !== expected_data_rs1) begin
                ++mismatch_count;
                `uvm_error("REG_FILE_MISMATCH", $sformatf("Expected rs1=%08h, got %08h", expected_data_rs1, tr.rs1))
            end

            if (tr.rs2 !== expected_data_rs2) begin
                ++mismatch_count;
                `uvm_error("REG_FILE_MISMATCH", $sformatf("Expected rs2=%08h, got %08h", expected_data_rs2, tr.rs1))
            end
        end

        // write
        model_register_file(tr.write_enable, tr.write_addr, tr.write_data, 32'd0, 32'd0);

        expected_valid = 1;
    endfunction : write

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "REG_FILE_SUMMARY", 
            $sformatf("Checks: %0d, mismatches: %0d", check_count, mismatch_count),
            UVM_LOW
            )

        if (check_count == 0)
            `uvm_error("REG_FILE_NO_CHECKS", "No reg_file results were checked")
    endfunction : report_phase

endclass : reg_file_scoreboard