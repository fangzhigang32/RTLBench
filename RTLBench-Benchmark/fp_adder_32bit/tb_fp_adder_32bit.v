`timescale 1ns/1ps

module tb_fp_adder_32bit;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    
    // Outputs
    wire [31:0] s;
    
    // Instantiate the Unit Under Test (UUT)
    fp_adder_32bit uut (
        .a(a),
        .b(b),
        .s(s)
    );
    
    // Test cases
    reg error_flag;
    initial begin
        error_flag = 0;
        
        // Test case 1: Basic addition
        a = 32'h3F800000; // 1.0
        b = 32'h40000000; // 2.0
        #10;
        if (s !== 32'h40400000) begin // Expected 3.0
            $display("Error case 1: input a=%h, b=%h, output=%h, expected 40400000", a, b, s);
            error_flag = 1;
        end
        
        // Test case 2: Negative addition
        a = 32'hBF800000; // -1.0
        b = 32'hC0000000; // -2.0
        #10;
        if (s !== 32'hC0400000) begin // Expected -3.0
            $display("Error case 2: input a=%h, b=%h, output=%h, expected C0400000", a, b, s);
            error_flag = 1;
        end
        
        // Test case 3: Mixed signs
        a = 32'h3F800000; // 1.0
        b = 32'hBF800000; // -1.0
        #10;
        if (s !== 32'h00000000) begin // Expected 0.0
            $display("Error case 3: input a=%h, b=%h, output=%h, expected 00000000", a, b, s);
            error_flag = 1;
        end
        
        // Test case 4: Addition with zero
        a = 32'h3F800000; // 1.0
        b = 32'h00000000; // 0.0
        #10;
        if (s !== 32'h3F800000) begin // Expected 1.0
            $display("Error case 4: input a=%h, b=%h, output=%h, expected 3F800000", a, b, s);
            error_flag = 1;
        end
        
        // Test case 5: Infinity case
        a = 32'h7F800000; // +inf
        b = 32'h3F800000; // 1.0
        #10;
        if (s !== 32'h7F800000) begin // Expected +inf
            $display("Error case 5: input a=%h, b=%h, output=%h, expected 7F800000", a, b, s);
            error_flag = 1;
        end
        
        // Test case 6: NaN case
        a = 32'h7FC00000; // NaN
        b = 32'h3F800000; // 1.0
        #10;
        if (s !== 32'h7FC00000) begin // Expected NaN (same as input NaN)
            $display("Error case 6: input a=%h, b=%h, output=%h, expected 7FC00000", a, b, s);
            error_flag = 1;
        end
        
        // Test case 7: Very small numbers
        a = 32'h00000001; // Smallest denormal
        b = 32'h00000001; // Smallest denormal
        #10;
        if (s !== 32'h00000002) begin // Expected 2 * smallest denormal
            $display("Error case 7: input a=%h, b=%h, output=%h, expected 00000002", a, b, s);
            error_flag = 1;
        end
        
        // Test case 8: Overflow case
        a = 32'h7F7FFFFF; // Largest normal number
        b = 32'h7F7FFFFF; // Largest normal number
        #10;
        if (s !== 32'h7F800000) begin // Expected +inf
            $display("Error case 8: input a=%h, b=%h, output=%h, expected 7F800000", a, b, s);
            error_flag = 1;
        end
        
        // Test case 9: Different exponents
        a = 32'h41200000; // 10.0
        b = 32'h3DCCCCCD; // 0.1
        #10;
        if (s !== 32'h4121999A) begin // Expected ~10.1
            $display("Error case 9: input a=%h, b=%h, output=%h, expected 4121999A", a, b, s);
            error_flag = 1;
        end
        
        // Test case 10: Opposite infinities
        a = 32'h7F800000; // +inf
        b = 32'hFF800000; // -inf
        #10;
        if (s !== 32'h7FC00000) begin // Expected NaN
            $display("Error case 10: input a=%h, b=%h, output=%h, expected 7FC00000", a, b, s);
            error_flag = 1;
        end
        
        if (error_flag)
            $display("Exist Function Error");
        else
            $display("No Function Error");
            
        $finish;
    end
    
endmodule