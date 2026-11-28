module top (
    input clk,
    input reset_btn,
    // Seven Segment Display Clock Counter
    output [7:0] cathode0,
    output [7:0] cathode1,
    output [3:0] anode0,
    output [3:0] anode1,
    // HDMI/VGA Output Display
    output hdmi_clk_n,
	output hdmi_clk_p,
	output [2:0] hdmi_tx_n,
	output [2:0] hdmi_tx_p
);

    // ========================================
    //  CPU Clock & Reset
    // ========================================

    logic cpu_clk;
    logic clock_locked;
    logic clk_25MHz;
    logic clk_125MHz;
    logic reset_request;

    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
		.clk_out2(clk_125MHz),
        .cpu_clk(cpu_clk),
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

    // ========================================
    //  Seven Segment Display Clock Counter
    // ========================================

    logic [3:0] digit0, digit1, digit2, digit3;
    logic [3:0] digit4, digit5, digit6, digit7;

    logic [15:0] active_digit_d1;
    logic [15:0] active_digit_d0;
    logic [1:0] current_digit_sel1;
    logic [1:0] current_digit_sel0;

    assign active_digit_d1 = {digit0, digit1, digit2, digit3};
    assign active_digit_d0 = {digit4, digit5, digit6, digit7};

    logic tick;

    counter_clock_div counter_clock_div (
        .clk(cpu_clk),
        .reset(reset_pipe[1]),
        .tick(tick)
    );  

    clock_counter counter_inst (
        .clk(cpu_clk),
        .reset(reset_pipe[1]),
        .enable(tick),
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
        .clk(cpu_clk),
        .reset(reset_pipe[1]),
        .anode(anode1),
        .current_digit_sel(current_digit_sel1)
    );

    bcd_anode refresh_anode0 (
        .clk(cpu_clk),
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

    // ========================================
    //  VGA Output
    // ========================================

    (* ASYNC_REG = "TRUE" *)
    logic [1:0] video_reset_pipe = 2'b11;

    always_ff @(posedge clk_25MHz or posedge reset_request) begin
        if (reset_request)
            video_reset_pipe <= 2'b11;
        else
            video_reset_pipe <= {video_reset_pipe[0], 1'b0};
    end

    vga_wrapper vga (
        .clk_25MHz(clk_25MHz),  
        .clk_125MHz(clk_125MHz),
        .clock_locked(clock_locked),
        .reset(video_reset_pipe[1]),
        .hdmi_clk_n(hdmi_clk_n),
        .hdmi_clk_p(hdmi_clk_p),
        .hdmi_tx_n(hdmi_tx_n),
        .hdmi_tx_p(hdmi_tx_p)
    );

endmodule : top