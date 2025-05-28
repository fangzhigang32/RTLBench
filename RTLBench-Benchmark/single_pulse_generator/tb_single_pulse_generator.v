`timescale 1ns/1ps

module tb_single_pulse_generator;
    // Inputs
    reg clk;
    reg rst;
    reg trigger;
    
    // Output
    wire pulse;
    
    // Instantiate the Unit Under Test (UUT)
    single_pulse_generator uut (
        .clk(clk),
        .rst(rst),
        .trigger(trigger),
        .pulse(pulse)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test procedure
    reg test_failed = 0;
    
    initial begin
        // Initialize Inputs
        rst = 1;
        trigger = 0;
        
        // Reset the system
        #20;
        rst = 0;
        
        // Test case 1: Single trigger
        trigger = 1;
        #10;
        if (pulse !== 1'b1) begin
            $display("Error: Test case 1 failed - Input: trigger=%b, Output: pulse=%b, Expected: pulse=1", trigger, pulse);
            test_failed = 1;
        end
        #10;
        trigger = 0;
        #20;
        if (pulse !== 1'b0) begin
            $display("Error: Test case 1 failed - Input: trigger=%b, Output: pulse=%b, Expected: pulse=0", trigger, pulse);
            test_failed = 1;
        end
        
        // Test case 2: Continuous trigger
        trigger = 1;
        #10;
        if (pulse !== 1'b1) begin
            $display("Error: Test case 2 failed - Input: trigger=%b, Output: pulse=%b, Expected: pulse=1", trigger, pulse);
            test_failed = 1;
        end
        #20;
        if (pulse !== 1'b0) begin
            $display("Error: Test case 2 failed - Input: trigger=%b, Output: pulse=%b, Expected: pulse=0", trigger, pulse);
            test_failed = 1;
        end
        trigger = 0;
        #20;
        
        // Test case 3: Rapid trigger pulses
        trigger = 1;
        #10;
        if (pulse !== 1'b1) begin
            $display("Error: Test case 3 failed - Input: trigger=%b, Output: pulse=%b, Expected: pulse=1", trigger, pulse);
            test_failed = 1;
        end
        trigger = 0;
        #10;
        trigger = 1;
        #10;
        if (pulse !== 1'b0) begin
            $display("Error: Test case 3 failed - Input: trigger=%b, Output: pulse=%b, Expected: pulse=0", trigger, pulse);
            test_failed = 1;
        end
        trigger = 0;
        #20;
        
        // Test case 4: Reset during operation
        trigger = 1;
        #10;
        rst = 1;
        #10;
        if (pulse !== 1'b0) begin
            $display("Error: Test case 4 failed - Input: rst=%b, trigger=%b, Output: pulse=%b, Expected: pulse=0", rst, trigger, pulse);
            test_failed = 1;
        end
        rst = 0;
        trigger = 0;
        #20;
        
        if (test_failed) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        $finish;
    end
    
    // Monitor
    initial begin
        $monitor("Time=%0t: rst=%b, trigger=%b, pulse=%b", 
                 $time, rst, trigger, pulse);
    end
endmodule