class mux_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(mux_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    uvm_analysis_imp #(mux_item_t, mux_scoreboard) ap_imp;

    logic [31:0] expected_data;
    bit          expected_valid;
    int unsigned check_count;
    int unsigned mismatch_count;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction : build_phase

    // ========================================
    // Scoreboard Helper Functions
    // ========================================

    function automatic logic [31:0] predict_mux(mux_item_t tr);
        logic [31:0] result;

        for (int i = 0; i < 32; i++) begin
            result[i] = tr.data_in[tr.sel * 32 + i];
        end

        return result;
    endfunction

    virtual function void write(mux_item_t tr);
        ++check_count;
        
        expected_data = predict_mux(tr);

        if(tr.data_out !== expected_data) begin
            ++mismatch_count;
            `uvm_error("mux MISMATCH", $sformatf("Expected s=%08h, got %08h", expected_data, tr.data_out))
        end
    endfunction : write

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "mux_SUMMARY", 
            $sformatf("Checks: %0d, mismatches: %0d",check_count, mismatch_count),
            UVM_LOW
            )

        if (check_count == 0)
            `uvm_error("mux_NO_CHECKS", "No mux results were checked")
    endfunction : report_phase

endclass : mux_scoreboard