module sram_tb_top;
    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    import sram_tb_pkg::*;

    bit clk;
    always #10ns clk = ~clk;

    sram_if sram_if0 (clk);
    sram dut0 (sram_if0.DUT);

    initial begin
        sram_if0.reset      = 1'b1;
        sram_if0.write_data = 32'd0;

        uvm_config_db#(virtual sram_if.TEST)::set(null, "uvm_test_top.m_top_env.m_agent.m_driver", "vif", sram_if0);

        uvm_config_db#(virtual sram_if.MONITOR)::set(null, "uvm_test_top.m_top_env.m_agent.m_monitor", "vif", sram_if0);

        run_test("sram_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule : sram_tb_top