`timescale 1ns/1ps

module tb_dec_to_bcd;
    reg [3:0] d;
    wire [3:0] y;
    reg [3:0] expected;
    integer i;
    integer error_count;

    // Instantiate the DUT
    dec_to_bcd dut (
        .d(d),
        .y(y)
    );

    initial begin
        // Initialize inputs
        d = 4'b0000;
        error_count = 0;

        // Test all valid inputs (0-9)
        for (i = 0; i <= 9; i = i + 1) begin
            d = i;
            expected = i;
            #10; // Wait for propagation delay
            if (y !== expected) begin
                $display("Error: d=%0d, y=%b (Expected: %b)", d, y, expected);
                error_count = error_count + 1;
            end
        end

        // Test invalid inputs (10-15), log output without checking
        for (i = 10; i <= 15; i = i + 1) begin
            d = i;
            #10; // Wait for propagation delay
        end

        // Summary of test results
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end

    // Monitor output stability (optional, for timing verification)
    initial begin
        forever begin
            @(y); // Trigger on any change in y
            #1; // Small delay to check stability
            if (y !== dut.y) begin
                $display("Time %0t: Warning: Output y is unstable!", $time);
            end
        end
    end
endmodule