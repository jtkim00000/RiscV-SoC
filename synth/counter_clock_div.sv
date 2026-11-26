module counter_clock_div (
    input logic clk,
    output logic clock_div = 0
);

    int unsigned counter;

    always @(posedge clk) begin
        if(counter == 500000) begin
            counter <= 0;
            clock_div <= ~clock_div;
        end
        else
            counter <= counter + 1;
    end

endmodule : counter_clock_div