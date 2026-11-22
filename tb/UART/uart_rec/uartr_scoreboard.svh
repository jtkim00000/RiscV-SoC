class uartr_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uartr_scoreboard)

    uvm_analysis_imp #(uartr_item, uartr_scoreboard) ap_imp;

    int unsigned clks_per_bit = 868;

    logic [7:0] current_data;

    logic [7:0] expected_data;

    bit expected_error = 0;
    logic [7:0] last_good_data;

    int unsigned check_count = 0;
    int unsigned mismatch_count = 0;

    typedef enum {
        REF_IDLE,
        REF_START,
        REF_DATA,
        REF_STOP
    } reference_state_t;

    reference_state_t reference_state = REF_IDLE;

    int unsigned sample_count = 0;
    int unsigned bit_index = 0;
    bit expected_pending = 0;
    int unsigned decoded_count = 0;

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

        if (clks_per_bit < 2)
            `uvm_fatal("UARTR_CONFIG",
                       "clks_per_bit must be at least 2")
    endfunction : build_phase

    virtual function void write(uartr_item tr);

        if (tr.reset) begin
            reference_state = REF_IDLE;
            sample_count = 0;
            bit_index = 0;
            current_data = 8'd0;
            expected_pending = 1'b0;
            return;
        end
        else begin
            if (tr.valid == 1'b1 || tr.framing_error == 1'b1) begin
                if (!expected_pending) begin
                    mismatch_count++;
                    `uvm_error("UARTR_UNEXPECTED_RESPONSE",
                            "Received an event without a pending frame")
                end
                else begin
                    check_count++;

                    if (expected_error) begin
                        if (tr.valid !== 1'b0 ||
                            tr.framing_error !== 1'b1) begin
                            mismatch_count++;
                            `uvm_error("UARTR_BAD_STOP",
                                    "Bad stop must produce only framing_error")
                        end

                        if (tr.data !== last_good_data) begin
                            mismatch_count++;
                            `uvm_error("UARTR_DATA_HOLD",
                                    "Data changed after a bad frame")
                        end
                    end
                    else begin
                        if (tr.valid !== 1'b1 ||
                            tr.framing_error !== 1'b0 ||
                            tr.data !== expected_data) begin
                            mismatch_count++;
                            `uvm_error("UARTR_GOOD_FRAME",
                                    "Good frame produced an incorrect response")
                        end

                        // Update from the reference, not the DUT's observed data.
                        last_good_data = expected_data;
                    end

                    expected_pending = 0;
                end
            end
            case(reference_state)
                REF_IDLE: begin
                    if (tr.rx == 1'b0) begin
                        sample_count = 0;
                        bit_index = 0;
                        current_data = 8'd0;
                        reference_state = REF_START;
                    end
                end
                REF_START: begin
                    if (sample_count == (clks_per_bit / 2) - 1) begin
                        sample_count = 0;

                        if (tr.rx == 1'b0)
                            reference_state = REF_DATA;
                        else
                            reference_state = REF_IDLE;
                    end
                    else begin
                        sample_count++;
                    end
                end
                REF_DATA: begin
                    if (sample_count == clks_per_bit - 1) begin
                        sample_count = 0;
                        current_data[bit_index] = tr.rx;

                        if (bit_index == 7)
                            reference_state = REF_STOP;
                        else
                            bit_index++;
                    end
                    else begin
                        sample_count++;
                    end
                end
                REF_STOP: begin
                    if (sample_count == clks_per_bit - 1) begin
                        sample_count = 0;
                            
                        // `uvm_info("UARTR_DECODE",
                        //     $sformatf("Reference decoded data=%02h stop_ok=%b",
                        //             current_data, tr.rx),
                        //     UVM_LOW)

                        if (expected_pending)
                            `uvm_error("UARTR_MISSING_RESPONSE",
                                    "Previous frame still awaits a response")
                                    
                        expected_error = (tr.rx == 1'b0);

                        expected_data = current_data;
                        expected_pending = 1;
                        decoded_count++;


                        reference_state = REF_IDLE;
                    end
                    else begin
                        sample_count++;
                    end
                end
            endcase
        end
    endfunction : write

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("UARTR_SUMMARY",
            $sformatf("Decoded frames: %0d, responses checked: %0d, mismatches: %0d",
                    decoded_count, check_count, mismatch_count),
            UVM_LOW)

        if (expected_pending)
            `uvm_error("UARTR_MISSING_RESPONSE",
                    "Test ended with a decoded frame still awaiting a response")

        if (check_count == 0)
            `uvm_error("UARTR_NO_CHECKS",
                       "No UART receiver results were checked")
    endfunction : report_phase

endclass : uartr_scoreboard 