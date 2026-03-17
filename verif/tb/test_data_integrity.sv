// =============================================================================
// File        : test_data_integrity.sv
// Description : TEST 5 - DATA INTEGRITY PATTERNS
// =============================================================================

`ifndef TEST_DATA_INTEGRITY_SV
`define TEST_DATA_INTEGRITY_SV

class test_data_integrity #(parameter FIFO_WIDTH = 64, parameter FIFO_DEPTH = 8)
    extends fifo_test_base #(FIFO_WIDTH, FIFO_DEPTH);

    function new();
    endfunction

    task run();
        $display("\n  --- Writing 8 specific bit patterns ---");

        write_data(64'h0000_0000_0000_0000);  // All zeros
        write_data(64'hFFFF_FFFF_FFFF_FFFF);  // All ones
        write_data(64'hAAAA_AAAA_AAAA_AAAA);  // Alternating 10101010
        write_data(64'h5555_5555_5555_5555);  // Alternating 01010101
        write_data(64'h0000_0000_0000_0001);  // Walking 1 at LSB
        write_data(64'h8000_0000_0000_0000);  // Walking 1 at MSB
        write_data(64'hFFFF_FFFF_FFFF_FFFE);  // Walking 0 at LSB
        write_data(64'h7FFF_FFFF_FFFF_FFFF);  // Walking 0 at MSB

        $display("  --- Reading back all 8 patterns ---");
        read_n(8);
        wait_drain();
    endtask
endclass : test_data_integrity

`endif
