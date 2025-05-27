`timescale 1ns/1ps

module tb_pipelined_adder_16bit_4stage();

// Inputs
reg clk;
reg rst;
reg signed [15:0] a;
reg signed [15:0] b;

// Outputs
wire signed [15:0] s;

// Instantiate the Unit Under Test (UUT)
pipelined_adder_16bit_4stage uut (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .s(s)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
integer error_count = 0;

initial begin
    // Initialize Inputs
    rst = 1;
    a = 0;
    b = 0;

    // Wait for global reset
    #20;
    rst = 0;

    // Test case 1: Simple addition
    a = 16'sd100;
    b = 16'sd200;
    #60; // Increased wait time to account for 4 pipeline stages
    if (s !== 16'sd300) begin
        $display("Error: Test case 1 failed. Input: a=%d, b=%d, Output: %d, Expected: %d", a, b, s, 16'sd300);
        error_count = error_count + 1;
    end

    // Test case 2: Negative numbers
    a = -16'sd150;
    b = 16'sd100;
    #40;
    if (s !== -16'sd50) begin
        $display("Error: Test case 2 failed. Input: a=%d, b=%d, Output: %d, Expected: %d", a, b, s, -16'sd50);
        error_count = error_count + 1;
    end

    // Test case 3: Max positive + 1
    a = 16'sd32767;
    b = 16'sd1;
    #40;
    if (s !== -16'sd32768) begin
        $display("Error: Test case 3 failed. Input: a=%d, b=%d, Output: %d, Expected: %d", a, b, s, -16'sd32768);
        error_count = error_count + 1;
    end

    // Test case 4: Min negative + -1
    a = -16'sd32768;
    b = -16'sd1;
    #40;
    if (s !== 16'sd32767) begin
        $display("Error: Test case 4 failed. Input: a=%d, b=%d, Output: %d, Expected: %d", a, b, s, 16'sd32767);
        error_count = error_count + 1;
    end

    // Test case 5: Random values
    a = 16'sd12345;
    b = -16'sd6789;
    #40;
    if (s !== (16'sd12345 + -16'sd6789)) begin
        $display("Error: Test case 5 failed. Input: a=%d, b=%d, Output: %d, Expected: %d", a, b, s, (16'sd12345 + -16'sd6789));
        error_count = error_count + 1;
    end

    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end
    else begin
        $display("Exist Function Error");
    end

    #20;
    $finish;
end

endmodule