module cpu_counter_tb;
    timeunit 1ns;
    timeprecision 1ps;

    logic clk = 1'b0;
    logic reset = 1'b1;
    logic [7:0] debug_led;

    cpu dut (
        .clk       (clk),
        .reset     (reset),
        .debug_led (debug_led)
    );

    // Same 100 MHz clock as the board.
    always #5ns clk = ~clk;

    initial begin
        // Hold synchronous reset through several rising edges.
        repeat (3) @(negedge clk);
        reset = 1'b0;

        // Observe the instruction about to execute at each rising edge.
        repeat (12) begin
            @(posedge clk);

            $display(
                "PC=%08h INSTR=%08h x1_before=%08h",
                dut.program_counter_if.read_data,
                dut.instruction_memory_if.read_data,
                dut.register_file.register_file[1]
            );
        end

        @(negedge clk);
        $finish;
    end

endmodule : cpu_counter_tb