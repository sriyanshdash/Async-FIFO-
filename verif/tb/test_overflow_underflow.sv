// =============================================================================
// File        : test_overflow_underflow.sv
// Description : TEST 6 - OVERFLOW AND UNDERFLOW PROTECTION
//
// Subpart defines:
//   TEST_OVERFLOW_UNDERFLOW_SINGLE_OVERFLOW         — Write when full (ignored)
//   TEST_OVERFLOW_UNDERFLOW_BACK_TO_BACK_OVERFLOW   — 10 overflow writes
//   TEST_OVERFLOW_UNDERFLOW_SINGLE_UNDERFLOW        — Read when empty (ignored)
//   TEST_OVERFLOW_UNDERFLOW_BACK_TO_BACK_UNDERFLOW  — 10 underflow reads
// =============================================================================

`ifndef TEST_OVERFLOW_UNDERFLOW_SV
`define TEST_OVERFLOW_UNDERFLOW_SV

// If no subpart defined, enable all
`ifndef TEST_OVERFLOW_UNDERFLOW_SINGLE_OVERFLOW
`ifndef TEST_OVERFLOW_UNDERFLOW_BACK_TO_BACK_OVERFLOW
`ifndef TEST_OVERFLOW_UNDERFLOW_SINGLE_UNDERFLOW
`ifndef TEST_OVERFLOW_UNDERFLOW_BACK_TO_BACK_UNDERFLOW
    `define TEST_OVERFLOW_UNDERFLOW_SINGLE_OVERFLOW
    `define TEST_OVERFLOW_UNDERFLOW_BACK_TO_BACK_OVERFLOW
    `define TEST_OVERFLOW_UNDERFLOW_SINGLE_UNDERFLOW
    `define TEST_OVERFLOW_UNDERFLOW_BACK_TO_BACK_UNDERFLOW
`endif
`endif
`endif
`endif

class test_overflow_underflow #(parameter FIFO_WIDTH = 64, parameter FIFO_DEPTH = 8)
    extends fifo_test_base #(FIFO_WIDTH, FIFO_DEPTH);

    function new();
    endfunction

    task run();
        `ifdef TEST_OVERFLOW_UNDERFLOW_SINGLE_OVERFLOW
            $display("\n  --- Single overflow attempt ---");
            write_n(FIFO_DEPTH);
            wait_drain();
            check_flag("fifo_full before overflow", vif.fifo_full, 1);
            @(posedge vif.wrclk); #1;
            vif.wr_en   = 1;
            vif.data_in = 64'hBADD_A1A0_0000_0001;
            @(posedge vif.wrclk); #1;
            vif.wr_en   = 0;
            vif.data_in = '0;
            read_n(FIFO_DEPTH);
            wait_drain();
        `endif

        `ifdef TEST_OVERFLOW_UNDERFLOW_BACK_TO_BACK_OVERFLOW
            $display("  --- 10 back-to-back overflow writes ---");
            write_n(FIFO_DEPTH);
            wait_drain();
            for (int i = 0; i < 10; i++) begin
                @(posedge vif.wrclk); #1;
                vif.wr_en   = 1;
                vif.data_in = {32'hDEAD_0000 + i[31:0], 32'h0};
                @(posedge vif.wrclk); #1;
                vif.wr_en   = 0;
            end
            vif.data_in = '0;
            read_n(FIFO_DEPTH);
            wait_drain();
        `endif

        `ifdef TEST_OVERFLOW_UNDERFLOW_SINGLE_UNDERFLOW
            $display("  --- Single underflow attempt ---");
            check_flag("fifo_empty before underflow", vif.fifo_empty, 1);
            @(posedge vif.rdclk); #1;
            vif.rd_en = 1;
            @(posedge vif.rdclk); #1;
            vif.rd_en = 0;
            repeat (10) @(posedge vif.rdclk);
            write_n(1);
            read_n(1);
            wait_drain();
        `endif

        `ifdef TEST_OVERFLOW_UNDERFLOW_BACK_TO_BACK_UNDERFLOW
            $display("  --- 10 back-to-back underflow reads ---");
            for (int i = 0; i < 10; i++) begin
                @(posedge vif.rdclk); #1;
                vif.rd_en = 1;
                @(posedge vif.rdclk); #1;
                vif.rd_en = 0;
            end
            repeat (10) @(posedge vif.rdclk);
            write_n(1);
            read_n(1);
            wait_drain();
        `endif
    endtask
endclass : test_overflow_underflow

`endif
