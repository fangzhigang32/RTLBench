`timescale 1ns/1ps

module tb_security_alarm;

// Inputs
reg clk;
reg rst;
reg sensor;
reg disarm;

// Outputs
wire alarm;

// Instantiate the Unit Under Test (UUT)
security_alarm uut (
    .clk(clk),
    .rst(rst),
    .sensor(sensor),
    .disarm(disarm),
    .alarm(alarm)
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
    sensor = 0;
    disarm = 0;
    
    // Reset the system
    #10;
    rst = 0;
    
    // Test Case 1: Sensor triggered without disarm
    #10;
    sensor = 1;
    #10;
    if (alarm !== 1'b1) begin
        $display("Error: Test Case 1 failed");
        $display("Inputs: sensor=%b, disarm=%b", sensor, disarm);
        $display("Output: alarm=%b", alarm);
        $display("Expected: alarm=1");
        error_flag = 1;
    end
    
    // Test Case 2: Disarm while alarm is active
    #10;
    disarm = 1;
    #10;
    if (alarm !== 1'b0) begin
        $display("Error: Test Case 2 failed");
        $display("Inputs: sensor=%b, disarm=%b", sensor, disarm);
        $display("Output: alarm=%b", alarm);
        $display("Expected: alarm=0");
        error_flag = 1;
    end
    
    // Test Case 3: Sensor triggered but disarmed
    #10;
    disarm = 0;
    sensor = 0;
    #10;
    sensor = 1;
    disarm = 1;
    #10;
    if (alarm !== 1'b0) begin
        $display("Error: Test Case 3 failed");
        $display("Inputs: sensor=%b, disarm=%b", sensor, disarm);
        $display("Output: alarm=%b", alarm);
        $display("Expected: alarm=0");
        error_flag = 1;
    end
    
    // Test Case 4: Reset functionality
    #10;
    rst = 1;
    #10;
    if (alarm !== 1'b0) begin
        $display("Error: Test Case 4 failed");
        $display("Inputs: rst=%b, sensor=%b, disarm=%b", rst, sensor, disarm);
        $display("Output: alarm=%b", alarm);
        $display("Expected: alarm=0");
        error_flag = 1;
    end
    
    // Final status output
    if (error_flag) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    
    // End simulation
    #10;
    $finish;
end

endmodule