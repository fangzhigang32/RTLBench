`timescale 1ns/1ps

module tb_bcd_counter_4bit;

    // Inputs
    reg clk;
    reg rst;
    reg en;

    // Outputs
    wire [3:0] q;

    // Instantiate the Unit Under Test (UUT)
    bcd_counter_4bit uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .q(q)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 10ns period, 100MHz clock
    end

    // Test stimulus
    integer error_count = 0;
    integer i; // Declare loop variable outside the for loop
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        en = 0;

        // Reset test: hold reset for two clock cycles
        #20; // Ensure reset is sampled on at least one rising edge
        if (q !== 4'b0000) begin
            $display("Error: Reset test failed at time %t. Input: rst=%b, en=%b | Output: %b | Expected: 4'b0000", 
                    $time, rst, en, q);
            error_count = error_count + 1;
        end

        // Release reset and enable counter
        rst = 0;
        en = 1;

        // Test counting sequence (0 to 9)
        for (i = 0; i <= 9; i = i + 1) begin
            #10; // Wait for next clock edge
            if (q !== i[3:0]) begin
                $display("Error: Count sequence test failed at time %t. Input: rst=%b, en=%b | Output: %b | Expected: %b", 
                        $time, rst, en, q, i[3:0]);
                error_count = error_count + 1;
            end
        end

        // Test rollover from 9 to 0
        #10;
        if (q !== 4'b0000) begin
            $display("Error: Rollover test failed at time %t. Input: rst=%b, en=%b | Output: %b | Expected: 4'b0000", 
                    $time, rst, en, q);
            error_count = error_count + 1;
        end

        // Test enable functionality: count to 5, then disable
        rst = 1;
        #10;
        rst = 0;
        en = 1;
        repeat(5) #10; // Count to 5
        if (q !== 4'b0101) begin
            $display("Error: Pre-enable test failed at time %t. Input: rst=%b, en=%b | Output: %b | Expected: 4'b0101", 
                    $time, rst, en, q);
            error_count = error_count + 1;
        end
        en = 0;
        #20; // Wait two cycles with enable off
        if (q !== 4'b0101) begin
            $display("Error: Enable test failed at time %t. Input: rst=%b, en=%b | Output: %b | Expected: 4'b0101", 
                    $time, rst, en, q);
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

    // Monitor signals
    initial begin
        $monitor("Time = %t, clk = %b, rst = %b, en = %b, q = %b", 
                 $time, clk, rst, en, q);
    end

endmodule