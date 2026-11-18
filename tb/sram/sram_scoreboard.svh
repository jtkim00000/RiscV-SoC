class sram_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(sram_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    uvm_analysis_imp #(sram_item, sram_scoreboard) ap_imp;

    logic [31:0] expected_data;
    bit          expected_valid = 0;
    int unsigned check_count = 0;
    int unsigned mismatch_count = 0;
    logic [7:0] reference_memory [bit [31:0]];

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction : build_phase

    function void write_byte(
        bit [31:0] addr,
        logic [7:0] data
    );
        reference_memory[addr] = data;
    endfunction


    function automatic logic [7:0] read_byte(
        bit [31:0] addr
    );
        if (reference_memory.exists(addr))
            return reference_memory[addr];

        return 8'hxx;
    endfunction

    virtual function void write(sram_item tr);

        logic [31:0] temp;
        temp = 32'd0;
        for(int i = 0; i < tr.num_bytes+1; ++i) begin
            temp[i*8 +: 8] = read_byte(tr.addr + i);
        end

        if(tr.num_bytes == 2'b00) begin
            if(tr.sz)
                expected_data = {{24{temp[7]}}, temp[7:0]};
            else
                expected_data = {{24'd0}, temp[7:0]};
        end
        else if(tr.num_bytes == 2'b01) begin
            if(tr.sz)
                expected_data = {{16{temp[15]}}, temp[15:0]};
            else
                expected_data = {{16'd0}, temp[15:0]};
        end
        else
            expected_data = temp;

        ++check_count;

        if (tr.read_data !== expected_data) begin
            ++mismatch_count;
            `uvm_error("SRAM_MISMATCH",
                $sformatf(
                    "addr=%08h num_bytes=%0d sz=%b expected=%08h actual=%08h",
                    tr.addr, tr.num_bytes, tr.sz,
                    expected_data, tr.read_data))
        end

        if(tr.write_enable) begin
            for(int i = 0; i < tr.num_bytes+1; ++i) begin
                write_byte(tr.addr + i, tr.write_data[i*8 +: 8]);
            end
        end 

    endfunction : write

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "sram_SUMMARY", 
            $sformatf("Checks: %0d, mismatches: %0d",check_count, mismatch_count),
            UVM_LOW
            )

        if (check_count == 0)
            `uvm_error("sram_NO_CHECKS", "No sram results were checked")
    endfunction : report_phase

endclass : sram_scoreboard