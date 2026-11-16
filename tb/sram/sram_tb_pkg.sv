package sram_tb_pkg;
    timeunit 1ns; 
    timeprecision 1ps;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "sram_item.svh"
    `include "sram_sequence.svh"
    `include "sram_sequencer.svh"
    `include "sram_driver.svh"
    `include "sram_monitor.svh"
    `include "sram_coverage.svh"
    `include "sram_agent.svh"
    `include "sram_scoreboard.svh"
    `include "sram_env.svh"
    `include "sram_test.svh"

endpackage : sram_tb_pkg