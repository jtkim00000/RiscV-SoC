module top (
    input  logic       clk,
    input  logic       reset_btn,
    output logic [7:0] cathode0,
    output logic [7:0] cathode1,
    output logic [3:0] anode0,
    output logic [3:0] anode1 
);

    cpu_clock instance_name
    (
        .clk_out1(cpu_clk),
        .reset(1'b0),
        .locked(clock_locked),
        .clk_in1(clk)
    );

    (* ASYNC_REG = "TRUE" *)
    logic [1:0] reset_pipe = 2'b11;

    assign reset_request = reset_btn || !clock_locked;

    always_ff @(posedge cpu_clk or posedge reset_request) begin
        if (reset_request)
            reset_pipe <= 2'b11;
        else
            reset_pipe <= {reset_pipe[0], 1'b0};
    end

    logic [3:0] digit0, digit1, digit2, digit3;
    logic [3:0] digit4, digit5, digit6, digit7;

    logic [15:0] active_digit_d1;
    logic [15:0] active_digit_d0;
    logic [1:0] current_digit_sel1;
    logic [1:0] current_digit_sel0;

    logic cpu_clk;
    logic counter_clk;
    logic clock_locked;

    assign active_digit_d1 = {digit0, digit1, digit2, digit3};
    assign active_digit_d0 = {digit4, digit5, digit6, digit7};


    counter_clock_div counter_clock_div (
        .clk(cpu_clk),
        .clock_div(counter_clk)
    );  

    clock_counter counter_inst (
        .clk(counter_clk),
        .reset(reset_pipe[1]),
        .digit0(digit0),
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3),
        .digit4(digit4),
        .digit5(digit5),
        .digit6(digit6),
        .digit7(digit7)
    );

    bcd_anode refresh_anode1 (
        .clk(clk),
        .reset(reset_pipe[1]),
        .anode(anode1),
        .current_digit_sel(current_digit_sel1)
    );

    bcd_anode refresh_anode0 (
        .clk(clk),
        .reset(reset_pipe[1]),
        .anode(anode0),
        .current_digit_sel(current_digit_sel0)
    );

    bcd_cathode decoder_d1 (
        .digit(active_digit_d1[current_digit_sel1 * 4 +: 4]),
        .cathode(cathode1)
    );

    bcd_cathode decoder_d0 (
        .digit(active_digit_d0[current_digit_sel0 * 4 +: 4]),
        .cathode(cathode0)
    );

endmodule : top