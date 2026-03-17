// =============================================================================
// File        : test_clock_ratio.sv
// Description : TEST 8 - CLOCK RATIO
//
// Subpart defines:
//   TEST_CLOCK_RATIO_FAST_WRITE_SLOW_READ  — 200 MHz write / 50 MHz read (4:1)
//   TEST_CLOCK_RATIO_SLOW_WRITE_FAST_READ  — 50 MHz write / 200 MHz read (1:4)
//   TEST_CLOCK_RATIO_SAME_FREQUENCY        — 100 MHz both sides
// =============================================================================

`ifndef TEST_CLOCK_RATIO_SV
`define TEST_CLOCK_RATIO_SV

// If no subpart defined, enable all
`ifndef TEST_CLOCK_RATIO_FAST_WRITE_SLOW_READ
`ifndef TEST_CLOCK_RATIO_SLOW_WRITE_FAST_READ
`ifndef TEST_CLOCK_RATIO_SAME_FREQUENCY
    `define TEST_CLOCK_RATIO_FAST_WRITE_SLOW_READ
    `define TEST_CLOCK_RATIO_SLOW_WRITE_FAST_READ
    `define TEST_CLOCK_RATIO_SAME_FREQUENCY
`endif
`endif
`endif

class test_clock_ratio #(parameter FIFO_WIDTH = 64, parameter FIFO_DEPTH = 8)
    extends fifo_test_base #(FIFO_WIDTH, FIFO_DEPTH);

    function new();
    endfunction

    task run();
        `ifdef TEST_CLOCK_RATIO_FAST_WRITE_SLOW_READ
            $display("\n  --- Fast write (200 MHz) / Slow read (50 MHz) ---");
            fifo_tb_top.wrclk_half = 2.5;
            fifo_tb_top.rdclk_half = 10.0;
            repeat (5) @(posedge vif.wrclk);
            reset_phase();
            write_n(FIFO_DEPTH);
            read_n(FIFO_DEPTH);
            wait_drain();
        `endif

        `ifdef TEST_CLOCK_RATIO_SLOW_WRITE_FAST_READ
            $display("  --- Slow write (50 MHz) / Fast read (200 MHz) ---");
            fifo_tb_top.wrclk_half = 10.0;
            fifo_tb_top.rdclk_half = 2.5;
            repeat (5) @(posedge vif.wrclk);
            reset_phase();
            write_n(FIFO_DEPTH);
            read_n(FIFO_DEPTH);
            wait_drain();
        `endif

        `ifdef TEST_CLOCK_RATIO_SAME_FREQUENCY
            $display("  --- Same frequency (100 MHz both) ---");
            fifo_tb_top.wrclk_half = 5.0;
            fifo_tb_top.rdclk_half = 5.0;
            repeat (5) @(posedge vif.wrclk);
            reset_phase();
            write_n(FIFO_DEPTH);
            read_n(FIFO_DEPTH);
            wait_drain();
        `endif

        // Restore defaults
        fifo_tb_top.wrclk_half = 5.0;
        fifo_tb_top.rdclk_half = 6.5;
        repeat (5) @(posedge vif.wrclk);
    endtask
endclass : test_clock_ratio

`endif
