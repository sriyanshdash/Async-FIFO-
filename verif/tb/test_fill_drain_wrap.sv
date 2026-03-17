// =============================================================================
// File        : test_fill_drain_wrap.sv
// Description : TEST 2 - FILL, DRAIN, AND POINTER WRAP-AROUND
//
// Subpart defines:
//   TEST_FILL_DRAIN_WRAP_FILL_DRAIN      — Fill to full, drain to empty
//   TEST_FILL_DRAIN_WRAP_POINTER_WRAP    — 3x fill-drain cycles (pointer wrap)
//   TEST_FILL_DRAIN_WRAP_DEPTH_BOUNDARY  — Interleaved ops at depth boundary
// =============================================================================

`ifndef TEST_FILL_DRAIN_WRAP_SV
`define TEST_FILL_DRAIN_WRAP_SV

// If no subpart defined, enable all
`ifndef TEST_FILL_DRAIN_WRAP_FILL_DRAIN
`ifndef TEST_FILL_DRAIN_WRAP_POINTER_WRAP
`ifndef TEST_FILL_DRAIN_WRAP_DEPTH_BOUNDARY
    `define TEST_FILL_DRAIN_WRAP_FILL_DRAIN
    `define TEST_FILL_DRAIN_WRAP_POINTER_WRAP
    `define TEST_FILL_DRAIN_WRAP_DEPTH_BOUNDARY
`endif
`endif
`endif

class test_fill_drain_wrap #(parameter FIFO_WIDTH = 64, parameter FIFO_DEPTH = 8)
    extends fifo_test_base #(FIFO_WIDTH, FIFO_DEPTH);

    function new();
    endfunction

    task run();
        `ifdef TEST_FILL_DRAIN_WRAP_FILL_DRAIN
            $display("\n  --- Fill to full, drain to empty ---");
            write_n(FIFO_DEPTH);
            wait_drain();
            check_flag("fifo_full", vif.fifo_full, 1);
            read_n(FIFO_DEPTH);
            wait_drain();
            check_flag("fifo_empty", vif.fifo_empty, 1);
        `endif

        `ifdef TEST_FILL_DRAIN_WRAP_POINTER_WRAP
            $display("  --- 3x fill-drain cycles (pointer wrap) ---");
            for (int i = 0; i < 3; i++) begin
                $display("    Cycle %0d", i);
                write_n(FIFO_DEPTH);
                read_n(FIFO_DEPTH);
                wait_drain();
            end
        `endif

        `ifdef TEST_FILL_DRAIN_WRAP_DEPTH_BOUNDARY
            $display("  --- Depth boundary interleave ---");
            write_n(FIFO_DEPTH - 1);
            read_n(1);
            wait_drain();
            write_n(2);
            wait_drain();
            check_flag("fifo_full", vif.fifo_full, 1);
            read_n(FIFO_DEPTH);
            wait_drain();
        `endif
    endtask
endclass : test_fill_drain_wrap

`endif
