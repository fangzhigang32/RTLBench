`timescale 1ns/1ps

module tb_elevator_controller_4floor;

// Inputs
reg clk;
reg rst;
reg [3:0] floor_req;
reg [1:0] cur_floor;

// Outputs
wire door;
wire [1:0] next_floor;
wire dir;

// Internal flag
reg error_flag;

// Instantiate the Unit Under Test (UUT)
elevator_controller_4floor uut (
    .clk(clk),
    .rst(rst),
    .floor_req(floor_req),
    .cur_floor(cur_floor),
    .door(door),
    .next_floor(next_floor),
    .dir(dir)
);

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
    floor_req = 4'b0000;
    cur_floor = 2'b00;
    
    // Reset the system
    #10;
    rst = 0;

    // Test case 1: Request floor 3 from floor 1
    floor_req = 4'b0100; // Request floor 3
    cur_floor = 2'b00;   // Current floor 1
    #100;
    
    if (next_floor != 2'b10 || door != 1'b1) begin
        $display("Test case 1 failed");
        $display("Expected: next_floor=2'b10, door=1");
        $display("Got: next_floor=%b, door=%b", next_floor, door);
        error_flag = 1;
    end

    // Test case 2: Request floors 2 and 4 from floor 3
    floor_req = 4'b0101; // Request floors 2 and 4
    cur_floor = 2'b10;   // Current floor 3
    #200;
    
    if (next_floor != 2'b11 || door != 1'b1) begin
        $display("Test case 2 failed");
        $display("Expected: next_floor=2'b11 (floor 4), door=1");
        $display("Got: next_floor=%b, door=%b", next_floor, door);
        error_flag = 1;
    end

    // Test case 3: Direction change to floor 1
    floor_req = 4'b0000; // Clear
    #50;
    floor_req = 4'b0001; // Request floor 1
    #200;
    
    if (next_floor != 2'b00 || door != 1'b1) begin
        $display("Test case 3 failed");
        $display("Expected: next_floor=2'b00 (floor 1), door=1");
        $display("Got: next_floor=%b, door=%b", next_floor, door);
        error_flag = 1;
    end

    // Test case 4: Simultaneous requests
    floor_req = 4'b1010; // Request floors 2 and 4
    cur_floor = 2'b00;   // Start at floor 1
    #300;

    // Since we can't check pending requests, we verify next_floor arrives at floor 2 or 4
    if ((next_floor != 2'b01 && next_floor != 2'b11) || door != 1'b1) begin
        $display("Test case 4 failed");
        $display("Expected: next_floor=2'b01 or 2'b11, door=1");
        $display("Got: next_floor=%b, door=%b", next_floor, door);
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
