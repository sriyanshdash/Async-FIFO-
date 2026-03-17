// =============================================================================
// File        : test_reset_scenarios.sv
// Description : TEST 7 - RESET SCENARIOS
//
// Subpart defines:
//   TEST_RESET_SCENARIOS_RESET_WHEN_EMPTY          — Reset when FIFO is empty
//   TEST_RESET_SCENARIOS_RESET_WHEN_FULL            — Reset when FIFO is full
//   TEST_RESET_SCENARIOS_RESET_PARTIAL_FILL         — Reset when partially filled
//   TEST_RESET_SCENARIOS_RESET_DURING_WRITE         — Reset while wr_en is active
//   TEST_RESET_SCENARIOS_RESET_DURING_READ          — Reset while rd_en is active
//   TEST_RESET_SCENARIOS_SIMULTANEOUS_RESET_WRITE   — Reset + wr_en at same time
//   TEST_RESET_SCENARIOS_SIMULTANEOUS_RESET_READ    — Reset + rd_en at same time
// =============================================================================

`ifndef TEST_RESET_SCENARIOS_SV
`define TEST_RESET_SCENARIOS_SV

// If no subpart defined, enable all
`ifndef TEST_RESET_SCENARIOS_RESET_WHEN_EMPTY
`ifndef TEST_RESET_SCENARIOS_RESET_WHEN_FULL
`ifndef TEST_RESET_SCENARIOS_RESET_PARTIAL_FILL
`ifndef TEST_RESET_SCENARIOS_RESET_DURING_WRITE
`ifndef TEST_RESET_SCENARIOS_RESET_DURING_READ
`ifndef TEST_RESET_SCENARIOS_SIMULTANEOUS_RESET_WRITE
`ifndef TEST_RESET_SCENARIOS_SIMULTANEOUS_RESET_READ
    `define TEST_RESET_SCENARIOS_RESET_WHEN_EMPTY
    `define TEST_RESET_SCENARIOS_RESET_WHEN_FULL
    `define TEST_RESET_SCENARIOS_RESET_PARTIAL_FILL
    `define TEST_RESET_SCENARIOS_RESET_DURING_WRITE
    `define TEST_RESET_SCENARIOS_RESET_DURING_READ
    `define TEST_RESET_SCENARIOS_SIMULTANEOUS_RESET_WRITE
    `define TEST_RESET_SCENARIOS_SIMULTANEOUS_RESET_READ
`endif
`endif
`endif
`endif
`endif
`endif
`endif

class test_reset_scenarios #(parameter FIFO_WIDTH = 64, parameter FIFO_DEPTH = 8)
    extends fifo_test_base #(FIFO_WIDTH, FIFO_DEPTH);

    function new();
    endfunction

    task run();
        `ifdef TEST_RESET_SCENARIOS_RESET_WHEN_EMPTY
            $display("\n  --- Reset when empty ---");
            check_flag("fifo_empty before reset", vif.fifo_empty, 1);
            reset_phase();
            check_flag("fifo_empty after reset", vif.fifo_empty, 1);
            check_flag("fifo_full after reset", vif.fifo_full, 0);
            write_n(1);
            read_n(1);
            wait_drain();
        `endif

        `ifdef TEST_RESET_SCENARIOS_RESET_WHEN_FULL
            $display("  --- Reset when full ---");
            write_n(FIFO_DEPTH);
            wait_drain();
            check_flag("fifo_full before reset", vif.fifo_full, 1);
            reset_phase();
            check_flag("fifo_empty after full-reset", vif.fifo_empty, 1);
            check_flag("fifo_full after full-reset", vif.fifo_full, 0);
            write_data(64'hF0E5_0000_0000_0001);
            read_n(1);
            wait_drain();
        `endif

        `ifdef TEST_RESET_SCENARIOS_RESET_PARTIAL_FILL
            $display("  --- Reset when partially filled ---");
            write_n(FIFO_DEPTH / 2);
            wait_drain();
            reset_phase();
            check_flag("fifo_empty after partial-reset", vif.fifo_empty, 1);
            write_n(1);
            read_n(1);
            wait_drain();
        `endif

        `ifdef TEST_RESET_SCENARIOS_RESET_DURING_WRITE
            $display("  --- Reset during active write ---");
            @(posedge vif.wrclk); #1;
            vif.wr_en   = 1;
            vif.data_in = 64'hD01C_0000_0000_0001;
            vif.wrst_n  = 0;
            vif.rrst_n  = 0;
            vif.wr_en   = 0;
            vif.data_in = '0;
            repeat (5) @(posedge vif.wrclk);
            @(posedge vif.wrclk); #1;
            vif.wrst_n  = 1;
            vif.rrst_n  = 1;
            @(posedge vif.wrclk); #1;
            env.reset();
            check_flag("fifo_empty after wr-during-reset", vif.fifo_empty, 1);
            write_n(1);
            read_n(1);
            wait_drain();
        `endif

        `ifdef TEST_RESET_SCENARIOS_RESET_DURING_READ
            $display("  --- Reset during active read ---");
            write_n(4);
            wait_drain();
            @(posedge vif.rdclk); #1;
            vif.rd_en   = 1;
            vif.wrst_n  = 0;
            vif.rrst_n  = 0;
            vif.rd_en   = 0;
            repeat (5) @(posedge vif.wrclk);
            @(posedge vif.wrclk); #1;
            vif.wrst_n  = 1;
            vif.rrst_n  = 1;
            @(posedge vif.wrclk); #1;
            env.reset();
            check_flag("fifo_empty after rd-during-reset", vif.fifo_empty, 1);
            write_n(1);
            read_n(1);
            wait_drain();
        `endif

        `ifdef TEST_RESET_SCENARIOS_SIMULTANEOUS_RESET_WRITE
            $display("  --- Simultaneous reset + write ---");
            vif.wrst_n  = 0;
            vif.rrst_n  = 0;
            vif.wr_en   = 1;
            vif.data_in = 64'h5100_0000_0000_0001;
            repeat (5) @(posedge vif.wrclk);
            vif.wr_en   = 0;
            vif.data_in = '0;
            @(posedge vif.wrclk); #1;
            vif.wrst_n  = 1;
            vif.rrst_n  = 1;
            @(posedge vif.wrclk); #1;
            env.reset();
            check_flag("fifo_empty after simul wr+reset", vif.fifo_empty, 1);
            write_n(1);
            read_n(1);
            wait_drain();
        `endif

        `ifdef TEST_RESET_SCENARIOS_SIMULTANEOUS_RESET_READ
            $display("  --- Simultaneous reset + read ---");
            write_n(4);
            wait_drain();
            vif.wrst_n  = 0;
            vif.rrst_n  = 0;
            vif.rd_en   = 1;
            repeat (5) @(posedge vif.wrclk);
            vif.rd_en   = 0;
            @(posedge vif.wrclk); #1;
            vif.wrst_n  = 1;
            vif.rrst_n  = 1;
            @(posedge vif.wrclk); #1;
            env.reset();
            check_flag("fifo_empty after simul rd+reset", vif.fifo_empty, 1);
            write_n(1);
            read_n(1);
            wait_drain();
        `endif
    endtask
endclass : test_reset_scenarios

`endif
