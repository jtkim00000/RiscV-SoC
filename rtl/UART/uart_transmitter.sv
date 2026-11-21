package uart_t_package;

    typedef enum logic [1:0] {
        IDLE, 
        START_BIT, 
        DATA_BITS, 
        STOP_BIT
    } uart_state_t;

endpackage : uart_t_package

module uart_transmitter (uart_transmitter_if.DUT uart_transmitterif);

    import uart_t_package::*;

    uart_state_t state;
    logic [7:0] captured_data;
    logic [2:0] bit_index;

    parameter int unsigned CLKS_PER_BIT = 868;

    localparam int unsigned COUNTER_WIDTH = (CLKS_PER_BIT > 1) ? $clog2(CLKS_PER_BIT) : 1;

    logic [COUNTER_WIDTH-1:0] baud_count;

    always_ff @(posedge uart_transmitterif.clk) begin
        if (uart_transmitterif.reset) begin
            state                   <= IDLE;
            uart_transmitterif.tx   <= 1'b1;
            uart_transmitterif.busy <= 1'b0;
            captured_data           <= 8'd0;
            bit_index               <= 3'd0;
            baud_count              <= '0;
        end
        else begin
            case(state)
                IDLE: begin
                    uart_transmitterif.tx <= 1'b1;
                    uart_transmitterif.busy <= 1'b0;
                    captured_data <= uart_transmitterif.data;
                    bit_index <= 3'b000;

                    if (uart_transmitterif.start) begin
                        captured_data           <= uart_transmitterif.data;
                        uart_transmitterif.busy <= 1'b1;
                        state                   <= START_BIT;
                    end
                end
                START_BIT: begin
                    uart_transmitterif.tx <= 1'b0;
                    uart_transmitterif.busy <= 1'b1;

                    if (baud_count == CLKS_PER_BIT - 1) begin
                        baud_count <= '0;
                        state <= DATA_BITS;
                    end
                    else begin
                        baud_count <= baud_count + 1'b1;
                    end
                end
                DATA_BITS: begin
                    uart_transmitterif.tx <= captured_data[bit_index];
                    uart_transmitterif.busy <= 1'b1;

                    if (baud_count == CLKS_PER_BIT - 1) begin
                        baud_count <= '0;
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
                    uart_transmitterif.tx <= 1'b1;
                    uart_transmitterif.busy <= 1'b1;
                    bit_index <= 3'b000;

                    if (baud_count == CLKS_PER_BIT - 1) begin
                        baud_count <= '0;
                        state <= IDLE;
                    end
                    else begin
                        baud_count <= baud_count + 1'b1;
                    end
                end
            endcase
        end
    end

endmodule : uart_transmitter