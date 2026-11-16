package mux_tb_pkg;
    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "mux_item.svh"
    `include "mux_sequence.svh"
    `include "mux_sequencer.svh"
    `include "mux_driver.svh"
    `include "mux_monitor.svh"
    `include "mux_coverage.svh"
    `include "mux_agent.svh"
    `include "mux_scoreboard.svh"
    `include "mux_env.svh"
    `include "mux_test.svh"

endpackage : mux_tb_pkg