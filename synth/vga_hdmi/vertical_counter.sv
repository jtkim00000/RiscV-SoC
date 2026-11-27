module vertical_counter (
    input  logic clk,
    input  logic reset,
    input  logic enable_v_counter,
    output logic [15:0] v_count_value = 16'd0
);

    always_ff @(posedge clk) begin
        if (reset)
            v_count_value <= 16'd0;
        else if (enable_v_counter) begin
            if (v_count_value == 16'd524)
                v_count_value <= 16'd0;
            else
                v_count_value <= v_count_value + 16'd1;
        end
    end

endmodule : vertical_counter