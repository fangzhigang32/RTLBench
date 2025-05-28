`timescale 1ns/1ps

module tb_phone_billing;

// Inputs
reg clk;
reg rst;
reg start;
reg stop;

// Outputs
wire [15:0] cost;
wire active;

// Instantiate the Unit Under Test (UUT)
phone_billing uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .stop(stop),
    .cost(cost),
    .active(active)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize Inputs
    rst = 1;
    start = 0;
    stop = 0;
    
    // Wait 10 ns for global reset
    #10;
    rst = 0;
    
    // Test case 1: Reset check
    if (cost !== 16'd0 || active !== 1'b0) begin
        $display("Error: Reset failed. cost=%d, active=%b (expected: 0, 0)", cost, active);
        $display("Exist Function Error");
        $finish;
    end
    
    // Test case 2: Start a call
    start = 1;
    #10;
    start = 0;
    
    if (cost !== 16'd30 || active !== 1'b1) begin
        $display("Error: Call start failed. cost=%d, active=%b (expected: 30, 1)", cost, active);
        $display("Exist Function Error");
        $finish;
    end
    
    // Test case 3: Let call run for 1 minute
    repeat(60) @(posedge clk);
    
    if (cost !== 16'd60 || active !== 1'b1) begin
        $display("Error: 1 minute charge failed. cost=%d, active=%b (expected: 60, 1)", cost, active);
        $display("Exist Function Error");
        $finish;
    end
    
    // Test case 4: Stop the call
    stop = 1;
    #10;
    stop = 0;
    
    if (cost !== 16'd60 || active !== 1'b0) begin
        $display("Error: Call stop failed. cost=%d, active=%b (expected: 60, 0)", cost, active);
        $display("Exist Function Error");
        $finish;
    end
    
    // Test case 5: Start another call
    start = 1;
    #10;
    start = 0;
    
    if (cost !== 16'd30 || active !== 1'b1) begin
        $display("Error: Second call start failed. cost=%d, active=%b (expected: 30, 1)", cost, active);
        $display("Exist Function Error");
        $finish;
    end
    
    // Test case 6: Reset during call
    rst = 1;
    #10;
    rst = 0;
    
    if (cost !== 16'd0 || active !== 1'b0) begin
        $display("Error: Reset during call failed. cost=%d, active=%b (expected: 0, 0)", cost, active);
        $display("Exist Function Error");
        $finish;
    end
    
    $display("No Function Error");
    $finish;
end

endmodule