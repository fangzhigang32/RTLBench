`timescale 1ns/1ps

module tb_binary_counter_8bit;
    // Inputs
    reg clk;
    reg rst;
    reg en;
    
    // Outputs
    wire [7:0] q;
    
    // Instantiate the Unit Under Test (UUT)
    binary_counter_8bit uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .q(q)
    );
    
    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    reg error_flag = 0;
    
    // Task to apply reset
    task apply_reset;
        begin
            @(negedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            if (q !== 8'b0) begin
                $display("Time %0t: Error: Reset failed. Got %b, expected 8'b0", $time, q);
                error_flag = 1;
            end
            @(negedge clk);
            rst = 0;
        end
    endtask
    
    // Task to test enable functionality
    task test_enable;
        input [7:0] expected_value;
        begin
            @(negedge clk);
            en = 1;
            @(posedge clk);
            #1;
            if (q !== expected_value) begin
                $display("Time %0t: Error: Increment failed. Got %b, expected %b", $time, q, expected_value);
                error_flag = 1;
            end
        end
    endtask
    
    // Task to test disable functionality
    task test_disable;
        input [7:0] expected_value;
        begin
            @(negedge clk);
            en = 0;
            @(posedge clk);
            #1;
            if (q !== expected_value) begin
                $display("Time %0t: Error: Counter should not increment when disabled. Got %b, expected %b", $time, q, expected_value);
                error_flag = 1;
            end
        end
    endtask
    
    // Task to test rollover
    task test_rollover;
        begin
            @(negedge clk);
            en = 1;
            repeat(255) begin
                @(posedge clk);
                #1;
            end
            if (q !== 8'b11111111) begin
                $display("Time %0t: Error: Counter max value failed. Got %b, expected 8'b11111111", $time, q);
                error_flag = 1;
            end
            @(posedge clk);
            #1;
            if (q !== 8'b0) begin
                $display("Time %0t: Error: Counter rollover failed. Got %b, expected 8'b0", $time, q);
                error_flag = 1;
            end
        end
    endtask
    
    // Test stimulus and verification
    initial begin
        // Initialize inputs
        rst = 0;
        en = 0;
        
        // Test 1: Reset functionality
        apply_reset;
        
        // Test 2: Enable and single increment
        test_enable(8'b1);
        
        // Test 3: Multiple increments
        test_enable(8'b10);
        
        // Test 4: Disable functionality
        test_disable(8'b10);
        test_disable(8'b10);
        
        // Test 5: Reset during counting
        test_enable(8'b11);
        apply_reset;
        
        // Test 6: Rollover
        test_rollover;
        
        // Test 7: Simultaneous reset and enable
        @(negedge clk);
        rst = 1;
        en = 1;
        @(posedge clk);
        #1;
        if (q !== 8'b0) begin
            $display("Time %0t: Error: Reset with enable high failed. Got %b, expected 8'b0", $time, q);
            error_flag = 1;
        end
        @(negedge clk);
        rst = 0;
        
        // Final result
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        #10;
        $finish;
    end
    
    // Simulation timeout
    initial begin
        #1000;
        $display("Time %0t: Error: Simulation timeout", $time);
        $finish;
    end
endmodule