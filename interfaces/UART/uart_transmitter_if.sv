interface uart_transmitter_if (input bit clk);
    logic reset, start;
    logic [7:0] data;
    logic tx;
    logic busy;

    clocking uart_transmitter_cb @(posedge clk);
        default input #1step output #0;
        input tx, busy;
        output reset, start, data;
    endclocking : uart_transmitter_cb

    clocking uart_transmitter_cbm @(posedge clk);
        default input #1step;
        input reset, start, data, tx, busy;
    endclocking : uart_transmitter_cb

    modport DUT (
        input clk, reset, start, data,
        output tx, busy
    );

    modport TEST (clocking uart_transmitter_cb);

    modport MONITOR (clocking uart_transmitter_cbm);

endinterface : uart_transmitter_if