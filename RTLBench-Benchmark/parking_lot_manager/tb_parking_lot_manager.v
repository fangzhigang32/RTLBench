`timescale 1ns/1ps

module tb_parking_lot_manager;

// Inputs
reg clk;
reg rst;
reg enter;
reg exit;

// Outputs
wire [3:0] count;
wire full;

// Instantiate the Unit Under Test (UUT)
parking_lot_manager uut (
    .clk(clk),
    .rst(rst),
    .enter(enter),
    .exit(exit),
    .count(count),
    .full(full)
);

reg error_flag;

// Clock generation
always begin
    #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    enter = 0;
    exit = 0;
    error_flag = 0;

    // Reset the system
    #10;
    rst = 0;

    // Test case 1: Basic entry operation
    enter = 1;
    #10;
    enter = 0;
    if (count !== 4'd9 || full !== 1'b0) begin
        $display("Error: Test case 1 failed");
        $display("Input: enter=1, exit=0");
        $display("Output: count=%d, full=%b", count, full);
        $display("Expected: count=9, full=0");
        error_flag = 1;
    end

    // Test case 2: Basic exit operation
    exit = 1;
    #10;
    exit = 0;
    if (count !== 4'd10 || full !== 1'b0) begin
        $display("Error: Test case 2 failed");
        $display("Input: enter=0, exit=1");
        $display("Output: count=%d, full=%b", count, full);
        $display("Expected: count=10, full=0");
        error_flag = 1;
    end

    // Test case 3: Fill the parking lot
    repeat(10) begin
        enter = 1;
        #10;
        enter = 0;
        #10;
    end
    if (count !== 4'd0 || full !== 1'b1) begin
        $display("Error: Test case 3 failed");
        $display("Input: 10 enter pulses");
        $display("Output: count=%d, full=%b", count, full);
        $display("Expected: count=0, full=1");
        error_flag = 1;
    end

    // Test case 4: Try to enter when full
    enter = 1;
    #10;
    enter = 0;
    if (count !== 4'd0 || full !== 1'b1) begin
        $display("Error: Test case 4 failed");
        $display("Input: enter=1 (when full), exit=0");
        $display("Output: count=%d, full=%b", count, full);
        $display("Expected: count=0, full=1");
        error_flag = 1;
    end

    // Test case 5: Empty the parking lot
    repeat(10) begin
        exit = 1;
        #10;
        exit = 0;
        #10;
    end
    if (count !== 4'd10 || full !== 1'b0) begin
        $display("Error: Test case 5 failed");
        $display("Input: 10 exit pulses");
        $display("Output: count=%d, full=%b", count, full);
        $display("Expected: count=10, full=0");
        error_flag = 1;
    end

    // Test case 6: Try to exit when empty
    exit = 1;
    #10;
    exit = 0;
    if (count !== 4'd10 || full !== 1'b0) begin
        $display("Error: Test case 6 failed");
        $display("Input: enter=0, exit=1 (when empty)");
        $display("Output: count=%d, full=%b", count, full);
        $display("Expected: count=10, full=0");
        error_flag = 1;
    end

    // Test case 7: Simultaneous enter and exit (should be no change)
    enter = 1;
    exit = 1;
    #10;
    enter = 0;
    exit = 0;
    if (count !== 4'd10 || full !== 1'b0) begin
        $display("Error: Test case 7 failed");
        $display("Input: enter=1, exit=1");
        $display("Output: count=%d, full=%b", count, full);
        $display("Expected: count=10, full=0");
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