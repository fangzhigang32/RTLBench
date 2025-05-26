`timescale 1ns/1ps

module tb_piso_shift_reg_4bit;

// Inputs
reg clk;
reg rst;
reg load;
reg [3:0] d;

// Outputs
wire so;

// Instantiate the Unit Under Test (UUT)
piso_shift_reg_4bit uut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .d(d),
    .so(so)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus and checking
reg test_failed;
initial begin
    test_failed = 0;
    
    // Initialize Inputs
    rst = 1;
    load = 0;
    d = 4'b0000;
    
    // Apply reset
    #10;
    rst = 0;
    
    // Test case 1: Load data and shift out
    d = 4'b1101;
    load = 1;
    #10;
    load = 0;
    
    // Expected output sequence: 1, 0, 1, 1 (LSB first)
    #10;
    if (so !== 1'b1) begin
        $display("Error at time %0t: Test case 1 failed", $time);
        $display("Input: d=%4b, load=%b, rst=%b", d, load, rst);
        $display("Output: so=%b", so);
        $display("Expected: so=1");
        test_failed = 1;
    end
    
    #10;
    if (so !== 1'b0) begin
        $display("Error at time %0t: Test case 1 failed", $time);
        $display("Input: d=%4b, load=%b, rst=%b", d, load, rst);
        $display("Output: so=%b", so);
        $display("Expected: so=0");
        test_failed = 1;
    end
    
    #10;
    if (so !== 1'b1) begin
        $display("Error at time %0t: Test case 1 failed", $time);
        $display("Input: d=%4b, load=%b, rst=%b", d, load, rst);
        $display("Output: so=%b", so);
        $display("Expected: so=1");
        test_failed = 1;
    end
    
    #10;
    if (so !== 1'b1) begin
        $display("Error at time %0t: Test case 1 failed", $time);
        $display("Input: d=%4b, load=%b, rst=%b", d, load, rst);
        $display("Output: so=%b", so);
        $display("Expected: so=1");
        test_failed = 1;
    end
    
    // Test case 2: Reset test
    rst = 1;
    #10;
    if (so !== 1'b0) begin
        $display("Error at time %0t: Test case 2 failed", $time);
        $display("Input: d=%4b, load=%b, rst=%b", d, load, rst);
        $display("Output: so=%b", so);
        $display("Expected: so=0");
        test_failed = 1;
    end
    
    rst = 0;
    
    // Test case 3: Load new data and shift out
    d = 4'b0110;
    load = 1;
    #10;
    load = 0;
    
    // Expected output sequence: 0, 1, 1, 0 (LSB first)
    #10;
    if (so !== 1'b0) begin
        $display("Error at time %0t: Test case 3 failed", $time);
        $display("Input: d=%4b, load=%b, rst=%b", d, load, rst);
        $display("Output: so=%b", so);
        $display("Expected: so=0");
        test_failed = 1;
    end
    
    #10;
    if (so !== 1'b1) begin
        $display("Error at time %0t: Test case 3 failed", $time);
        $display("Input: d=%4b, load=%b, rst=%b", d, load, rst);
        $display("Output: so=%b", so);
        $display("Expected: so=1");
        test_failed = 1;
    end
    
    #10;
    if (so !== 1'b1) begin
        $display("Error at time %0t: Test case 3 failed", $time);
        $display("Input: d=%4b, load=%b, rst=%b", d, load, rst);
        $display("Output: so=%b", so);
        $display("Expected: so=1");
        test_failed = 1;
    end
    
    #10;
    if (so !== 1'b0) begin
        $display("Error at time %0t: Test case 3 failed", $time);
        $display("Input: d=%4b, load=%b, rst=%b", d, load, rst);
        $display("Output: so=%b", so);
        $display("Expected: so=0");
        test_failed = 1;
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