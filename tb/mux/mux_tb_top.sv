module mux_tb_top;

    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    import mux_tb_pkg::*;

    bit clk;
    always #10ns clk = ~clk;

    mux_if #(
        .DATA_WIDTH(32),
        .INPUT_WIDTH(4)
    ) mux_if0 (.clk(clk));
    
    mux dut0 (mux_if0.DUT);

    initial begin
        mux_if0.data_in = 32'd0;// CHANGE
        mux_if0.sel = 32'd0;

        uvm_config_db#(virtual mux_if #(.DATA_WIDTH(32), .INPUT_WIDTH(4)).TEST)::set(null, "uvm_test_top.m_top_env.m_agent.m_driver", "vif", mux_if0);

        uvm_config_db#(virtual mux_if #(.DATA_WIDTH(32), .INPUT_WIDTH(4)).MONITOR)::set(null, "uvm_test_top.m_top_env.m_agent.m_monitor", "vif", mux_if0);

        run_test("mux_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule : mux_tb_top