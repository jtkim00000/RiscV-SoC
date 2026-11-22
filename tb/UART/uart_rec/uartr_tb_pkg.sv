package uartr_tb_pkg;
    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "uartr_item.svh"
    `include "uartr_sequence.svh"
    `include "uartr_sequencer.svh"
    `include "uartr_driver.svh"
    `include "uartr_monitor.svh"
    `include "uartr_coverage.svh"
    `include "uartr_agent.svh"
    `include "uartr_scoreboard.svh"
    `include "uartr_env.svh"
    `include "uartr_test.svh"

endpackage : uartr_tb_pkg