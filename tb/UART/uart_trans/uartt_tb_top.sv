module uartt_tb_top;
    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    import uartt_tb_pkg::*;

    bit clk;
    always #10ns clk = ~clk;

    uart_transmitter_if uartt_if0 (clk);
    uart_transmitter dut0 (uartt_if0.DUT);

    initial begin
        uartt_if0.reset      = 1'b1;
        uartt_if0.start      = 1'b0;
        uartt_if0.data       = 8'd0;

        uvm_config_db#(virtual uart_transmitter_if.TEST)::set(null, "uvm_test_top.m_top_env.m_agent.m_driver", "vif", uartt_if0);

        uvm_config_db#(virtual uart_transmitter_if.MONITOR)::set(null, "uvm_test_top.m_top_env.m_agent.m_monitor", "vif", uartt_if0);

        uvm_config_db#(int unsigned)::set(
            null,
            "uvm_test_top.m_top_env.m_scoreboard",
            "clks_per_bit",
            868
        );

        run_test("uartt_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule : uartt_tb_top