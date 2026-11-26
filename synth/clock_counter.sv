module clock_counter (
    input logic clk,
    input logic reset,
    output logic [3:0] digit0,
    output logic [3:0] digit1,
    output logic [3:0] digit2,
    output logic [3:0] digit3,
    output logic [3:0] digit4,
    output logic [3:0] digit5,
    output logic [3:0] digit6,
    output logic [3:0] digit7
);
    logic [3:0] digit_0 = 4'd0;
    logic [3:0] digit_1 = 4'd0;
    logic [3:0] digit_2 = 4'd0;
    logic [3:0] digit_3 = 4'd0;
    logic [3:0] digit_4 = 4'd0;
    logic [3:0] digit_5 = 4'd0;
    logic [3:0] digit_6 = 4'd0;
    logic [3:0] digit_7 = 4'd0;

    assign digit0 = (reset) ? 4'd0 : digit_0;
    assign digit1 = (reset) ? 4'd0 : digit_1;
    assign digit2 = (reset) ? 4'd0 : digit_2;
    assign digit3 = (reset) ? 4'd0 : digit_3;
    assign digit4 = (reset) ? 4'd0 : digit_4;
    assign digit5 = (reset) ? 4'd0 : digit_5;
    assign digit6 = (reset) ? 4'd0 : digit_6;
    assign digit7 = (reset) ? 4'd0 : digit_7;

    always_ff @(posedge clk) begin
        if(reset) begin
            digit_0 <= 4'd0;
            digit_1 <= 4'd0;
            digit_2 <= 4'd0;
            digit_3 <= 4'd0;
            digit_4 <= 4'd0;
            digit_5 <= 4'd0;
            digit_6 <= 4'd0;
            digit_7 <= 4'd0;
        end
        else begin
            if(digit_0 == 4'd9) begin
                digit_0 <= 4'd0;
                if(digit_1 == 4'd9) begin
                    digit_1 <= 4'd0;
                    if(digit_2 == 4'd9) begin
                        digit_2 <= 4'd0;
                        if(digit_3 == 4'd9) begin
                            digit_3 <= 4'd0;
                            if(digit_4 == 4'd9) begin
                                digit_4 <= 4'd0;
                                if(digit_5 == 4'd9) begin
                                    digit_5 <= 4'd0;
                                    if(digit_6 == 4'd9) begin
                                        digit_6 <= 4'd0;
                                        if(digit_7 == 4'd9) begin
                                            digit_7 <= 4'd0;
                                        end
                                        else
                                            digit_7 <= digit_7 + 1'b1;
                                    end
                                    else
                                        digit_6 <= digit_6 + 1'b1;
                                end
                                else
                                    digit_5 <= digit_5 + 1'b1;
                            end
                            else
                                digit_4 <= digit_4 + 1'b1;
                        end
                        else
                            digit_3 <= digit_3 + 1'b1;
                    end
                    else
                        digit_2 <= digit_2 + 1'b1;
                end
                else
                    digit_1 <= digit_1 + 1'b1;
            end
            else 
                digit_0 <= digit_0 + 1'b1;
        end
    end

endmodule : clock_counter