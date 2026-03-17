// =============================================================================
// File        : fifo_tb_top.sv
// Description : Top-level testbench for the Async FIFO.
//
// Usage:
//   Default (no defines)                         : runs all 9 tests (all subparts)
//   +define+TEST_BASIC_RW                        : runs all parts of test_basic_rw
//   +define+TEST_BASIC_RW_SINGLE_ENTRY           : runs only Single Entry subpart
//   +define+TEST_RESET_SCENARIOS_RESET_WHEN_FULL  : runs only Reset When Full subpart
//
// Test-level defines:
//   TEST_BASIC_RW, TEST_FILL_DRAIN_WRAP, TEST_BURST_STREAMING,
//   TEST_FLAG_BEHAVIOR, TEST_DATA_INTEGRITY, TEST_OVERFLOW_UNDERFLOW,
//   TEST_RESET_SCENARIOS, TEST_CLOCK_RATIO, TEST_STRESS
//
// Subpart defines (see individual test files for full list):
//   TEST_BASIC_RW_{WRITE_READ_BACK, SINGLE_ENTRY, ALTERNATING_RW}
//   TEST_FILL_DRAIN_WRAP_{FILL_DRAIN, POINTER_WRAP, DEPTH_BOUNDARY}
//   TEST_BURST_STREAMING_{BURST_WRITE_READ, SIMULTANEOUS_RW, CONTINUOUS_STREAMING}
//   TEST_FLAG_BEHAVIOR_{FULL_FLAG_TIMING, FULL_FLAG_CLEAR, EMPTY_FLAG_TIMING, EMPTY_FLAG_CLEAR}
//   TEST_OVERFLOW_UNDERFLOW_{SINGLE_OVERFLOW, BACK_TO_BACK_OVERFLOW, SINGLE_UNDERFLOW, BACK_TO_BACK_UNDERFLOW}
//   TEST_RESET_SCENARIOS_{RESET_WHEN_EMPTY, RESET_WHEN_FULL, RESET_PARTIAL_FILL,
//                         RESET_DURING_WRITE, RESET_DURING_READ,
//                         SIMULTANEOUS_RESET_WRITE, SIMULTANEOUS_RESET_READ}
//   TEST_CLOCK_RATIO_{FAST_WRITE_SLOW_READ, SLOW_WRITE_FAST_READ, SAME_FREQUENCY}
// =============================================================================

`timescale 1ns/1ps

// ---- Promote subpart defines to parent test defines ----

`ifdef TEST_BASIC_RW_WRITE_READ_BACK
    `define TEST_BASIC_RW
`endif
`ifdef TEST_BASIC_RW_SINGLE_ENTRY
    `define TEST_BASIC_RW
`endif
`ifdef TEST_BASIC_RW_ALTERNATING_RW
    `define TEST_BASIC_RW
`endif

`ifdef TEST_FILL_DRAIN_WRAP_FILL_DRAIN
    `define TEST_FILL_DRAIN_WRAP
`endif
`ifdef TEST_FILL_DRAIN_WRAP_POINTER_WRAP
    `define TEST_FILL_DRAIN_WRAP
`endif
`ifdef TEST_FILL_DRAIN_WRAP_DEPTH_BOUNDARY
    `define TEST_FILL_DRAIN_WRAP
`endif

`ifdef TEST_BURST_STREAMING_BURST_WRITE_READ
    `define TEST_BURST_STREAMING
`endif
`ifdef TEST_BURST_STREAMING_SIMULTANEOUS_RW
    `define TEST_BURST_STREAMING
`endif
`ifdef TEST_BURST_STREAMING_CONTINUOUS_STREAMING
    `define TEST_BURST_STREAMING
`endif

`ifdef TEST_FLAG_BEHAVIOR_FULL_FLAG_TIMING
    `define TEST_FLAG_BEHAVIOR
`endif
`ifdef TEST_FLAG_BEHAVIOR_FULL_FLAG_CLEAR
    `define TEST_FLAG_BEHAVIOR
`endif
`ifdef TEST_FLAG_BEHAVIOR_EMPTY_FLAG_TIMING
    `define TEST_FLAG_BEHAVIOR
`endif
`ifdef TEST_FLAG_BEHAVIOR_EMPTY_FLAG_CLEAR
    `define TEST_FLAG_BEHAVIOR
`endif

`ifdef TEST_OVERFLOW_UNDERFLOW_SINGLE_OVERFLOW
    `define TEST_OVERFLOW_UNDERFLOW
`endif
`ifdef TEST_OVERFLOW_UNDERFLOW_BACK_TO_BACK_OVERFLOW
    `define TEST_OVERFLOW_UNDERFLOW
`endif
`ifdef TEST_OVERFLOW_UNDERFLOW_SINGLE_UNDERFLOW
    `define TEST_OVERFLOW_UNDERFLOW
`endif
`ifdef TEST_OVERFLOW_UNDERFLOW_BACK_TO_BACK_UNDERFLOW
    `define TEST_OVERFLOW_UNDERFLOW
`endif

`ifdef TEST_RESET_SCENARIOS_RESET_WHEN_EMPTY
    `define TEST_RESET_SCENARIOS
`endif
`ifdef TEST_RESET_SCENARIOS_RESET_WHEN_FULL
    `define TEST_RESET_SCENARIOS
`endif
`ifdef TEST_RESET_SCENARIOS_RESET_PARTIAL_FILL
    `define TEST_RESET_SCENARIOS
`endif
`ifdef TEST_RESET_SCENARIOS_RESET_DURING_WRITE
    `define TEST_RESET_SCENARIOS
`endif
`ifdef TEST_RESET_SCENARIOS_RESET_DURING_READ
    `define TEST_RESET_SCENARIOS
`endif
`ifdef TEST_RESET_SCENARIOS_SIMULTANEOUS_RESET_WRITE
    `define TEST_RESET_SCENARIOS
`endif
`ifdef TEST_RESET_SCENARIOS_SIMULTANEOUS_RESET_READ
    `define TEST_RESET_SCENARIOS
`endif

`ifdef TEST_CLOCK_RATIO_FAST_WRITE_SLOW_READ
    `define TEST_CLOCK_RATIO
`endif
`ifdef TEST_CLOCK_RATIO_SLOW_WRITE_FAST_READ
    `define TEST_CLOCK_RATIO
`endif
`ifdef TEST_CLOCK_RATIO_SAME_FREQUENCY
    `define TEST_CLOCK_RATIO
`endif

// ---- If no test define is set, enable all tests ----

`ifndef TEST_BASIC_RW
`ifndef TEST_FILL_DRAIN_WRAP
`ifndef TEST_BURST_STREAMING
`ifndef TEST_FLAG_BEHAVIOR
`ifndef TEST_DATA_INTEGRITY
`ifndef TEST_OVERFLOW_UNDERFLOW
`ifndef TEST_RESET_SCENARIOS
`ifndef TEST_CLOCK_RATIO
`ifndef TEST_STRESS
    `define TEST_BASIC_RW
    `define TEST_FILL_DRAIN_WRAP
    `define TEST_BURST_STREAMING
    `define TEST_FLAG_BEHAVIOR
    `define TEST_DATA_INTEGRITY
    `define TEST_OVERFLOW_UNDERFLOW
    `define TEST_RESET_SCENARIOS
    `define TEST_CLOCK_RATIO
    `define TEST_STRESS
`endif
`endif
`endif
`endif
`endif
`endif
`endif
`endif
`endif

// ---- Includes ----

`include "fifo_interface.sv"
`include "fifo_transaction.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_scoreboard.sv"
`include "fifo_env.sv"
`include "fifo_test_base.sv"

`ifdef TEST_BASIC_RW
    `include "test_basic_rw.sv"
`endif
`ifdef TEST_FILL_DRAIN_WRAP
    `include "test_fill_drain_wrap.sv"
`endif
`ifdef TEST_BURST_STREAMING
    `include "test_burst_streaming.sv"
`endif
`ifdef TEST_FLAG_BEHAVIOR
    `include "test_flag_behavior.sv"
`endif
`ifdef TEST_DATA_INTEGRITY
    `include "test_data_integrity.sv"
`endif
`ifdef TEST_OVERFLOW_UNDERFLOW
    `include "test_overflow_underflow.sv"
`endif
`ifdef TEST_RESET_SCENARIOS
    `include "test_reset_scenarios.sv"
`endif
`ifdef TEST_CLOCK_RATIO
    `include "test_clock_ratio.sv"
`endif
`ifdef TEST_STRESS
    `include "test_stress.sv"
`endif

module fifo_tb_top;

    // =========================================================================
    //  PARAMETERS
    // =========================================================================
    localparam int FIFO_DEPTH = 8;
    localparam int FIFO_WIDTH = 64;

    // =========================================================================
    //  CLOCKS
    //  wrclk = 100 MHz (10 ns), rdclk ~ 77 MHz (13 ns)
    //  Half-periods are variables so test_clock_ratio can change them at runtime.
    // =========================================================================
    logic wrclk, rdclk;

    realtime wrclk_half = 5.0;    // ns (100 MHz)
    realtime rdclk_half = 6.5;    // ns (~77 MHz)

    initial wrclk = 0;
    always #(wrclk_half) wrclk = ~wrclk;

    initial rdclk = 0;
    always #(rdclk_half) rdclk = ~rdclk;

    // =========================================================================
    //  INTERFACE + DUT
    // =========================================================================
    fifo_if #(FIFO_WIDTH) dut_if (.wrclk(wrclk), .rdclk(rdclk));

    asynchronous_fifo #(
        .FIFO_DEPTH (FIFO_DEPTH),
        .FIFO_WIDTH (FIFO_WIDTH)
    ) dut (
        .wrclk      (dut_if.wrclk),
        .wrst_n     (dut_if.wrst_n),
        .rdclk      (dut_if.rdclk),
        .rrst_n     (dut_if.rrst_n),
        .wr_en      (dut_if.wr_en),
        .rd_en      (dut_if.rd_en),
        .data_in    (dut_if.data_in),
        .data_out   (dut_if.data_out),
        .fifo_full  (dut_if.fifo_full),
        .fifo_empty (dut_if.fifo_empty)
    );

    // =========================================================================
    //  INITIAL RESET
    // =========================================================================
    initial begin
        dut_if.wrst_n  = 0;
        dut_if.rrst_n  = 0;
        dut_if.wr_en   = 0;
        dut_if.rd_en   = 0;
        dut_if.data_in = '0;

        repeat (5) @(posedge wrclk);
        @(posedge wrclk); #1;
        dut_if.wrst_n = 1;
        dut_if.rrst_n = 1;
    end

    // =========================================================================
    //  TEST RUNNER
    // =========================================================================

    string test_names[$];
    string test_results[$];

    fifo_env #(FIFO_WIDTH) env;

    task run_one_test(string name);
        `ifdef TEST_BASIC_RW
            test_basic_rw          #(FIFO_WIDTH, FIFO_DEPTH) t1;
        `endif
        `ifdef TEST_FILL_DRAIN_WRAP
            test_fill_drain_wrap   #(FIFO_WIDTH, FIFO_DEPTH) t2;
        `endif
        `ifdef TEST_BURST_STREAMING
            test_burst_streaming   #(FIFO_WIDTH, FIFO_DEPTH) t3;
        `endif
        `ifdef TEST_FLAG_BEHAVIOR
            test_flag_behavior     #(FIFO_WIDTH, FIFO_DEPTH) t4;
        `endif
        `ifdef TEST_DATA_INTEGRITY
            test_data_integrity    #(FIFO_WIDTH, FIFO_DEPTH) t5;
        `endif
        `ifdef TEST_OVERFLOW_UNDERFLOW
            test_overflow_underflow#(FIFO_WIDTH, FIFO_DEPTH) t6;
        `endif
        `ifdef TEST_RESET_SCENARIOS
            test_reset_scenarios   #(FIFO_WIDTH, FIFO_DEPTH) t7;
        `endif
        `ifdef TEST_CLOCK_RATIO
            test_clock_ratio       #(FIFO_WIDTH, FIFO_DEPTH) t8;
        `endif
        `ifdef TEST_STRESS
            test_stress            #(FIFO_WIDTH, FIFO_DEPTH) t9;
        `endif
        fifo_test_base         #(FIFO_WIDTH, FIFO_DEPTH) test;
        bit found;

        $display("");
        $display("  +----------------------------------------------------------------------+");
        $display("  |  START: %-60s|", name);
        $display("  +----------------------------------------------------------------------+");

        found = 1;
        `ifdef TEST_BASIC_RW
            if (name == "test_basic_rw") begin t1 = new(); t1.init(dut_if, env); test = t1; end else
        `endif
        `ifdef TEST_FILL_DRAIN_WRAP
            if (name == "test_fill_drain_wrap") begin t2 = new(); t2.init(dut_if, env); test = t2; end else
        `endif
        `ifdef TEST_BURST_STREAMING
            if (name == "test_burst_streaming") begin t3 = new(); t3.init(dut_if, env); test = t3; end else
        `endif
        `ifdef TEST_FLAG_BEHAVIOR
            if (name == "test_flag_behavior") begin t4 = new(); t4.init(dut_if, env); test = t4; end else
        `endif
        `ifdef TEST_DATA_INTEGRITY
            if (name == "test_data_integrity") begin t5 = new(); t5.init(dut_if, env); test = t5; end else
        `endif
        `ifdef TEST_OVERFLOW_UNDERFLOW
            if (name == "test_overflow_underflow") begin t6 = new(); t6.init(dut_if, env); test = t6; end else
        `endif
        `ifdef TEST_RESET_SCENARIOS
            if (name == "test_reset_scenarios") begin t7 = new(); t7.init(dut_if, env); test = t7; end else
        `endif
        `ifdef TEST_CLOCK_RATIO
            if (name == "test_clock_ratio") begin t8 = new(); t8.init(dut_if, env); test = t8; end else
        `endif
        `ifdef TEST_STRESS
            if (name == "test_stress") begin t9 = new(); t9.init(dut_if, env); test = t9; end else
        `endif
        found = 0;

        if (!found) begin
            $display("  ERROR: Unknown test '%s'", name);
            test_names.push_back(name);
            test_results.push_back("UNKNOWN");
            return;
        end

        if (test_names.size() > 0)
            test.reset_phase();

        test.run();
        env.scb.report(name);

        test_names.push_back(name);
        if (env.scb.is_pass())
            test_results.push_back("PASS");
        else
            test_results.push_back("FAIL");

        $display("  +----------------------------------------------------------------------+");
        $display("  |  DONE:  %-52s [%4s]  |", name, test_results[test_results.size()-1]);
        $display("  +----------------------------------------------------------------------+");
    endtask

    function void print_summary();
        int num_pass = 0;
        int num_fail = 0;

        $display("");
        $display("");
        $display("  ########################################################################");
        $display("                         FINAL TEST SUMMARY                               ");
        $display("  ########################################################################");
        $display("  %-4s  %-35s  %-6s", "#", "Test Name", "Result");
        $display("  %-4s  %-35s  %-6s", "----", "-----------------------------------", "------");

        for (int i = 0; i < test_names.size(); i++) begin
            $display("  %-4d  %-35s  %-6s", i+1, test_names[i], test_results[i]);
            if (test_results[i] == "PASS") num_pass++;
            else num_fail++;
        end

        $display("  ----------------------------------------------------------------------");
        $display("  Total: %0d tests  |  %0d PASSED  |  %0d FAILED",
                 test_names.size(), num_pass, num_fail);
        $display("  ----------------------------------------------------------------------");
        if (num_fail == 0)
            $display("  OVERALL RESULT  >>  ** ALL TESTS PASSED **");
        else
            $display("  OVERALL RESULT  >>  ** SOME TESTS FAILED **");
        $display("  ########################################################################");
        $display("");
    endfunction

    initial begin
        string selected_tests[$];

        $display("");
        $display("  ########################################################################");
        $display("    ASYNC FIFO - TESTBENCH");
        $display("    WIDTH=%0d  DEPTH=%0d", FIFO_WIDTH, FIFO_DEPTH);
        $display("  ########################################################################");

        `ifdef TEST_BASIC_RW
            selected_tests.push_back("test_basic_rw");
        `endif
        `ifdef TEST_FILL_DRAIN_WRAP
            selected_tests.push_back("test_fill_drain_wrap");
        `endif
        `ifdef TEST_BURST_STREAMING
            selected_tests.push_back("test_burst_streaming");
        `endif
        `ifdef TEST_FLAG_BEHAVIOR
            selected_tests.push_back("test_flag_behavior");
        `endif
        `ifdef TEST_DATA_INTEGRITY
            selected_tests.push_back("test_data_integrity");
        `endif
        `ifdef TEST_OVERFLOW_UNDERFLOW
            selected_tests.push_back("test_overflow_underflow");
        `endif
        `ifdef TEST_RESET_SCENARIOS
            selected_tests.push_back("test_reset_scenarios");
        `endif
        `ifdef TEST_CLOCK_RATIO
            selected_tests.push_back("test_clock_ratio");
        `endif
        `ifdef TEST_STRESS
            selected_tests.push_back("test_stress");
        `endif

        wait (dut_if.wrst_n === 1 && dut_if.rrst_n === 1);
        @(posedge wrclk); #1;

        env = new(dut_if);
        env.run();

        $display("  Running %0d test(s)", selected_tests.size());

        for (int i = 0; i < selected_tests.size(); i++)
            run_one_test(selected_tests[i]);

        print_summary();
        $finish;
    end

    // =========================================================================
    //  WAVEFORM DUMP
    // =========================================================================
    initial begin
        `ifdef DUMP_ON
            $dumpfile("fifo_tb.vcd");
            $dumpvars(0, fifo_tb_top);
        `endif
    end

    `ifdef DUMP_ON
        `ifdef CADENCE
            initial begin
                $shm_open("./fifo_tb.shm");
                $shm_probe("ASM");
            end
        `endif
    `endif

endmodule : fifo_tb_top
