interface mux_if #(
    parameter DATA_WIDTH = 32,
    PARAMETER INPUT_WIDTH = 2,
    PARAMETER SELECT_BITS = (INPUT_WIDTH > 1) ? $clog2(INPUT_WIDTH) : 1
    );

    logic [DATA_WIDTH*INPUT_WIDTH-1:0] data_in;
    logic [SELECT_BITS-1:0] sel;
    logic [DATA_WIDTH-1:0] data_out;

    clocking mux_cb @(negedge clk);
        default output #0;
        output data_out;
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