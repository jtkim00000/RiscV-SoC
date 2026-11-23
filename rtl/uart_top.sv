module uart_top (
    input  logic clk,
    input  logic reset_btn,
    input  logic uart_rx,
    output logic uart_tx
);

    // Synchronize the external reset button.
    // Initial value also provides a short reset after configuration.
    (* ASYNC_REG = "TRUE" *)
    logic [1:0] reset_pipe = 2'b11;

    always_ff @(posedge clk) begin
        reset_pipe <= {reset_pipe[0], reset_btn};
    end

    uart_transmitter_if tx_if (.clk(clk));

    uart_transmitter #(
        .CLKS_PER_BIT(868)
    ) transmitter (
        tx_if.DUT
    );

    uart_receiver_if rx_if (.clk(clk));

    uart_receiver #(
        .CLKS_PER_BIT(868)
    ) receiver (
        rx_if.DUT
    );

    assign tx_if.reset = reset_pipe[1];
    assign rx_if.reset = reset_pipe[1];

    assign rx_if.rx = uart_rx;
    assign uart_tx = tx_if.tx;

    assign tx_if.data = rx_if.data;

    assign tx_if.start = rx_if.valid && !tx_if.busy && !reset_pipe[1];

endmodule : uart_top