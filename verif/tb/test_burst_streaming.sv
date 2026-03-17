// =============================================================================
// File        : test_burst_streaming.sv
// Description : TEST 3 - BURST AND STREAMING
//
// Subpart defines:
//   TEST_BURST_STREAMING_BURST_WRITE_READ     — Burst write then burst read
//   TEST_BURST_STREAMING_SIMULTANEOUS_RW      — Simultaneous writes and reads
//   TEST_BURST_STREAMING_CONTINUOUS_STREAMING  — 100-transaction streaming
// =============================================================================

`ifndef TEST_BURST_STREAMING_SV
`define TEST_BURST_STREAMING_SV

// If no subpart defined, enable all
`ifndef TEST_BURST_STREAMING_BURST_WRITE_READ
`ifndef TEST_BURST_STREAMING_SIMULTANEOUS_RW
`ifndef TEST_BURST_STREAMING_CONTINUOUS_STREAMING
    `define TEST_BURST_STREAMING_BURST_WRITE_READ
    `define TEST_BURST_STREAMING_SIMULTANEOUS_RW
    `define TEST_BURST_STREAMING_CONTINUOUS_STREAMING
`endif
`endif
`endif

class test_burst_streaming #(parameter FIFO_WIDTH = 64, parameter FIFO_DEPTH = 8)
    extends fifo_test_base #(FIFO_WIDTH, FIFO_DEPTH);

    function new();
    endfunction

    task run();
        `ifdef TEST_BURST_STREAMING_BURST_WRITE_READ
            $display("\n  --- Burst write %0d, then burst read ---", FIFO_DEPTH);
            write_n(FIFO_DEPTH);
            wait_drain();
            read_n(FIFO_DEPTH);
            wait_drain();
        `endif

        `ifdef TEST_BURST_STREAMING_SIMULTANEOUS_RW
            $display("  --- Simultaneous writes and reads ---");
            write_n(FIFO_DEPTH / 2);
            wait_drain();
            fork
                write_n(20);
                read_n(20 + FIFO_DEPTH / 2);
            join
            wait_drain();
        `endif

        `ifdef TEST_BURST_STREAMING_CONTINUOUS_STREAMING
            $display("  --- Continuous streaming (100 writes, 100 reads) ---");
            write_n(FIFO_DEPTH / 2);
            wait_drain();
            fork
                write_n(100);
                read_n(100 + FIFO_DEPTH / 2);
            join
            wait_drain();
        `endif
    endtask
endclass : test_burst_streaming

`endif
