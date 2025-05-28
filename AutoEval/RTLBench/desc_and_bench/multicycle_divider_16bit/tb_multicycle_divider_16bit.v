`timescale 1ns / 1ps

module tb_multicycle_divider_16bit;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [15:0] a;
    reg [15:0] b;

    // Outputs
    wire [15:0] q;
    wire [15:0] r;
    wire done;

    // Instantiate the Unit Under Test (UUT)
    multicycle_divider_16bit uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .q(q),
        .r(r),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Test procedure
    reg error_flag = 0;
    initial begin
        // Initialize Inputs
        rst = 1;
        start = 0;
        a = 0;
        b = 0;

        // Reset
        #20;
        rst = 0;

        // Test Case 1: Normal division (100 / 5 = 20 remainder 0)
        #10;
        a = 100;
        b = 5;
        start = 1;
        #10;
        start = 0;
        
        // Wait for done signal
        @(posedge done);
        #5;
        if (!(q == 20 && r == 0)) begin
            $display("Test Case 1 failed: Input a=%d, b=%d, Expected q=20, r=0, Got q=%d, r=%d", a, b, q, r);
            error_flag = 1;
        end

        // Test Case 2: Division by zero (50 / 0)
        #20;
        a = 50;
        b = 0;
        start = 1;
        #10;
        start = 0;
        
        @(posedge done);
        #5;
        if (!(q == 16'hFFFF && r == 50)) begin
            $display("Test Case 2 failed: Input a=%d, b=%d, Expected q=0xFFFF, r=50, Got q=%h, r=%d", a, b, q, r);
            error_flag = 1;
        end

        // Test Case 3: Large numbers (65535 / 3)
        #20;
        a = 65535;
        b = 3;
        start = 1;
        #10;
        start = 0;
        
        @(posedge done);
        #5;
        if (!(q == 21845 && r == 0)) begin
            $display("Test Case 3 failed: Input a=%d, b=%d, Expected q=21845, r=0, Got q=%d, r=%d", a, b, q, r);
            error_flag = 1;
        end

        // Test Case 4: Small numbers (7 / 2)
        #20;
        a = 7;
        b = 2;
        start = 1;
        #10;
        start = 0;
        
        @(posedge done);
        #5;
        if (!(q == 3 && r == 1)) begin
            $display("Test Case 4 failed: Input a=%d, b=%d, Expected q=3, r=1, Got q=%d, r=%d", a, b, q, r);
            error_flag = 1;
        end

        // Final result
        if (error_flag)
            $display("Exist Function Error");
        else
            $display("No Function Error");

        // End simulation
        #100;
        $finish;
    end

endmodule