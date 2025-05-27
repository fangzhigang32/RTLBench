`timescale 1ns/1ps

module tb_assembly_line_controller;

// Inputs
reg clk;
reg rst;
reg sensor;
reg start;

// Outputs
wire motor;
wire belt;
wire stop;

// Instantiate the Unit Under Test (UUT)
assembly_line_controller uut (
    .clk(clk),
    .rst(rst),
    .sensor(sensor),
    .start(start),
    .motor(motor),
    .belt(belt),
    .stop(stop)
);

reg error_flag;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period
end

// Test stimulus
initial begin
    error_flag = 0;
    
    // Initialize Inputs
    rst = 1;
    sensor = 0;
    start = 0;
    
    // Test case 0: Reset the system
    #10 rst = 0;
    #10; // Wait one cycle for outputs to stabilize
    if (motor !== 0 || belt !== 0 || stop !== 0) begin
        $display("Error: Test case 0 failed (Reset). Inputs: rst=%b, sensor=%b, start=%b. Output: motor=%b, belt=%b, stop=%b. Expected: motor=0, belt=0, stop=0", 
                rst, sensor, start, motor, belt, stop);
        error_flag = 1;
    end
    
    // Test case 1: IDLE state with no sensor or start
    #10;
    if (motor !== 0 || belt !== 0 || stop !== 0) begin
        $display("Error: Test case 1 failed (IDLE). Inputs: rst=%b, sensor=%b, start=%b. Output: motor=%b, belt=%b, stop=%b. Expected: motor=0, belt=0, stop=0", 
                rst, sensor, start, motor, belt, stop);
        error_flag = 1;
    end
    
    // Test case 2: Sensor active but no start (abnormal condition)
    #10 sensor = 1;
    #10;
    if (motor !== 0 || belt !== 0 || stop !== 1) begin
        $display("Error: Test case 2 failed (Sensor only). Inputs: rst=%b, sensor=%b, start=%b. Output: motor=%b, belt=%b, stop=%b. Expected: motor=0, belt=0, stop=1", 
                rst, sensor, start, motor, belt, stop);
        error_flag = 1;
    end
    
    // Test case 3: Start assembly line (RUN state)
    #10 start = 1;
    #10;
    if (motor !== 1 || belt !== 1 || stop !== 0) begin
        $display("Error: Test case 3 failed (RUN). Inputs: rst=%b, sensor=%b, start=%b. Output: motor=%b, belt=%b, stop=%b. Expected: motor=1, belt=1, stop=0", 
                rst, sensor, start, motor, belt, stop);
        error_flag = 1;
    end
    
    // Test case 4: Sensor lost while running
    #10 sensor = 0;
    #10;
    if (motor !== 0 || belt !== 0 || stop !== 0) begin
        $display("Error: Test case 4 failed (Sensor lost). Inputs: rst=%b, sensor=%b, start=%b. Output: motor=%b, belt=%b, stop=%b. Expected: motor=0, belt=0, stop=0", 
                rst, sensor, start, motor, belt, stop);
        error_flag = 1;
    end
    
    // Test case 5: Restart after sensor returns
    #10 sensor = 1;
    #10;
    if (motor !== 1 || belt !== 1 || stop !== 0) begin
        $display("Error: Test case 5 failed (Sensor restart). Inputs: rst=%b, sensor=%b, start=%b. Output: motor=%b, belt=%b, stop=%b. Expected: motor=1, belt=1, stop=0", 
                rst, sensor, start, motor, belt, stop);
        error_flag = 1;
    end
    
    // Test case 6: Start signal lost while running
    #10 start = 0;
    #10;
    if (motor !== 0 || belt !== 0 || stop !== 1) begin
        $display("Error: Test case 6 failed (Start lost). Inputs: rst=%b, sensor=%b, start=%b. Output: motor=%b, belt=%b, stop=%b. Expected: motor=0, belt=0, stop=1", 
                rst, sensor, start, motor, belt, stop);
        error_flag = 1;
    end
    
    // Test case 7: Async reset during RUN state
    #10 sensor = 1; start = 1; // Return to RUN state
    #7 rst = 1; // Async reset in middle of clock cycle
    #3 rst = 0; // Release reset after 3ns
    #10; // Wait one cycle
    if (motor !== 0 || belt !== 0 || stop !== 0) begin
        $display("Error: Test case 7 failed (Async reset). Inputs: rst=%b, sensor=%b, start=%b. Output: motor=%b, belt=%b, stop=%b. Expected: motor=0, belt=0, stop=0", 
                rst, sensor, start, motor, belt, stop);
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