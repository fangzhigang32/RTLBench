`timescale 1ns/1ps

module tb_smoke_detector_controller;

// Inputs
reg clk;
reg rst;
reg smoke;
reg disarm;

// Outputs
wire alarm;
wire warning;

// Instantiate the Unit Under Test (UUT)
smoke_detector_controller uut (
    .clk(clk),
    .rst(rst),
    .smoke(smoke),
    .disarm(disarm),
    .alarm(alarm),
    .warning(warning)
);

reg error_flag;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    error_flag = 0;
    
    // Initialize Inputs
    rst = 1;
    smoke = 0;
    disarm = 0;
    
    // Wait for global reset
    #20;
    rst = 0;
    
    // Test Case 1: Reset check
    if (alarm !== 0 || warning !== 0) begin
        $display("Error: Reset failed. alarm=%b, warning=%b (expected 0,0)", alarm, warning);
        error_flag = 1;
    end
    
    // Test Case 2: Smoke detection - warning after 5 cycles
    smoke = 1;
    repeat(4) @(posedge clk); // 4 cycles
    if (warning !== 0) begin
        $display("Error: Warning triggered too early at cycle 4");
        error_flag = 1;
    end
    @(posedge clk); // 5th cycle
    if (warning !== 1) begin
        $display("Error: Warning not triggered at cycle 5");
        error_flag = 1;
    end
    
    // Test Case 3: Smoke detection - alarm after 10 cycles
    repeat(5) @(posedge clk); // 10 cycles total (5 more after warning)
    if (alarm !== 1) begin
        $display("Error: Alarm not triggered at cycle 10");
        error_flag = 1;
    end
    
    // Test Case 4: Disarm test
    disarm = 1;
    @(posedge clk);
    if (alarm !== 0 || warning !== 0) begin
        $display("Error: Disarm failed. alarm=%b, warning=%b (expected 0,0)", alarm, warning);
        error_flag = 1;
    end
    disarm = 0;
    
    // Test Case 5: Smoke removal resets counters
    smoke = 0;
    @(posedge clk);
    if (alarm !== 0 || warning !== 0) begin
        $display("Error: Smoke removal failed to reset outputs. alarm=%b, warning=%b (expected 0,0)", alarm, warning);
        error_flag = 1;
    end
    
    // Test Case 6: Interrupted smoke detection
    smoke = 1;
    repeat(3) @(posedge clk);
    smoke = 0;
    @(posedge clk);
    if (warning !== 0) begin
        $display("Error: Warning not reset after interrupted smoke");
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