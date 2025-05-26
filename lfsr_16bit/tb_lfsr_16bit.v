`timescale 1ns/1ps

module tb_lfsr_16bit;

// Inputs
reg clk;
reg rst;

// Outputs
wire [15:0] q;

// Instantiate the Unit Under Test (UUT)
lfsr_16bit uut (
    .clk(clk),
    .rst(rst),
    .q(q)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Expected values for verification
reg [15:0] expected_q;
reg [15:0] next_expected;
reg test_failed;

// Test stimulus
initial begin
    test_failed = 0;
    
    // Initialize inputs
    rst = 1;
    expected_q = 16'hACE1; // Expected value after reset

    // Apply reset
    #10;
    rst = 0;

    // Verify initial state after reset
    if (q !== expected_q) begin
        $display("Error at time %0t: After reset - q = %h, expected = %h", $time, q, expected_q);
        test_failed = 1;
    end

    // Test sequence
    repeat (32) begin
        #10; // Wait for next clock edge

        // Calculate next expected value
        next_expected = {expected_q[14:0], expected_q[15] ^ expected_q[13] ^ expected_q[12] ^ expected_q[10]};

        // Verify output
        if (q !== next_expected) begin
            $display("Error at time %0t: q = %h, expected = %h", $time, q, next_expected);
            test_failed = 1;
        end

        // Update expected value for next cycle
        expected_q = next_expected;
    end

    // Final result
    if (test_failed) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule