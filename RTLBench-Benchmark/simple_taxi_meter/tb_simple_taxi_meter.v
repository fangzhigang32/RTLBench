`timescale 1ns/1ps

module tb_simple_taxi_meter;

// Inputs
reg clk;
reg rst;
reg start;
reg stop;
reg dist_pulse;

// Outputs
wire [15:0] fare;
wire running;

// Instantiate the Unit Under Test (UUT)
simple_taxi_meter uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .stop(stop),
    .dist_pulse(dist_pulse),
    .fare(fare),
    .running(running)
);

reg test_failed;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test procedure
initial begin
    // Initialize Inputs
    rst = 1;
    start = 0;
    stop = 0;
    dist_pulse = 0;
    test_failed = 0;
    
    // Reset the system
    #10 rst = 0;
    
    // Test case 1: Start the meter
    #10 start = 1;
    #10 start = 0;
    
    // Check initial fare and running state
    if (fare !== 16'd500 || running !== 1'b1) begin
        $display("Error: Test case 1 failed");
        $display("Input: start=1");
        $display("Output: fare=%d, running=%b", fare, running);
        $display("Expected: fare=500, running=1");
        test_failed = 1;
    end
    
    // Test case 2: Distance pulses (first 2 pulses shouldn't increase fare)
    #10 dist_pulse = 1;
    #10 dist_pulse = 0;
    #10 dist_pulse = 1;
    #10 dist_pulse = 0;
    
    if (fare !== 16'd500) begin
        $display("Error: Test case 2 failed");
        $display("Input: dist_pulse=1 (2 pulses)");
        $display("Output: fare=%d", fare);
        $display("Expected: fare=500");
        test_failed = 1;
    end
    
    // Test case 3: Distance pulses beyond initial 2 should increase fare
    #10 dist_pulse = 1;
    #10 dist_pulse = 0;
    #10 dist_pulse = 1;
    #10 dist_pulse = 0;
    
    if (fare !== 16'd700) begin
        $display("Error: Test case 3 failed");
        $display("Input: dist_pulse=1 (2 more pulses)");
        $display("Output: fare=%d", fare);
        $display("Expected: fare=700");
        test_failed = 1;
    end
    
    // Test case 4: Stop the meter
    #10 stop = 1;
    #10 stop = 0;
    
    if (running !== 1'b0) begin
        $display("Error: Test case 4 failed");
        $display("Input: stop=1");
        $display("Output: running=%b", running);
        $display("Expected: running=0");
        test_failed = 1;
    end
    
    // Test case 5: Distance pulses after stop shouldn't affect fare
    #10 dist_pulse = 1;
    #10 dist_pulse = 0;
    
    if (fare !== 16'd700) begin
        $display("Error: Test case 5 failed");
        $display("Input: dist_pulse=1 after stop");
        $display("Output: fare=%d", fare);
        $display("Expected: fare=700");
        test_failed = 1;
    end
    
    // Test case 6: Reset test
    #10 rst = 1;
    #10 rst = 0;
    
    if (fare !== 16'd0 || running !== 1'b0) begin
        $display("Error: Test case 6 failed");
        $display("Input: rst=1");
        $display("Output: fare=%d, running=%b", fare, running);
        $display("Expected: fare=0, running=0");
        test_failed = 1;
    end
    
    // Final result
    if (test_failed) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule