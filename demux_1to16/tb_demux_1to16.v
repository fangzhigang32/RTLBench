`timescale 1ns/1ps

module tb_demux_1to16;
    // Inputs
    reg d;
    reg [3:0] sel;
    
    // Outputs
    wire [15:0] y;
    
    // Instantiate the Unit Under Test (UUT)
    demux_1to16 uut (
        .d(d),
        .sel(sel),
        .y(y)
    );
    
    reg error_flag = 0;
    
    initial begin
        // Initialize Inputs
        d = 0;
        sel = 0;
        
        // Wait for global reset
        #10;
        
        // Test case 1: d=1, sel=0000 (y[0] should be 1)
        d = 1;
        sel = 4'b0000;
        #10;
        if (y !== 16'b0000000000000001) begin
            $display("Error: Test case 1 failed - Input: d=%b, sel=%b | Output: %b | Expected: 16'b0000000000000001", d, sel, y);
            error_flag = 1;
        end
        
        // Test case 2: d=1, sel=0101 (y[5] should be 1)
        sel = 4'b0101;
        #10;
        if (y !== 16'b0000000000100000) begin
            $display("Error: Test case 2 failed - Input: d=%b, sel=%b | Output: %b | Expected: 16'b0000000000100000", d, sel, y);
            error_flag = 1;
        end
        
        // Test case 3: d=0, sel=1010 (y[10] should be 0)
        d = 0;
        sel = 4'b1010;
        #10;
        if (y !== 16'b0000000000000000) begin
            $display("Error: Test case 3 failed - Input: d=%b, sel=%b | Output: %b | Expected: 16'b0000000000000000", d, sel, y);
            error_flag = 1;
        end
        
        // Test case 4: d=1, sel=1111 (y[15] should be 1)
        d = 1;
        sel = 4'b1111;
        #10;
        if (y !== 16'b1000000000000000) begin
            $display("Error: Test case 4 failed - Input: d=%b, sel=%b | Output: %b | Expected: 16'b1000000000000000", d, sel, y);
            error_flag = 1;
        end
        
        // Test case 5: d=1, sel=4'bxxxx (default case)
        sel = 4'bxxxx;
        #10;
        if (y !== 16'b0000000000000000) begin
            $display("Error: Test case 5 failed - Input: d=%b, sel=%b | Output: %b | Expected: 16'b0000000000000000", d, sel, y);
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