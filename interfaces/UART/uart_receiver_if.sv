interface uart_receiver_if (input bit clk);

    logic reset, rx, valid, framing_error;
    logic [7:0] data;

    clocking uartr_cb @(posedge clk);
        default input #1step output #0;
        input data, valid, framing_error;
        output reset, rx;
    endclocking : uartr_cb

    clocking uartr_cbm @(posedge clk);
        default input #1step;
        input reset, rx, data, valid, framing_error;
    endclocking : uartr_cbm

    modport DUT (
        input clk, reset, rx,
        output data, valid, framing_error
    );

    modport TEST (clocking uartr_cb);

    modport MONITOR (clocking uartr_cbm);

endinterface : uart_reciver_if