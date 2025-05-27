// Testbench for 8-bit Synchronous Reset Module
`timescale 1ns/1ps

module tb_reset_8bit;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] d;
    
    // Outputs
    wire [7:0] q;
    
    // Instantiate the Unit Under Test (UUT)
    reset_8bit uut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q)
    );
    
    integer error_count;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Stimulus and checking
    initial begin
        // Error flag
        error_count = 0;
        
        // Initialize Inputs
        rst = 0;
        d = 8'h00;
        
        // Wait for global reset
        #10;
        
        // Test case 1: Normal operation
        d = 8'hAA;
        #10;
        if (q !== 8'hAA) begin
            $display("Error: Case 1 - Input: 8'hAA, Output: %h, Expected: 8'hAA", q);
            error_count = error_count + 1;
        end
        
        // Test case 2: Reset operation
        rst = 1;
        d = 8'h55;
        #10;
        if (q !== 8'h00) begin
            $display("Error: Case 2 - Input: 8'h55, Output: %h, Expected: 8'h00", q);
            error_count = error_count + 1;
        end
        
        // Test case 3: Release reset
        rst = 0;
        d = 8'h55;
        #10;
        if (q !== 8'h55) begin
            $display("Error: Case 3 - Input: 8'h55, Output: %h, Expected: 8'h55", q);
            error_count = error_count + 1;
        end
        
        // Test case 4: Change data without reset
        d = 8'hFF;
        #10;
        if (q !== 8'hFF) begin
            $display("Error: Case 4 - Input: 8'hFF, Output: %h, Expected: 8'hFF", q);
            error_count = error_count + 1;
        end
        
        // Test case 5: Reset again
        rst = 1;
        d = 8'h11;
        #10;
        if (q !== 8'h00) begin
            $display("Error: Case 5 - Input: 8'h11, Output: %h, Expected: 8'h00", q);
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
    
endmodule