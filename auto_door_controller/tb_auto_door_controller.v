`timescale 1ns/1ps

module tb_auto_door_controller;

// Inputs
reg clk;
reg rst;
reg sensor;

// Outputs
wire open;
wire close;

// Instantiate the Unit Under Test (UUT)
auto_door_controller uut (
    .clk(clk),
    .rst(rst),
    .sensor(sensor),
    .open(open),
    .close(close)
);

// Clock generation: 10ns period (100MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus and checking
integer error_count = 0;

initial begin
    // Initialize Inputs
    rst = 1;
    sensor = 0;
    
    // Reset the system
    #20;
    rst = 0;
    
    // Test case 1: IDLE state with no sensor
    #10;
    if (open !== 1'b0 || close !== 1'b1) begin
        $display("Error: Test case 1 failed - Input: sensor=%b, Output: open=%b, close=%b, Expected: open=0, close=1", 
                sensor, open, close);
        error_count = error_count + 1;
    end
    
    // Test case 2: Trigger sensor to OPENING state
    sensor = 1;
    #10;
    if (open !== 1'b1 || close !== 1'b0) begin
        $display("Error: Test case 2 failed - Input: sensor=%b, Output: open=%b, close=%b, Expected: open=1, close=0", 
                sensor, open, close);
        error_count = error_count + 1;
    end
    
    // Test case 3: Move to HOLD state and wait for 5 seconds
    repeat(500) @(posedge clk);
    if (open !== 1'b1 || close !== 1'b0) begin
        $display("Error: Test case 3 failed - Input: sensor=%b, Output: open=%b, close=%b, Expected: open=1, close=0 during HOLD", 
                sensor, open, close);
        error_count = error_count + 1;
    end
    
    // Test case 4: Transition to CLOSING state after timer
    @(posedge clk);
    if (open !== 1'b0 || close !== 1'b1) begin
        $display("Error: Test case 4 failed - Input: sensor=%b, Output: open=%b, close=%b, Expected: open=0, close=1", 
                sensor, open, close);
        error_count = error_count + 1;
    end
    
    // Test case 5: Sensor reactivation during CLOSING
    sensor = 1;
    @(posedge clk);
    if (open !== 1'b1 || close !== 1'b0) begin
        $display("Error: Test case 5 failed - Input: sensor=%b, Output: open=%b, close=%b, Expected: open=1, close=0", 
                sensor, open, close);
        error_count = error_count + 1;
    end
    
    // Test case 6: Return to IDLE
    sensor = 0;
    repeat(10) @(posedge clk);
    if (open !== 1'b0 || close !== 1'b1) begin
        $display("Error: Test case 6 failed - Input: sensor=%b, Output: open=%b, close=%b, Expected: open=0, close=1", 
                sensor, open, close);
        error_count = error_count + 1;
    end
    
    // Test case 7: Reset during OPENING state
    sensor = 1;
    #10;
    rst = 1;
    #10;
    rst = 0;
    @(posedge clk);
    if (open !== 1'b0 || close !== 1'b1) begin
        $display("Error: Test case 7 failed - Input: sensor=%b, rst=%b, Output: open=%b, close=%b, Expected: open=0, close=1 after reset", 
                sensor, rst, open, close);
        error_count = error_count + 1;
    end
    
    // Test case 8: Short sensor pulse
    sensor = 1;
    #5;
    sensor = 0;
    #10;
    if (open !== 1'b1 || close !== 1'b0) begin
        $display("Error: Test case 8 failed - Input: sensor pulse, Output: open=%b, close=%b, Expected: open=1, close=0 for short pulse", 
                open, close);
        error_count = error_count + 1;
    end
    
    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end
    $finish;
end

endmodule