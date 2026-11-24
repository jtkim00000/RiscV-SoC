module byte_ram #(
    parameter int unsigned DEPTH = 512,
    parameter int unsigned ADDR_WIDTH =
        (DEPTH > 1) ? $clog2(DEPTH) : 1,
    parameter string INIT_FILE = ""
) (
    input  logic                  clk,
    input  logic                  write_enable,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [7:0]            write_data,
    output logic [7:0]            read_data
);

    (* ram_style = "distributed" *)
    logic [7:0] memory [0:DEPTH-1];

    initial begin
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, memory);
    end

    always_ff @(posedge clk) begin
        if (write_enable)
            memory[addr] <= write_data;
    end

    assign read_data = memory[addr];

endmodule : byte_ram