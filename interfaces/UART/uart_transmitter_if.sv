interface uart_transmitter_if (input bit clk);
    logic reset, start;
    logic [7:0] data;
    logic tx;
    logic busy;

    clocking uartt_cb @(posedge clk);
        default input #1step output #0;
        input tx, busy;
        output reset, start, data;
    endclocking : uartt_cb

    clocking uartt_cbm @(posedge clk);
        default input #1step;
        input reset, start, data, tx, busy;
    endclocking : uartt_cbm

    modport DUT (
        input clk, reset, start, data,
        output tx, busy
    );

    modport TEST (clocking uartt_cb);

    modport MONITOR (clocking uartt_cbm);

endinterface : uart_transmitter_if