`timescale 1ns/1ps

module tb_jk_ff();

// Inputs
reg clk;
reg rst;
reg j;
reg k;

// Output
wire q;

// Instantiate the Unit Under Test (UUT)
jk_ff uut (
    .clk(clk),
    .rst(rst),
    .j(j),
    .k(k),
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
    j = 0;
    k = 0;
    
    // Test 1: Reset test
    #10;
    if (q !== 1'b0) begin
        $display("Error: Reset test failed. Input: rst=%b, j=%b, k=%b | Output: %b | Expected: 1'b0", rst, j, k, q);
        error_flag = 1;
    end
    
    // Release reset
    rst = 0;
    #10;
    
    // Test 2: No change (J=0, K=0)
    j = 0; k = 0;
    #10;
    if (q !== 1'b0) begin
        $display("Error: No change test failed. Input: rst=%b, j=%b, k=%b | Output: %b | Expected: 1'b0", rst, j, k, q);
        error_flag = 1;
    end
    
    // Test 3: Set (J=1, K=0)
    j = 1; k = 0;
    #10;
    if (q !== 1'b1) begin
        $display("Error: Set test failed. Input: rst=%b, j=%b, k=%b | Output: %b | Expected: 1'b1", rst, j, k, q);
        error_flag = 1;
    end
    
    // Test 4: Reset (J=0, K=1)
    j = 0; k = 1;
    #10;
    if (q !== 1'b0) begin
        $display("Error: Reset test failed. Input: rst=%b, j=%b, k=%b | Output: %b | Expected: 1'b0", rst, j, k, q);
        error_flag = 1;
    end
    
    // Test 5: Toggle (J=1, K=1)
    j = 1; k = 1;
    #10;
    if (q !== 1'b1) begin
        $display("Error: Toggle test 1 failed. Input: rst=%b, j=%b, k=%b | Output: %b | Expected: 1'b1", rst, j, k, q);
        error_flag = 1;
    end
    
    #10;
    if (q !== 1'b0) begin
        $display("Error: Toggle test 2 failed. Input: rst=%b, j=%b, k=%b | Output: %b | Expected: 1'b0", rst, j, k, q);
        error_flag = 1;
    end
    
    // Test 6: Reset during operation
    j = 1; k = 0;
    #5;
    rst = 1;
    #10;
    if (q !== 1'b0) begin
        $display("Error: Async reset test failed. Input: rst=%b, j=%b, k=%b | Output: %b | Expected: 1'b0", rst, j, k, q);
        error_flag = 1;
    end
    
    if (error_flag) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule