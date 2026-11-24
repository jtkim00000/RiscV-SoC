module sram (sram_if.DUT sramif);

    logic [8:0] bank_addr [0:3];
    logic [3:0] bank_write_enable;
    logic [7:0] bank_write_data [0:3];
    logic [7:0] bank_read_data  [0:3];

    for (genvar bank = 0; bank < 4; bank++) begin : g_bank
        byte_ram #(
            .DEPTH(512)
        ) ram (
            .clk          (sramif.clk),
            .write_enable (bank_write_enable[bank]),
            .addr         (bank_addr[bank]),
            .write_data   (bank_write_data[bank]),
            .read_data    (bank_read_data[bank])
        );
    end

    logic sign_bit;

    always_comb begin : route_addresses
        for (int bank = 0; bank < 4; bank++) begin
            bank_addr[bank] = sramif.addr[10:2];

            if (bank < int'(sramif.addr[1:0]))
                bank_addr[bank] = bank_addr[bank] + 9'd1;
        end
    end

    always_comb begin : read_write
        int unsigned bank_index;
        sign_bit = 1'b0;


        for(integer i = 0; i < 4; ++i) begin
            bank_index = (int'(sramif.addr[1:0]) + i) % 4;

            if (i <= int'(sramif.num_bytes)) begin
                sramif.read_data[i*8 +: 8] = bank_read_data[bank_index];
                sign_bit = bank_read_data[bank_index][7];
            end
            else if (sramif.sz)
                sramif.read_data[i*8 +: 8] = {8{sign_bit}};
            else
                sramif.read_data[i*8 +: 8] = 8'h00;
        end

        for (int i = 0; i < 4; i++) begin
            bank_index = (int'(sramif.addr[1:0]) + i) % 4;

            bank_write_data[bank_index] = sramif.write_data[i*8 +: 8];

            bank_write_enable[bank_index] = sramif.write_enable && (i <= int'(sramif.num_bytes));
        end

    end

endmodule : sram