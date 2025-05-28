// Testbench for 16-bit Ring Counter
`timescale 1ns/1ps

module tb_ring_counter_16bit;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [15:0] q;

    // Instantiate the Unit Under Test (UUT)
    ring_counter_16bit uut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus and verification
    integer error_count = 0;
    initial begin
        // Initialize inputs
        rst = 1;
        
        // Apply reset and check initial state
        #10;
        if (q !== 16'h0001) begin
            $display("Error: Reset state incorrect. Got %h, expected 16'h0001", q);
            error_count = error_count + 1;
        end
        
        // Release reset and test rotation
        rst = 0;
        #10;
        
        // Verify rotation sequence
        if (q !== 16'h8000) begin
            $display("Error: First rotation incorrect. Got %h, expected 16'h8000", q);
            error_count = error_count + 1;
        end
        
        #10;
        if (q !== 16'h4000) begin
            $display("Error: Second rotation incorrect. Got %h, expected 16'h4000", q);
            error_count = error_count + 1;
        end
        
        #10;
        if (q !== 16'h2000) begin
            $display("Error: Third rotation incorrect. Got %h, expected 16'h2000", q);
            error_count = error_count + 1;
        end
        
        // Test reset during operation
        rst = 1;
        #10;
        if (q !== 16'h0001) begin
            $display("Error: Reset during operation failed. Got %h, expected 16'h0001", q);
            error_count = error_count + 1;
        end
        
        // Continue testing after reset
        rst = 0;
        #10;
        if (q !== 16'h8000) begin
            $display("Error: Post-reset rotation incorrect. Got %h, expected 16'h8000", q);
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
        $monitor("Time = %t, clk = %b, rst = %b, q = %h", $time, clk, rst, q);
    end

endmodule