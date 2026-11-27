module horizontal_counter (
    input  logic        clk,
    input  logic        reset,
    output logic        enable_v_counter,
    output logic [15:0] h_count_value = 16'd0
);

    assign enable_v_counter = !reset && (h_count_value == 16'd799);

    always_ff @(posedge clk) begin
        if (reset)
            h_count_value <= 16'd0;
        else if (enable_v_counter)
            h_count_value <= 16'd0;
        else
            h_count_value <= h_count_value + 16'd1;
    end

endmodule : horizontal_counter