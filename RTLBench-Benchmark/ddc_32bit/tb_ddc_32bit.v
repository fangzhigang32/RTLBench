`timescale 1ns/1ps

module tb_ddc_32bit;

    // Inputs
    reg         clk;
    reg         rst;
    reg [31:0]  x;
    
    // Outputs
    wire [31:0] i;
    wire [31:0] q;
    
    // Test control
    integer     error_count = 0;
    integer     test_count = 0;
    integer     verbose = 0;
    
    // Variables for Test case 6
    integer     t;
    reg [31:0]  expected_i;
    reg [31:0]  expected_q;
    
    // Instantiate the Unit Under Test (UUT)
    ddc_32bit uut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .i(i),
        .q(q)
    );
    
    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Reset generation
    initial begin
        rst = 1;
        #20;
        rst = 0;
        #10;
        rst = 1; // Test asynchronous reset mid-cycle
        #3;
        rst = 0;
    end
    
    // Stimulus and checking
    initial begin
        // Initialize Inputs
        x = 0;
        
        // Wait for initial reset to complete
        #25;
        
        // Test case 1: Zero input
        x = 32'd0;
        #10;
        test_count = test_count + 1;
        if (i !== 32'd0 || q !== 32'd0) begin
            $display("Error case 1 at %t: Input=%h, Expected i=0, q=0, Got i=%d, q=%d", $time, x, i, q);
            error_count = error_count + 1;
        end
        
        // Test case 2: Positive input (single sample)
        x = 32'd12345678;
        #10;
        test_count = test_count + 1;
        if (i !== 32'd12345678 || q !== 32'd0) begin
            $display("Error case 2 at %t: Input=%h, Expected i=12345678, q=0, Got i=%d, q=%d", $time, x, i, q);
            error_count = error_count + 1;
        end
        
        // Test case 3: Negative input
        x = -32'd87654321;
        #10;
        test_count = test_count + 1;
        if (i !== -32'd87654321 || q !== 32'd0) begin
            $display("Error case 3 at %t: Input=%h, Expected i=-87654321, q=0, Got i=%d, q=%d", $time, x, i, q);
            error_count = error_count + 1;
        end
        
        // Test case 4: Max positive input
        x = 32'h7FFFFFFF;
        #10;
        test_count = test_count + 1;
        if (i !== 32'h7FFFFFFF || q !== 32'd0) begin
            $display("Error case 4 at %t: Input=%h, Expected i=7FFFFFFF, q=0, Got i=%h, q=%d", $time, x, i, q);
            error_count = error_count + 1;
        end
        
        // Test case 5: Min negative input
        x = 32'h80000000;
        #10;
        test_count = test_count + 1;
        if (i !== 32'h80000000 || q !== 32'd0) begin
            $display("Error case 5 at %t: Input=%h, Expected i=80000000, q=0, Got i=%h, q=%d", $time, x, i, q);
            error_count = error_count + 1;
        end
        
        // Test case 6: Sinusoidal input to verify I/Q orthogonality
        for (t = 0; t < 16; t = t + 1) begin
            // Use fixed-point approximation for sine
            x = $rtoi(10000000.0 * $sin(2.0 * 3.14159 * t / 16.0));
            #10;
            test_count = test_count + 1;
            expected_i = $rtoi(x * $cos(2.0 * 3.14159 * t / 16.0));
            expected_q = $rtoi(x * $sin(2.0 * 3.14159 * t / 16.0));
            if (i !== expected_i || q !== expected_q) begin
                $display("Error case 6 at %t, t=%d: Input=%h, Expected i=%d, q=%d, Got i=%d, q=%d", 
                         $time, t, x, expected_i, expected_q, i, q);
                error_count = error_count + 1;
            end
        end
        
        // Test case 7: Asynchronous reset mid-cycle
        #5;
        rst = 1;
        #3;
        test_count = test_count + 1;
        if (i !== 32'd0 || q !== 32'd0) begin
            $display("Error case 7 at %t: Input=N/A (reset), Expected i=0, q=0, Got i=%d, q=%d", $time, i, q);
            error_count = error_count + 1;
        end
        rst = 0;
        
        // Summary
        #10;
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error: %d errors detected", error_count);
            $stop;
        end
        $finish;
    end

endmodule