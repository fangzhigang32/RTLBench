`timescale 1ns/1ps

module tb_fan_controller;

// Inputs
reg clk;
reg rst;
reg [7:0] temp;
reg [7:0] thresh;

// Outputs
wire fan_on;
wire [1:0] speed;

// Instantiate the Unit Under Test (UUT)
fan_controller uut (
    .clk(clk),
    .rst(rst),
    .temp(temp),
    .thresh(thresh),
    .fan_on(fan_on),
    .speed(speed)
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
    rst = 1;
    temp = 0;
    thresh = 0;
    error_flag = 0;
    
    // Reset the system
    #10 rst = 0;
    
    // Test case 1: temp < threshold
    temp = 8'd50;
    thresh = 8'd60;
    #20;
    if (fan_on !== 1'b0 || speed !== 2'b00) begin
        $display("Error case 1: Input temp=%0d, thresh=%0d | Output fan_on=%b, speed=%b | Expected fan_on=0, speed=00", 
                temp, thresh, fan_on, speed);
        error_flag = 1;
    end
    
    // Test case 2: temp > threshold by 5 (low speed)
    temp = 8'd65;
    thresh = 8'd60;
    #20;
    if (fan_on !== 1'b1 || speed !== 2'b00) begin
        $display("Error case 2: Input temp=%0d, thresh=%0d | Output fan_on=%b, speed=%b | Expected fan_on=1, speed=00", 
                temp, thresh, fan_on, speed);
        error_flag = 1;
    end
    
    // Test case 3: temp > threshold by 10 (medium speed)
    temp = 8'd70;
    thresh = 8'd60;
    #20;
    if (fan_on !== 1'b1 || speed !== 2'b01) begin
        $display("Error case 3: Input temp=%0d, thresh=%0d | Output fan_on=%b, speed=%b | Expected fan_on=1, speed=01", 
                temp, thresh, fan_on, speed);
        error_flag = 1;
    end
    
    // Test case 4: temp > threshold by 20 (high speed)
    temp = 8'd80;
    thresh = 8'd60;
    #20;
    if (fan_on !== 1'b1 || speed !== 2'b10) begin
        $display("Error case 4: Input temp=%0d, thresh=%0d | Output fan_on=%b, speed=%b | Expected fan_on=1, speed=10", 
                temp, thresh, fan_on, speed);
        error_flag = 1;
    end
    
    // Test case 5: reset condition
    rst = 1;
    #20;
    if (fan_on !== 1'b0 || speed !== 2'b00) begin
        $display("Error case 5: Input rst=%b | Output fan_on=%b, speed=%b | Expected fan_on=0, speed=00", 
                rst, fan_on, speed);
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