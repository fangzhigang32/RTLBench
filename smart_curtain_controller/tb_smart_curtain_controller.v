`timescale 1ns/1ps

module tb_smart_curtain_controller;

// Inputs
reg clk;
reg rst;
reg light;
reg manual;

// Outputs
wire open;
wire close;

// Instantiate the Unit Under Test (UUT)
smart_curtain_controller uut (
    .clk(clk),
    .rst(rst),
    .light(light),
    .manual(manual),
    .open(open),
    .close(close)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

reg error_flag = 0;

initial begin
    // Initialize Inputs
    rst = 1;
    light = 0;
    manual = 0;

    // Wait for global reset
    #10;
    rst = 0;

    // Test case 1: Reset test
    if (open !== 1'b0 || close !== 1'b0) begin
        $display("Error: Reset test failed. Input: rst=%b, light=%b, manual=%b. Output: open=%b, close=%b. Expected: open=0, close=0", 
                rst, light, manual, open, close);
        error_flag = 1;
    end

    // Test case 2: Light off condition
    light = 0;
    manual = 0;
    #10;
    if (open !== 1'b1 || close !== 1'b0) begin
        $display("Error: Light off test failed. Input: rst=%b, light=%b, manual=%b. Output: open=%b, close=%b. Expected: open=1, close=0", 
                rst, light, manual, open, close);
        error_flag = 1;
    end

    // Test case 3: Light on condition
    light = 1;
    manual = 0;
    #10;
    if (open !== 1'b0 || close !== 1'b1) begin
        $display("Error: Light on test failed. Input: rst=%b, light=%b, manual=%b. Output: open=%b, close=%b. Expected: open=0, close=1", 
                rst, light, manual, open, close);
        error_flag = 1;
    end

    // Test case 4: Manual override
    light = 1;
    manual = 1;
    #10;
    if (open !== 1'b1 || close !== 1'b0) begin
        $display("Error: Manual override test failed. Input: rst=%b, light=%b, manual=%b. Output: open=%b, close=%b. Expected: open=1, close=0", 
                rst, light, manual, open, close);
        error_flag = 1;
    end

    // Test case 5: Manual override with light off
    light = 0;
    manual = 1;
    #10;
    if (open !== 1'b1 || close !== 1'b0) begin
        $display("Error: Manual with light off test failed. Input: rst=%b, light=%b, manual=%b. Output: open=%b, close=%b. Expected: open=1, close=0", 
                rst, light, manual, open, close);
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