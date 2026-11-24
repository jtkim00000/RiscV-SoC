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

    fifo_receiver_if fifo_if (.clk(clk));

    fifo_receiver fifo (fifo_if.DUT);

    uart_receiver_if rx_if (.clk(clk));

    uart_receiver #(
        .CLKS_PER_BIT(868)
    ) receiver (
        rx_if.DUT
    );

    assign rx_if.rx = uart_rx;
    assign uart_tx = tx_if.tx;

    assign fifo_if.write = rx_if.valid && !fifo_if.full && !reset_pipe[1];
    assign fifo_if.write_data = rx_if.data;

    typedef enum logic [1:0] {
        WAIT_BYTE,
        SEND_BYTE,
        WAIT_DONE
    } echo_state_t;

    echo_state_t echo_state;

    always_ff @(posedge clk) begin
        if (reset_pipe[1])
            echo_state <= WAIT_BYTE;
        else begin
            case (echo_state)
                WAIT_BYTE: begin
                    if (!fifo_if.empty && !tx_if.busy)
                        echo_state <= SEND_BYTE;
                end
                SEND_BYTE: echo_state <= WAIT_DONE;
                WAIT_DONE: begin
                    if (!tx_if.busy)
                        echo_state <= WAIT_BYTE;
                end
                default: echo_state <= WAIT_BYTE;
            endcase
        end
    end

    always_comb begin
        fifo_if.read = 1'b0;
        tx_if.start = 1'b0;
        tx_if.data = fifo_if.read_data;

        if (!reset_pipe[1]) begin
            case (echo_state)
                WAIT_BYTE: begin
                    if (!fifo_if.empty && !tx_if.busy)
                        fifo_if.read = 1'b1;
                end
                SEND_BYTE: tx_if.start = 1'b1;
                default: begin end
            endcase
        end
    end

endmodule : uart_top