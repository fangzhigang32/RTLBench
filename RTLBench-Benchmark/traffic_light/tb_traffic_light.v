`timescale 1ns/1ps

module tb_traffic_light;

// Inputs
reg clk;
reg rst;

// Outputs
wire [2:0] red;
wire [2:0] yellow;
wire [2:0] green;

// Instantiate the Unit Under Test (UUT)
traffic_light uut (
    .clk(clk),
    .rst(rst),
    .red(red),
    .yellow(yellow),
    .green(green)
);

reg error_flag;

// Clock generation
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// Test stimulus
initial begin
    error_flag = 0;
    
    // Initialize Inputs
    rst = 1;
    #20;
    
    // Release reset
    rst = 0;
    
    // Test state transitions
    // Expected sequence: RED -> GREEN -> YELLOW -> RED
    
    // Check RED state
    #20;
    if (!(red[0] && !yellow[0] && !green[0])) begin
        $display("Error at time %0t: Expected RED, got R=%b Y=%b G=%b", $time, red[0], yellow[0], green[0]);
        error_flag = 1;
    end
    
    // Check GREEN state (after 1 clock)
    #20;
    if (!(!red[0] && !yellow[0] && green[0])) begin
        $display("Error at time %0t: Expected GREEN, got R=%b Y=%b G=%b", $time, red[0], yellow[0], green[0]);
        error_flag = 1;
    end
    
    // Check YELLOW state (after 2 clocks)
    #20;
    if (!(!red[0] && yellow[0] && !green[0])) begin
        $display("Error at time %0t: Expected YELLOW, got R=%b Y=%b G=%b", $time, red[0], yellow[0], green[0]);
        error_flag = 1;
    end
    
    // Check return to RED state (after 3 clocks)
    #20;
    if (!(red[0] && !yellow[0] && !green[0])) begin
        $display("Error at time %0t: Expected RED, got R=%b Y=%b G=%b", $time, red[0], yellow[0], green[0]);
        error_flag = 1;
    end
    
    // Test reset functionality
    rst = 1;
    #20;
    if (!(red[0] && !yellow[0] && !green[0])) begin
        $display("Error at time %0t: Reset failed - Expected RED, got R=%b Y=%b G=%b", $time, red[0], yellow[0], green[0]);
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