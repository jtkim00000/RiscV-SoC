class fifor_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifor_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    uvm_analysis_imp #(fifor_item, fifor_scoreboard) ap_imp;

    logic [7:0] expected_data;
    logic expected_empty;
    logic expected_full;

    logic [7:0] queue [0:7];
    int unsigned queue_count = 0;
    int unsigned start_ptr = 0;
    int unsigned end_ptr = 0;

    int unsigned check_count = 0;
    int unsigned mismatch_count = 0;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_imp = new("ap_imp", this);
    endfunction : build_phase

    virtual function void write(fifor_item tr);

        ++check_count;

        if (tr.read_data !== expected_data) begin
            ++mismatch_count;
            `uvm_error("FIFOR_MISMATCH", $sformatf("Expected read_data=%02h, got %02h", expected_data, tr.read_data))
        end

        if (tr.empty !== expected_empty) begin
            ++mismatch_count;
            `uvm_error("FIFOR_MISMATCH", $sformatf("Expected empty=%01h, got %01h", expected_empty, tr.empty))
        end

        if (tr.full !== expected_full) begin
            ++mismatch_count;
            `uvm_error("FIFOR_MISMATCH", $sformatf("Expected full=%01h, got %01h", expected_full, tr.full))
        end

        if(tr.reset) begin
            queue_count = 0;
            start_ptr = 0;
            end_ptr = 0;
            expected_empty = 1'b1;
            expected_full = 1'b0;
            expected_data = 8'd0;
            for(int i = 0; i < 8; ++i)                queue[i] = 8'd0;

        end
        else begin
            if(tr.read && queue_count != 0) begin
                expected_data = queue[end_ptr];
                if(end_ptr == 7)
                    end_ptr = 0;
                else
                    ++end_ptr;
                --queue_count;
            end
            
            if(tr.write && queue_count != 8) begin
                queue[start_ptr] = tr.write_data;
                if(start_ptr == 7)
                    start_ptr = 0;
                else
                    ++start_ptr;
                ++queue_count;
            end

            if(queue_count == 8)
                expected_full = 1'b1;
            else
                expected_full = 1'b0;

            if(queue_count == 0)
                expected_empty = 1'b1;
            else
                expected_empty = 1'b0;
        end

    endfunction : write

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "FIFOR_SUMMARY", 
            $sformatf("Checks: %0d, mismatches: %0d",check_count, mismatch_count),
            UVM_LOW
            )

        if (check_count == 0)
            `uvm_error("FIFOR_NO_CHECKS", "No FIFOR results were checked")
    endfunction : report_phase

endclass : fifor_scoreboard