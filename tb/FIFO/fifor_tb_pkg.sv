package fifor_tb_pkg;
    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "fifor_item.svh"
    `include "fifor_sequence.svh"
    `include "fifor_sequencer.svh"
    `include "fifor_driver.svh"
    `include "fifor_monitor.svh"
    `include "fifor_coverage.svh"
    `include "fifor_agent.svh"
    `include "fifor_scoreboard.svh"
    `include "fifor_env.svh"
    `include "fifor_test.svh"

endpackage : fifor_tb_pkg