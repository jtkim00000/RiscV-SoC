module uartr_tb_top;
    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    import uartr_tb_pkg::*;

    bit clk;
    always #10ns clk = ~clk;

    uart_receiver_if uartr_if0 (clk);
    uart_receiver dut0 (uartr_if0.DUT);

    initial begin
        uartr_if0.reset      = 1'b1;
        uartr_if0.rx      = 1'b1;

        uvm_config_db#(virtual uart_receiver_if.TEST)::set(null, "uvm_test_top.m_top_env.m_agent.m_driver", "vif", uartr_if0);

        uvm_config_db#(virtual uart_receiver_if.MONITOR)::set(null, "uvm_test_top.m_top_env.m_agent.m_monitor", "vif", uartr_if0);

        uvm_config_db#(int unsigned)::set(
            null,
            "uvm_test_top.m_top_env.m_scoreboard",
            "clks_per_bit",
            868
        );

        run_test("uartr_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule : uartr_tb_top