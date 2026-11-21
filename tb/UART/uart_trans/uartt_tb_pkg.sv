package uartt_tb_pkg;
    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "uartt_item.svh"
    `include "uartt_sequence.svh"
    `include "uartt_sequencer.svh"
    `include "uartt_driver.svh"
    `include "uartt_monitor.svh"
    `include "uartt_coverage.svh"
    `include "uartt_agent.svh"
    `include "uartt_scoreboard.svh"
    `include "uartt_env.svh"
    `include "uartt_test.svh"

endpackage : uartt_tb_pkg