module vga_sync (
    input logic clk,
    input logic reset,
	output logic hsync,
	output logic vsync,
	output logic video_active,
	output logic [9:0] px,
	output logic [9:0] py
);
    logic [15:0] h_count_value;
    logic [15:0] v_count_value;
    logic enable_v_counter;

    horizontal_counter vga_horizontal (
        .clk(clk),
        .reset(reset),
        .enable_v_counter(enable_v_counter),
        .h_count_value(h_count_value)
    );

    vertical_counter vga_vertical (
        .clk(clk),
        .reset(reset),
        .enable_v_counter(enable_v_counter),
        .v_count_value(v_count_value)
    );

    assign hsync = !((h_count_value >= 656) && (h_count_value < 752));
    assign vsync = !((v_count_value >= 490) && (v_count_value < 492));

    assign video_active = (h_count_value < 16'd640 && !reset) && (v_count_value < 16'd480);
    assign px = (video_active && !reset) ? h_count_value[9:0] : 10'd0;
    assign py = (video_active && !reset) ? v_count_value[9:0] : 10'd0;

endmodule : vga_sync