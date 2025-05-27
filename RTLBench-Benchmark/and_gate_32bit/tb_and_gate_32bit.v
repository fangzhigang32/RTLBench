`timescale 1ns/1ps

module tb_and_gate_32bit;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    
    // Outputs
    wire [31:0] y;
    
    // Instantiate the Unit Under Test (UUT)
    and_gate_32bit uut (
        .a(a),
        .b(b),
        .y(y)
    );

    reg error_flag;
    
    // Test stimulus and checking
    initial begin
        error_flag = 0;
        
        // Initialize Inputs
        a = 32'h00000000;
        b = 32'h00000000;
        
        // Wait 10 ns for global reset
        #10;
        
        // Test Case 1: All zeros
        a = 32'h00000000;
        b = 32'h00000000;
        #10;
        if (y !== 32'h00000000) begin
            $display("Error: Test Case 1 - Input a: 32'h%h, b: 32'h%h, Output: 32'h%h, Expected: 32'h00000000", a, b, y);
            error_flag = 1;
        end
        
        // Test Case 2: All ones
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        #10;
        if (y !== 32'hFFFFFFFF) begin
            $display("Error: Test Case 2 - Input a: 32'h%h, b: 32'h%h, Output: 32'h%h, Expected: 32'hFFFFFFFF", a, b, y);
            error_flag = 1;
        end
        
        // Test Case 3: Alternating bits
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        #10;
        if (y !== 32'h00000000) begin
            $display("Error: Test Case 3 - Input a: 32'h%h, b: 32'h%h, Output: 32'h%h, Expected: 32'h00000000", a, b, y);
            error_flag = 1;
        end
        
        // Test Case 4: Random pattern 1
        a = 32'h12345678;
        b = 32'h87654321;
        #10;
        if (y !== (32'h12345678 & 32'h87654321)) begin
            $display("Error: Test Case 4 - Input a: 32'h%h, b: 32'h%h, Output: 32'h%h, Expected: 32'h%h", a, b, y, (32'h12345678 & 32'h87654321));
            error_flag = 1;
        end
        
        // Test Case 5: Random pattern 2
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        #10;
        if (y !== 32'h00000000) begin
            $display("Error: Test Case 5 - Input a: 32'h%h, b: 32'h%h, Output: 32'h%h, Expected: 32'h00000000", a, b, y);
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