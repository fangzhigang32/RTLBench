`timescale 1ns/1ps

module tb_digital_clock_controller;

// Inputs
reg clk;
reg rst;
reg set;
reg [1:0] adj;

// Outputs
wire [7:0] hour;
wire [7:0] minute;

// Instantiate the Unit Under Test (UUT)
digital_clock_controller uut (
    .clk(clk),
    .rst(rst),
    .set(set),
    .adj(adj),
    .hour(hour),
    .minute(minute)
);

// Clock generation (10ns period, 100MHz, assuming 1 cycle = 1 second for simplicity)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test status tracking
integer test_passed = 0;
integer test_failed = 0;

// Function to check if a value is valid BCD
function is_valid_bcd;
    input [7:0] value;
    begin
        is_valid_bcd = (value[3:0] <= 4'h9) && (value[7:4] <= 4'h9);
    end
endfunction

// Task to check time validity (hour <= 23, minute <= 59, BCD format)
task check_time_validity;
    input [7:0] hour_val;
    input [7:0] minute_val;
    begin
        if (!is_valid_bcd(hour_val) || !is_valid_bcd(minute_val)) begin
            $display("Error: Invalid BCD format at time %t. Hour=%h, Minute=%h", $time, hour_val, minute_val);
            test_failed = test_failed + 1;
        end
        else if (hour_val > 8'h23 || minute_val > 8'h59) begin
            $display("Error: Invalid time at time %t. Hour=%h, Minute=%h", $time, hour_val, minute_val);
            test_failed = test_failed + 1;
        end
    end
endtask

// Continuous monitoring of time validity
always @(posedge clk) begin
    check_time_validity(hour, minute);
end

// Test stimulus
initial begin
    // Initialize Inputs
    rst = 1;
    set = 0;
    adj = 2'b00;
    
    // Reset test
    #10;
    rst = 0;
    @(posedge clk); // Wait for one clock cycle after reset
    if (hour !== 8'h00 || minute !== 8'h00) begin
        $display("Error: Reset failed. Got hour=%h, minute=%h, expected hour=00, minute=00", hour, minute);
        test_failed = test_failed + 1;
    end
    else begin
        test_passed = test_passed + 1;
    end
    
    // Test normal counting for 1 minute (assuming 1 cycle = 1 second)
    repeat(60) @(posedge clk);
    if (hour !== 8'h00 || minute !== 8'h01) begin
        $display("Error: Normal counting failed after 1 minute. Got hour=%h, minute=%h, expected hour=00, minute=01", hour, minute);
        test_failed = test_failed + 1;
    end
    else begin
        test_passed = test_passed + 1;
    end
    
    // Test minute adjustment
    set = 1;
    adj = 2'b01; // Increment minutes
    repeat(5) @(posedge clk);
    set = 0;
    adj = 2'b00;
    @(posedge clk); // Wait for output to stabilize
    if (minute !== 8'h06) begin
        $display("Error: Minute adjustment failed. Got minute=%h, expected minute=06", minute);
        test_failed = test_failed + 1;
    end
    else begin
        test_passed = test_passed + 1;
    end
    
    // Test hour adjustment
    set = 1;
    adj = 2'b10; // Increment hours
    repeat(3) @(posedge clk);
    set = 0;
    adj = 2'b00;
    @(posedge clk); // Wait for output to stabilize
    if (hour !== 8'h03) begin
        $display("Error: Hour adjustment failed. Got hour=%h, expected hour=03", hour);
        test_failed = test_failed + 1;
    end
    else begin
        test_passed = test_passed + 1;
    end
    
    // Test reserved adjustment (adj=11)
    set = 1;
    adj = 2'b11; // Reserved, no operation expected
    @(posedge clk);
    if (hour !== 8'h03 || minute !== 8'h06) begin
        $display("Error: Reserved adjustment (adj=11) modified time. Got hour=%h, minute=%h, expected hour=03, minute=06", hour, minute);
        test_failed = test_failed + 1;
    end
    else begin
        test_passed = test_passed + 1;
    end
    set = 0;
    adj = 2'b00;
    
    // Test minute adjustment rollover (59 to 00)
    rst = 1;
    #10;
    rst = 0;
    set = 1;
    adj = 2'b01; // Set minutes to 59
    repeat(59) @(posedge clk);
    set = 0;
    @(posedge clk); // Advance one more minute
    if (minute !== 8'h00 || hour !== 8'h00) begin
        $display("Error: Minute adjustment rollover failed. Got hour=%h, minute=%h, expected hour=00, minute=00", hour, minute);
        test_failed = test_failed + 1;
    end
    else begin
        test_passed = test_passed + 1;
    end
    
    // Test hour adjustment rollover (23 to 00)
    set = 1;
    adj = 2'b10; // Set hours to 23
    repeat(23) @(posedge clk);
    set = 0;
    @(posedge clk); // Advance one more hour
    if (hour !== 8'h00 || minute !== 8'h00) begin
        $display("Error: Hour adjustment rollover failed. Got hour=%h, minute=%h, expected hour=00, minute=00", hour, minute);
        test_failed = test_failed + 1;
    end
    else begin
        test_passed = test_passed + 1;
    end
    
    // Test rollover from 23:59 to 00:00
    rst = 1;
    #10;
    rst = 0;
    set = 1;
    adj = 2'b10; // Set hours to 23
    repeat(23) @(posedge clk);
    adj = 2'b01; // Set minutes to 59
    repeat(59) @(posedge clk);
    set = 0;
    adj = 2'b00;
    @(posedge clk); // Advance one minute
    if (hour !== 8'h00 || minute !== 8'h00) begin
        $display("Error: 23:59 to 00:00 rollover failed. Got hour=%h, minute=%h, expected hour=00, minute=00", hour, minute);
        test_failed = test_failed + 1;
    end
    else begin
        test_passed = test_passed + 1;
    end
    
    // Final result
    if (test_failed == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end
    $finish;
end

endmodule