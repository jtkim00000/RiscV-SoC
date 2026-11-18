interface mux_if #(
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned INPUT_WIDTH = 2,
    parameter int unsigned SELECT_BITS =
        (INPUT_WIDTH > 1) ? $clog2(INPUT_WIDTH) : 1
    ) (
    input logic clk
);

    logic [DATA_WIDTH*INPUT_WIDTH-1:0] data_in;
    logic [SELECT_BITS-1:0] sel;
    logic [DATA_WIDTH-1:0] data_out;

    clocking mux_cb @(negedge clk);
        default output #0;
        output data_in, sel;
    endclocking : mux_cb

    clocking mux_cbm @(posedge clk);
        default input #1step;
        input data_in, sel, data_out;
    endclocking : mux_cbm

    modport TEST (clocking mux_cb);

    modport DUT (
    input sel, data_in,
    output data_out
    );

    modport MONITOR (clocking mux_cbm);

endinterface : mux_if