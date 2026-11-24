module fifor_tb_top;
    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    import fifor_tb_pkg::*;

    bit clk;
    always #10ns clk = ~clk;

    fifo_receiver_if fifor_if0 (clk);
    fifo_receiver dut0 (fifor_if0.DUT);

    initial begin
        fifor_if0.reset = 1'b1;
        fifor_if0.write_data = 8'd0;
        fifor_if0.write = 1'b0;
        fifor_if0.read = 1'b0;

        uvm_config_db#(virtual fifo_receiver_if.TEST)::set(null, "uvm_test_top.m_top_env.m_agent.m_driver", "vif", fifor_if0);

        uvm_config_db#(virtual fifo_receiver_if.MONITOR)::set(null, "uvm_test_top.m_top_env.m_agent.m_monitor", "vif", fifor_if0);

        run_test("fifor_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule : fifor_tb_top