`timescale 1ns/1ps

module tb_two_stage_synchronizer;

    // Inputs
    reg clk;
    reg rst;
    reg d;

    // Output
    wire q;

    // Instantiate the Unit Under Test (UUT)
    two_stage_synchronizer uut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q)
    );

    reg error_flag;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus and checking
    initial begin
        // Initialize inputs
        rst = 1;
        d = 0;
        error_flag = 0;
        
        // Reset the system
        #10;
        rst = 0;
        
        // Test case 1: Input 0
        d = 0;
        #20; // Wait for two clock cycles
        if (q !== 0) begin
            $display("Error: Test case 1 failed. Input d=%b, Output q=%b, Expected q=0", d, q);
            error_flag = 1;
        end
        
        // Test case 2: Input 1
        d = 1;
        #10; // First stage sync
        if (q !== 0) begin
            $display("Error: Test case 2 stage 1 failed. Input d=%b, Output q=%b, Expected q=0", d, q);
            error_flag = 1;
        end
        #10; // Second stage sync
        if (q !== 1) begin
            $display("Error: Test case 2 stage 2 failed. Input d=%b, Output q=%b, Expected q=1", d, q);
            error_flag = 1;
        end
        
        // Test case 3: Reset test
        rst = 1;
        #10;
        if (q !== 0) begin
            $display("Error: Test case 3 failed. Input rst=%b, Output q=%b, Expected q=0", rst, q);
            error_flag = 1;
        end
        rst = 0;
        
        // Test case 4: Input toggle
        d = 0;
        #20;
        if (q !== 0) begin
            $display("Error: Test case 4 stage 1 failed. Input d=%b, Output q=%b, Expected q=0", d, q);
            error_flag = 1;
        end
        d = 1;
        #20;
        if (q !== 1) begin
            $display("Error: Test case 4 stage 2 failed. Input d=%b, Output q=%b, Expected q=1", d, q);
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