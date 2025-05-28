`timescale 1ns/1ps

module tb_crc8;
    reg clk;
    reg rst;
    reg en;
    reg [7:0] d;
    wire [7:0] c;

    // Instantiate the DUT
    crc8 dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d),
        .c(c)
    );

    // Clock generation (10ns period)
    always begin
        #5 clk = ~clk;
    end

    // Test vectors and expected results
    reg [7:0] test_data [0:3];
    reg [7:0] expected_crc [0:3];
    reg [7:0] multi_byte_data [0:2];
    reg [7:0] multi_byte_expected;
    integer i;
    integer error_count = 0;

    initial begin
        // Initialize test vectors
        test_data[0] = 8'h00; expected_crc[0] = 8'h00;
        test_data[1] = 8'hFF; expected_crc[1] = 8'hF7;
        test_data[2] = 8'h55; expected_crc[2] = 8'h8C;
        test_data[3] = 8'hAA; expected_crc[3] = 8'h3E;

        // Multi-byte test data
        multi_byte_data[0] = 8'h01;
        multi_byte_data[1] = 8'h02;
        multi_byte_data[2] = 8'h03;
        multi_byte_expected = 8'hD8;

        // Initialize signals
        clk = 0;
        rst = 1;
        en = 0;
        d = 0;

        // Dump waveform for debugging
        $dumpfile("crc8_tb.vcd");
        $dumpvars(0, tb_crc8);

        // Reset sequence
        #10 rst = 0;
        #10;

        // Check initial CRC value after reset
        if (c !== 8'h00) begin
            $display("Error: CRC not 0x00 after reset, got 0x%h", c);
            error_count = error_count + 1;
        end

        // Enable CRC calculation
        en = 1;

        // Apply single-byte test vectors
        for (i = 0; i < 4; i = i + 1) begin
            d = test_data[i];
            #10;

            if (c !== expected_crc[i]) begin
                $display("Error at test case %0d: Input=0x%h, Output=0x%h, Expected=0x%h",
                         i, d, c, expected_crc[i]);
                error_count = error_count + 1;
            end
        end

        // Reset before multi-byte test
        #10 rst = 1;
        #10 rst = 0;
        #10;
        en = 1;

        // Multi-byte test
        for (i = 0; i < 3; i = i + 1) begin
            d = multi_byte_data[i];
            #10;
        end

        if (c !== multi_byte_expected) begin
            $display("Error in multi-byte test: Output=0x%h, Expected=0x%h", c, multi_byte_expected);
            error_count = error_count + 1;
        end

        // Test enable signal behavior
        en = 0;
        d = 8'hFF;
        #10;
        if (c !== multi_byte_expected) begin
            $display("Error: CRC changed when disabled, got 0x%h", c);
            error_count = error_count + 1;
        end

        // Final result
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end

        // End simulation
        #10 $finish;
    end
endmodule