class uartt_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uartt_scoreboard)

    uvm_analysis_imp #(uartt_item, uartt_scoreboard) ap_imp;

    int unsigned clks_per_bit = 868;

    logic       expected_tx;
    logic       expected_busy;
    logic [7:0] current_data;

    bit model_valid = 0;
    bit frame_active = 0;

    int unsigned elapsed_clocks = 0;
    int unsigned check_count = 0;
    int unsigned mismatch_count = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap_imp = new("ap_imp", this);

        // Optional configuration; otherwise use 868.
        void'(uvm_config_db#(int unsigned)::get(
            this, "", "clks_per_bit", clks_per_bit
        ));

        if (clks_per_bit == 0)
            `uvm_fatal("UARTT_CONFIG",
                       "clks_per_bit must be greater than zero")
    endfunction : build_phase

    virtual function void write(uartt_item tr);
        int unsigned data_bit_index;

        // Check the prediction made at the previous sampled edge.
        if (model_valid) begin
            check_count++;

            if (tr.tx !== expected_tx) begin
                mismatch_count++;
                `uvm_error("UARTT_TX_MISMATCH",
                    $sformatf(
                        "elapsed=%0d expected tx=%b actual tx=%b",
                        elapsed_clocks, expected_tx, tr.tx))
            end

            if (tr.busy !== expected_busy) begin
                mismatch_count++;
                `uvm_error("UARTT_BUSY_MISMATCH",
                    $sformatf(
                        "elapsed=%0d expected busy=%b actual busy=%b",
                        elapsed_clocks, expected_busy, tr.busy))
            end
        end

        // Predict the outputs after this edge.
        if (tr.reset) begin
            expected_tx   = 1'b1;
            expected_busy = 1'b0;
            current_data  = 8'd0;
            elapsed_clocks = 0;
            frame_active = 0;
            model_valid = 1;
        end
        else if (model_valid) begin
            if (!frame_active) begin
                // DUT executes its IDLE behavior.
                expected_tx   = 1'b1;
                expected_busy = 1'b0;
                elapsed_clocks = 0;

                if (tr.start) begin
                    current_data  = tr.data;
                    expected_busy = 1'b1;
                    frame_active  = 1;

                    // tx stays high on the acceptance edge.
                end
            end
            else begin
                elapsed_clocks++;

                expected_busy = 1'b1;

                if (elapsed_clocks <= clks_per_bit) begin
                    // Start bit: clocks 1 through N.
                    expected_tx = 1'b0;
                end
                else if (elapsed_clocks <= 9 * clks_per_bit) begin
                    // Eight data bits, each held for N clocks.
                    data_bit_index =
                        ((elapsed_clocks - 1) / clks_per_bit) - 1;

                    expected_tx = current_data[data_bit_index];
                end
                else begin
                    // Stop bit: clocks 9N+1 through 10N.
                    expected_tx = 1'b1;
                end

                if (elapsed_clocks == 10 * clks_per_bit) begin
                    // Stop period ends at the next edge.
                    // busy remains high for this final stop interval.
                    // The next update executes IDLE behavior.
                    frame_active = 0;
                end
            end
        end
    endfunction : write

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("UARTT_SUMMARY",
            $sformatf("Checks: %0d, mismatches: %0d",
                      check_count, mismatch_count),
            UVM_LOW)

        if (check_count == 0)
            `uvm_error("UARTT_NO_CHECKS",
                       "No UART transmitter results were checked")
    endfunction : report_phase

endclass : uartt_scoreboard 