`timescale 1ns / 1ps

module vga_wrapper(
	input logic clk_25MHz,
    input logic clk_125MHz,
    input logic clock_locked,
	input logic reset,
	output logic hdmi_clk_n,
	output logic hdmi_clk_p,
	output logic [2:0] hdmi_tx_n,
	output logic [2:0] hdmi_tx_p
);

	logic hsync, vsync, video_active;
	logic [7:0] red, green, blue;
	logic [9:0] x_pix, y_pix;

    // assign red = video_active ? x_pix[7:0] : 8'h00;
    // assign blue = video_active ? (y_pix[7:0] - x_pix[7:0]) : 8'h00;
    // assign green = video_active ? (y_pix[7:0] + x_pix[7:0]) : 8'h00;

	assign red = video_active ? 8'hFF : 8'h00;
    assign blue = video_active ? 8'hFF : 8'h00;
    assign green = video_active ? 8'hFF : 8'h00;

	vga_sync vga (
		.clk(clk_25MHz),
		.reset(reset),
		.hsync(hsync),
		.vsync(vsync),
		.video_active(video_active),
		.px(x_pix),
		.py(y_pix)
	);

	hdmi_tx_0 vga_to_hdmi (
		.pix_clk(clk_25MHz),
		.pix_clkx5(clk_125MHz),
		.pix_clk_locked(clock_locked),
		.rst(reset),
		.red(red),
		.green(green),
		.blue(blue),
		.hsync(hsync),
		.vsync(vsync),
		.vde(video_active),
		// .aux0_din(4'b0),
		// .aux1_din(4'b0),
		// .aux2_din(4'b0),
		// .ade(1'b0),
		.TMDS_CLK_P(hdmi_clk_p),          
		.TMDS_CLK_N(hdmi_clk_n),          
		.TMDS_DATA_P(hdmi_tx_p),         
		.TMDS_DATA_N(hdmi_tx_n)          
	);

endmodule : vga_wrapper