`timescale 1ns/1ps

module tb_pedometer_controller;

// Inputs
reg clk;
reg rst;
reg step;

// Outputs
wire [15:0] count;
wire goal;

// Instantiate the Unit Under Test (UUT)
pedometer_controller uut (
    .clk(clk),
    .rst(rst),
    .step(step),
    .count(count),
    .goal(goal)
);

reg error_flag;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize Inputs
    error_flag = 0;
    rst = 1;
    step = 0;
    
    // Reset the system
    #10;
    rst = 0;
    
    // Test 1: No steps
    #20;
    if (count !== 16'd0 || goal !== 1'b0) begin
        $display("Error: Test 1 failed. Input: step=%b, rst=%b | Output: count=%d, goal=%b | Expected: count=0, goal=0", step, rst, count, goal);
        error_flag = 1;
    end
    
    // Test 2: Single step
    step = 1;
    #10;
    step = 0;
    #10;
    if (count !== 16'd1 || goal !== 1'b0) begin
        $display("Error: Test 2 failed. Input: step=%b, rst=%b | Output: count=%d, goal=%b | Expected: count=1, goal=0", step, rst, count, goal);
        error_flag = 1;
    end
    
    // Test 3: Multiple steps (10)
    repeat (10) begin
        step = 1;
        #10;
        step = 0;
        #10;
    end
    if (count !== 16'd11 || goal !== 1'b0) begin
        $display("Error: Test 3 failed. Input: step=%b, rst=%b | Output: count=%d, goal=%b | Expected: count=11, goal=0", step, rst, count, goal);
        error_flag = 1;
    end
    
    // Test 4: Reach goal (10000 steps)
    repeat (9989) begin
        step = 1;
        #10;
        step = 0;
        #10;
    end
    if (count !== 16'd10000 || goal !== 1'b1) begin
        $display("Error: Test 4 failed. Input: step=%b, rst=%b | Output: count=%d, goal=%b | Expected: count=10000, goal=1", step, rst, count, goal);
        error_flag = 1;
    end
    
    // Test 5: Steps beyond goal
    repeat (5) begin
        step = 1;
        #10;
        step = 0;
        #10;
    end
    if (count !== 16'd10000 || goal !== 1'b1) begin
        $display("Error: Test 5 failed. Input: step=%b, rst=%b | Output: count=%d, goal=%b | Expected: count=10000, goal=1", step, rst, count, goal);
        error_flag = 1;
    end
    
    // Test 6: Reset after reaching goal
    rst = 1;
    #10;
    rst = 0;
    #10;
    if (count !== 16'd0 || goal !== 1'b0) begin
        $display("Error: Test 6 failed. Input: step=%b, rst=%b | Output: count=%d, goal=%b | Expected: count=0, goal=0", step, rst, count, goal);
        error_flag = 1;
    end
    
    if (error_flag) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    
    $finish;
end

endmodule