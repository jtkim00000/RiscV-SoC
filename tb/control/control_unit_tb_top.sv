module control_unit_tb_top;

    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    import control_unit_tb_pkg::*;

    bit clk;
    always #10ns clk = ~clk;

    control_unit_if control_unit_if0 (clk);
    control_unit dut0 (control_unit_if0.DUT);

    initial begin
        control_unit_if0.instr = 32'd0;

        uvm_config_db#(virtual control_unit_if.TEST)::set(null, "uvm_test_top.m_top_env.m_agent.m_driver", "vif", control_unit_if0);

        uvm_config_db#(virtual control_unit_if.MONITOR)::set(null, "uvm_test_top.m_top_env.m_agent.m_monitor", "vif", control_unit_if0);

        run_test("control_unit_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule : control_unit_tb_top