module counter_clock_div #(
    parameter int unsigned PERIOD = 1_000_000
) (
    input  logic clk,
    input  logic reset,
    output logic tick
);

    localparam int unsigned WIDTH =
        (PERIOD > 1) ? $clog2(PERIOD) : 1;

    logic [WIDTH-1:0] count;

    assign tick = !reset && (count == PERIOD - 1);

    always_ff @(posedge clk) begin
        if (reset)
            count <= '0;
        else if (tick)
            count <= '0;
        else
            count <= count + 1'b1;
    end

endmodule