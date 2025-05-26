`timescale 1ns/1ps

module tb_reset_1bit;

// Inputs
reg clk;
reg rst;
reg d;

// Output
wire q;

// Instantiate the Unit Under Test (UUT)
reset_1bit uut (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
);

reg error_flag;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus and checking
initial begin
    error_flag = 0;
    
    // Initialize inputs
    rst = 1;
    d = 0;
    
    // Test 1: Asynchronous reset
    #10;
    if (q !== 1'b0) begin
        $display("Error: Test 1 failed. Input: rst=%b, d=%b | Output: q=%b | Expected: 0", rst, d, q);
        error_flag = 1;
    end
    
    // Test 2: Release reset and check data path
    rst = 0;
    d = 1;
    #10;
    if (q !== 1'b1) begin
        $display("Error: Test 2 failed. Input: rst=%b, d=%b | Output: q=%b | Expected: 1", rst, d, q);
        error_flag = 1;
    end
    
    // Test 3: Assert reset during operation
    d = 0;
    #5;
    rst = 1;
    #5;
    if (q !== 1'b0) begin
        $display("Error: Test 3 failed. Input: rst=%b, d=%b | Output: q=%b | Expected: 0", rst, d, q);
        error_flag = 1;
    end
    
    // Test 4: Normal operation after reset release
    rst = 0;
    d = 1;
    #10;
    if (q !== 1'b1) begin
        $display("Error: Test 4 failed. Input: rst=%b, d=%b | Output: q=%b | Expected: 1", rst, d, q);
        error_flag = 1;
    end
    
    // Final result
    if (error_flag) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule