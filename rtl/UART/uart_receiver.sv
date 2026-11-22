package uart_r_package;

    typedef enum logic [1:0] {
        IDLE, 
        START_BIT, 
        DATA_BITS, 
        STOP_BIT
    } uart_state_r;

endpackage : uart_r_package

module uart_receiver (uart_receiver_if.DUT uartr_if);
    import uart_r_package::*;

    parameter int unsigned CLKS_PER_BIT = 868;
    localparam int unsigned HALF_BIT = CLKS_PER_BIT / 2;

    localparam int unsigned COUNTER_WIDTH = (CLKS_PER_BIT > 1) ? $clog2(CLKS_PER_BIT) : 1;

    logic [COUNTER_WIDTH-1:0] baud_count;
    logic [7:0] received_data;
    logic [2:0] bit_index;

    (* ASYNC_REG = "TRUE" *) logic rx_meta;
    (* ASYNC_REG = "TRUE" *) logic rx_sync;

    uart_state_r state;

    always_ff @(posedge uartr_if.clk) begin
        if (uartr_if.reset) begin
            rx_meta <= 1'b1;
            rx_sync <= 1'b1;
        end
        else begin
            rx_meta <= uartr_if.rx;
            rx_sync <= rx_meta;
        end
    end

    always_ff @(posedge uartr_if.clk) begin
        if(uartr_if.reset) begin
            state <= IDLE;
            baud_count <= '0;
            bit_index <= 0;
            received_data <= 8'd0;
            uartr_if.data <= 8'd0;
            uartr_if.valid <= 1'b0;
            uartr_if.framing_error <= 1'b0;
        end
        else begin
            uartr_if.valid         <= 1'b0;
            uartr_if.framing_error <= 1'b0;

            case(state)
                IDLE: begin
                    if(rx_sync == 1'b0) begin
                        state <= START_BIT;
                        baud_count <= '0;
                    end
                    bit_index <= 0;
                end
                START_BIT: begin
                    bit_index <= 0;
                    if (baud_count == HALF_BIT - 1) begin
                        baud_count <= '0;

                        if (rx_sync == 1'b0)
                            state <= DATA_BITS;
                        else
                            state <= IDLE;
                    end
                    else begin
                        baud_count <= baud_count + 1'b1;
                    end
                end
                DATA_BITS: begin
                    if (baud_count == CLKS_PER_BIT - 1) begin
                        baud_count <= '0;
                        received_data[bit_index] <= rx_sync;

                        if (bit_index == 3'd7) begin
                            state <= STOP_BIT;
                        end
                        else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end
                    else begin
                        baud_count <= baud_count + 1'b1;
                    end
                end
                STOP_BIT: begin
                    if (baud_count == CLKS_PER_BIT - 1) begin
                        baud_count <= '0;

                        if (rx_sync == 1'b1) begin
                            uartr_if.data  <= received_data;
                            uartr_if.valid <= 1'b1;
                        end
                        else begin
                            uartr_if.framing_error <= 1'b1;
                        end

                        state <= IDLE;
                    end
                    else begin
                        baud_count <= baud_count + 1'b1;
                    end
                end
                default: begin
                    state      <= IDLE;
                    baud_count <= '0;
                    bit_index  <= '0;
                end
            endcase
        end
    end

endmodule : uart_receiver