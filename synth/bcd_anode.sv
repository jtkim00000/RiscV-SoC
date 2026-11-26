module bcd_anode (
    input logic clk,
    input logic reset,
    output logic [3:0] anode,
    output logic [1:0] current_digit_sel
);
    logic [16:0] refresh_counter = 0;
    always_ff @(posedge clk) begin
        if (reset)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end

    logic [1:0] current_digit_select;
    assign current_digit_select = refresh_counter[16:15];

    always_comb begin
        case (current_digit_select)
            2'b00: anode = 4'b1110;
            2'b01: anode = 4'b1101;
            2'b10: anode = 4'b1011;
            2'b11: anode = 4'b0111;
        endcase
    end

    assign current_digit_sel = current_digit_select;

endmodule : bcd_anode