`timescale 1ns/1ps

module tb_pipo_shift_reg_4bit;

// Inputs
reg clk;
reg rst;
reg load;
reg [3:0] d;

// Outputs
wire [3:0] q;

// Instantiate the Unit Under Test (UUT)
pipo_shift_reg_4bit uut (
    .clk(clk),
    .rst(rst),
    .load(load),
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
    
    // Initialize Inputs
    rst = 1;
    load = 0;
    d = 4'b0000;
    
    // Wait for global reset
    #10;
    rst = 0;
    
    // Test case 1: Load data
    load = 1;
    d = 4'b1010;
    #10;
    if (q !== 4'b1010) begin
        $display("Error: Test case 1 failed - Input: load=%b, d=%b | Output: %b | Expected: 4'b1010", load, d, q);
        error_flag = 1;
    end
    
    // Test case 2: Hold data
    load = 0;
    d = 4'b1111;
    #10;
    if (q !== 4'b1010) begin
        $display("Error: Test case 2 failed - Input: load=%b, d=%b | Output: %b | Expected: 4'b1010", load, d, q);
        error_flag = 1;
    end
    
    // Test case 3: Reset
    rst = 1;
    #10;
    if (q !== 4'b0000) begin
        $display("Error: Test case 3 failed - Input: rst=%b | Output: %b | Expected: 4'b0000", rst, q);
        error_flag = 1;
    end
    
    // Test case 4: Load after reset
    rst = 0;
    load = 1;
    d = 4'b1100;
    #10;
    if (q !== 4'b1100) begin
        $display("Error: Test case 4 failed - Input: load=%b, d=%b | Output: %b | Expected: 4'b1100", load, d, q);
        error_flag = 1;
    end
    
    // Test case 5: Change input without load
    load = 0;
    d = 4'b0011;
    #10;
    if (q !== 4'b1100) begin
        $display("Error: Test case 5 failed - Input: load=%b, d=%b | Output: %b | Expected: 4'b1100", load, d, q);
        error_flag = 1;
    end
    
    // Final result
    if (error_flag) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule