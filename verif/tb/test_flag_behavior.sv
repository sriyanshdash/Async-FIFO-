// =============================================================================
// File        : test_flag_behavior.sv
// Description : TEST 4 - FLAG BEHAVIOR
//
// Subpart defines:
//   TEST_FLAG_BEHAVIOR_FULL_FLAG_TIMING   — Full flag asserts at exactly DEPTH
//   TEST_FLAG_BEHAVIOR_FULL_FLAG_CLEAR    — Full flag deasserts after 1 read
//   TEST_FLAG_BEHAVIOR_EMPTY_FLAG_TIMING  — Empty flag asserts after last read
//   TEST_FLAG_BEHAVIOR_EMPTY_FLAG_CLEAR   — Empty flag deasserts after 1 write
// =============================================================================

`ifndef TEST_FLAG_BEHAVIOR_SV
`define TEST_FLAG_BEHAVIOR_SV

// If no subpart defined, enable all
`ifndef TEST_FLAG_BEHAVIOR_FULL_FLAG_TIMING
`ifndef TEST_FLAG_BEHAVIOR_FULL_FLAG_CLEAR
`ifndef TEST_FLAG_BEHAVIOR_EMPTY_FLAG_TIMING
`ifndef TEST_FLAG_BEHAVIOR_EMPTY_FLAG_CLEAR
    `define TEST_FLAG_BEHAVIOR_FULL_FLAG_TIMING
    `define TEST_FLAG_BEHAVIOR_FULL_FLAG_CLEAR
    `define TEST_FLAG_BEHAVIOR_EMPTY_FLAG_TIMING
    `define TEST_FLAG_BEHAVIOR_EMPTY_FLAG_CLEAR
`endif
`endif
`endif
`endif

class test_flag_behavior #(parameter FIFO_WIDTH = 64, parameter FIFO_DEPTH = 8)
    extends fifo_test_base #(FIFO_WIDTH, FIFO_DEPTH);

    function new();
    endfunction

    task run();
        `ifdef TEST_FLAG_BEHAVIOR_FULL_FLAG_TIMING
            $display("\n  --- Full flag timing (write one at a time) ---");
            for (int i = 0; i < FIFO_DEPTH; i++) begin
                if (i > 0)
                    check_flag($sformatf("fifo_full after %0d writes", i), vif.fifo_full, 0);
                write_n(1);
                wait_drain();
            end
            check_flag("fifo_full after DEPTH writes", vif.fifo_full, 1);
            read_n(FIFO_DEPTH);
            wait_drain();
        `endif

        `ifdef TEST_FLAG_BEHAVIOR_FULL_FLAG_CLEAR
            $display("  --- Full flag clears after 1 read ---");
            write_n(FIFO_DEPTH);
            wait_drain();
            read_n(1);
            wait_drain();
            check_flag("fifo_full after 1 read", vif.fifo_full, 0);
            read_n(FIFO_DEPTH - 1);
            wait_drain();
        `endif

        `ifdef TEST_FLAG_BEHAVIOR_EMPTY_FLAG_TIMING
            $display("  --- Empty flag timing (read one at a time) ---");
            write_n(FIFO_DEPTH);
            wait_drain();
            for (int i = 0; i < FIFO_DEPTH; i++) begin
                if (i < FIFO_DEPTH - 1)
                    check_flag($sformatf("fifo_empty after %0d reads", i), vif.fifo_empty, 0);
                read_n(1);
                wait_drain();
            end
            check_flag("fifo_empty after DEPTH reads", vif.fifo_empty, 1);
        `endif

        `ifdef TEST_FLAG_BEHAVIOR_EMPTY_FLAG_CLEAR
            $display("  --- Empty flag clears after 1 write ---");
            write_n(1);
            wait_drain();
            check_flag("fifo_empty after 1 write", vif.fifo_empty, 0);
            read_n(1);
            wait_drain();
        `endif
    endtask
endclass : test_flag_behavior

`endif
