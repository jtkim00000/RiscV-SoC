interface fifo_receiver_if (input bit clk);

    logic reset;
    logic read;
    logic write;
    logic [7:0] write_data;
    logic [7:0] read_data;
    logic empty;
    logic full;

    clocking fifor_cb @(posedge clk);
        default input #1step output #0;
        input read_data, empty, full;
        output reset, read, write, write_data;
    endclocking : fifor_cb

    clocking fifor_cbm @(posedge clk);
        default input #1step;
        input reset, read, write, write_data, read_data, empty, full;
    endclocking : fifor_cbm

    modport DUT (
        input clk, reset, read, write, write_data,
        output read_data, empty, full
    );

    modport TEST (clocking fifor_cb);

    modport MONITOR (clocking fifor_cbm);

endinterface : fifo_receiver_if