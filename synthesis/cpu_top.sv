module cpu_top (
    input  logic       clk,
    input  logic       reset_btn,
    output logic [7:0] led
);

    logic cpu_clk;
    logic clock_locked;
    logic reset_request;

    cpu_clock clock_generator (
        .clk_out1 (cpu_clk),
        .reset    (1'b0),
        .locked   (clock_locked),
        .clk_in1  (clk)
    );

    // Assert reset immediately if the button is pressed or
    // the clock generator is unlocked. Release it synchronously
    // after two rising edges of the CPU clock.
    (* ASYNC_REG = "TRUE" *)
    logic [1:0] reset_pipe = 2'b11;

    assign reset_request = reset_btn || !clock_locked;

    always_ff @(posedge cpu_clk or posedge reset_request) begin
        if (reset_request)
            reset_pipe <= 2'b11;
        else
            reset_pipe <= {reset_pipe[0], 1'b0};
    end

    cpu test_cpu (
        .clk       (cpu_clk),
        .reset     (reset_pipe[1]),
        .debug_led (led)
    );

endmodule : cpu_top