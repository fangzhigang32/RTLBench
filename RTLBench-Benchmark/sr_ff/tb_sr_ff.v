`timescale 1ns/1ps

module tb_sr_ff();

// Inputs
reg clk;
reg rst;
reg s;
reg r;

// Outputs
wire q;

// Instantiate the Unit Under Test (UUT)
sr_ff uut (
    .clk(clk),
    .rst(rst),
    .s(s),
    .r(r),
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
    s = 0;
    r = 0;
    
    // Apply reset
    #10;
    rst = 0;
    
    // Test case 1: Hold state (00)
    s = 0; r = 0;
    #10;
    if (q !== 1'b0) begin
        $display("Error: Case 1 - Input: s=%b, r=%b | Output: %b | Expected: 0", s, r, q);
        error_flag = 1;
    end
    
    // Test case 2: Set (10)
    s = 1; r = 0;
    #10;
    if (q !== 1'b1) begin
        $display("Error: Case 2 - Input: s=%b, r=%b | Output: %b | Expected: 1", s, r, q);
        error_flag = 1;
    end
    
    // Test case 3: Reset (01)
    s = 0; r = 1;
    #10;
    if (q !== 1'b0) begin
        $display("Error: Case 3 - Input: s=%b, r=%b | Output: %b | Expected: 0", s, r, q);
        error_flag = 1;
    end
    
    // Test case 4: Invalid input (11)
    s = 1; r = 1;
    #10;
    if (q !== 1'bx) begin
        $display("Error: Case 4 - Input: s=%b, r=%b | Output: %b | Expected: x", s, r, q);
        error_flag = 1;
    end
    
    // Test case 5: Reset during operation
    s = 1; r = 0;
    #5;
    rst = 1;
    #10;
    if (q !== 1'b0) begin
        $display("Error: Case 5 - Input: s=%b, r=%b, rst=%b | Output: %b | Expected: 0", s, r, rst, q);
        error_flag = 1;
    end
    
    rst = 0;
    #10;
    
    // Final result
    if (error_flag) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    
    $finish;
end

endmodule