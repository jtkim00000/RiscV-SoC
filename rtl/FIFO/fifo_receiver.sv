module fifo_receiver #(parameter int unsigned DEPTH = 8) (fifo_receiver_if.DUT fifor_if);

    localparam int unsigned PTR_WIDTH = (DEPTH > 1) ? $clog2(DEPTH) : 1;

    localparam int unsigned COUNT_WIDTH = $clog2(DEPTH + 1);

    logic [7:0] storage [0:DEPTH-1];

    logic [PTR_WIDTH-1:0] write_pointer;
    logic [PTR_WIDTH-1:0] read_pointer;
    logic [COUNT_WIDTH-1:0] count;

    logic do_write;
    logic do_read;

    assign fifor_if.empty = (count == 0);
    assign fifor_if.full  = (count == DEPTH);

    assign do_write = fifor_if.write && !fifor_if.full;
    assign do_read  = fifor_if.read  && !fifor_if.empty;

    always_ff @(posedge fifor_if.clk) begin
        if (fifor_if.reset) begin
            write_pointer <= '0;
            read_pointer  <= '0;
            count         <= '0;
            fifor_if.read_data     <= '0;
        end
        else begin
            if (do_write) begin
                storage[write_pointer] <= fifor_if.write_data;

                if (write_pointer == DEPTH - 1)
                    write_pointer <= '0;
                else
                    write_pointer <= write_pointer + 1'b1;
            end

            if (do_read) begin
                fifor_if.read_data <= storage[read_pointer];

                if (read_pointer == DEPTH - 1)
                    read_pointer <= '0;
                else
                    read_pointer <= read_pointer + 1'b1;
            end

            case ({do_write, do_read})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end

endmodule : fifo_receiver