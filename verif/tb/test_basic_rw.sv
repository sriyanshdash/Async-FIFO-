// =============================================================================
// File        : test_basic_rw.sv
// Description : TEST 1 - BASIC READ/WRITE
//
// Subpart defines:
//   TEST_BASIC_RW_WRITE_READ_BACK  — Write N values, read all back
//   TEST_BASIC_RW_SINGLE_ENTRY     — Single entry write and read
//   TEST_BASIC_RW_ALTERNATING_RW   — Alternating write-read (20 pairs)
// =============================================================================

`ifndef TEST_BASIC_RW_SV
`define TEST_BASIC_RW_SV

// If no subpart defined, enable all
`ifndef TEST_BASIC_RW_WRITE_READ_BACK
`ifndef TEST_BASIC_RW_SINGLE_ENTRY
`ifndef TEST_BASIC_RW_ALTERNATING_RW
    `define TEST_BASIC_RW_WRITE_READ_BACK
    `define TEST_BASIC_RW_SINGLE_ENTRY
    `define TEST_BASIC_RW_ALTERNATING_RW
`endif
`endif
`endif

class test_basic_rw #(parameter FIFO_WIDTH = 64, parameter FIFO_DEPTH = 8)
    extends fifo_test_base #(FIFO_WIDTH, FIFO_DEPTH);

    function new();
    endfunction

    task run();
        `ifdef TEST_BASIC_RW_WRITE_READ_BACK
            $display("\n  --- Write %0d random values, read all back ---", FIFO_DEPTH);
            write_n(FIFO_DEPTH);
            read_n(FIFO_DEPTH);
            wait_drain();
        `endif

        `ifdef TEST_BASIC_RW_SINGLE_ENTRY
            $display("  --- Single entry write and read ---");
            write_data(64'hDEAD_BEEF_CAFE_BABE);
            read_n(1);
            wait_drain();
        `endif

        `ifdef TEST_BASIC_RW_ALTERNATING_RW
            $display("  --- Alternating write-read (20 pairs) ---");
            for (int i = 0; i < 20; i++) begin
                write_n(1);
                read_n(1);
                wait_drain();
            end
        `endif
    endtask
endclass : test_basic_rw

`endif
