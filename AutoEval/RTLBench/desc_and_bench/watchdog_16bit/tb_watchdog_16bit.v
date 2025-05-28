`timescale 1ns/1ps

module tb_watchdog_16bit;

    // Inputs
    reg clk;
    reg rst;
    reg en;

    // Outputs
    wire timeout;

    // Instantiate the Unit Under Test (UUT)
    watchdog_16bit uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .timeout(timeout)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    reg error_flag = 0;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        en = 0;

        // Wait for global reset
        #100;
        rst = 0;

        // Test Case 1: Disabled watchdog (en=0)
        en = 0;
        #100;
        if (timeout !== 1'b0) begin
            $display("Error: Test Case 1 - Timeout should be 0 when disabled");
            $display("Input: en=%b", en);
            $display("Output: %b", timeout);
            $display("Expected: 0");
            error_flag = 1;
        end

        // Test Case 2: Enabled watchdog, check timeout after full count
        en = 1;
        #655360; // Wait for 65536 clock cycles (16'hFFFF * 10ns)
        if (timeout !== 1'b1) begin
            $display("Error: Test Case 2 - Timeout should be 1 after full count");
            $display("Input: en=%b", en);
            $display("Output: %b", timeout);
            $display("Expected: 1");
            error_flag = 1;
        end

        // Test Case 3: Reset during counting
        en = 1;
        #10000;
        rst = 1;
        #10;
        if (timeout !== 1'b0) begin
            $display("Error: Test Case 3 - Timeout should reset");
            $display("Input: en=%b, rst=%b", en, rst);
            $display("Output: timeout=%b", timeout);
            $display("Expected: timeout=0");
            error_flag = 1;
        end

        // Test Case 4: Check timeout clears after one clock
        rst = 0;
        #655360; // Wait for full count again
        #10; // Wait one more clock
        if (timeout !== 1'b0) begin
            $display("Error: Test Case 4 - Timeout should clear after one clock");
            $display("Input: en=%b, rst=%b", en, rst);
            $display("Output: %b", timeout);
            $display("Expected: 0");
            error_flag = 1;
        end

        // Final result
        if (error_flag) begin
            $display("Exist Function Error");
        end
        else begin
            $display("No Function Error");
        end
        
        $finish;
    end

endmodule