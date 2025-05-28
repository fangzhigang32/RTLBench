`timescale 1ns/1ps

module tb_fp_adder_16bit;

    // Inputs
    reg [15:0] a;
    reg [15:0] b;
    
    // Outputs
    wire [15:0] s;
    
    // Instantiate the Unit Under Test (UUT)
    fp_adder_16bit uut (
        .a(a),
        .b(b),
        .s(s)
    );
    
    integer i;
    reg [15:0] expected;
    reg error_flag;
    
    initial begin
        error_flag = 0;
        
        // Test case 1: Basic addition
        a = 16'h3C00; // 1.0
        b = 16'h4000; // 2.0
        expected = 16'h4200; // 3.0
        #10;
        if (s !== expected) begin
            $display("Error case 1: a=%h, b=%h, s=%h, expected=%h", a, b, s, expected);
            error_flag = 1;
        end
        
        // Test case 2: Addition with different signs
        a = 16'hC000; // -2.0
        b = 16'h3C00; // 1.0
        expected = 16'hBC00; // -1.0
        #10;
        if (s !== expected) begin
            $display("Error case 2: a=%h, b=%h, s=%h, expected=%h", a, b, s, expected);
            error_flag = 1;
        end
        
        // Test case 3: Addition of zeros
        a = 16'h0000; // +0.0
        b = 16'h8000; // -0.0
        expected = 16'h0000; // +0.0
        #10;
        if (s !== expected) begin
            $display("Error case 3: a=%h, b=%h, s=%h, expected=%h", a, b, s, expected);
            error_flag = 1;
        end
        
        // Test case 4: Infinity cases
        a = 16'h7C00; // +inf
        b = 16'h3C00; // 1.0
        expected = 16'h7C00; // +inf
        #10;
        if (s !== expected) begin
            $display("Error case 4: a=%h, b=%h, s=%h, expected=%h", a, b, s, expected);
            error_flag = 1;
        end
        
        // Test case 5: NaN cases
        a = 16'h7E00; // NaN
        b = 16'h3C00; // 1.0
        expected = 16'h7E00; // NaN (any NaN payload is acceptable)
        #10;
        if (!(s[14:10] === 5'b11111 && s[9:0] !== 0)) begin
            $display("Error case 5: a=%h, b=%h, s=%h, expected NaN", a, b, s);
            error_flag = 1;
        end
        
        // Test case 6: Denormal numbers
        a = 16'h0001; // smallest denormal
        b = 16'h0001; // smallest denormal
        expected = 16'h0002; // 2 * smallest denormal
        #10;
        if (s !== expected) begin
            $display("Error case 6: a=%h, b=%h, s=%h, expected=%h", a, b, s, expected);
            error_flag = 1;
        end
        
        // Test case 7: Overflow case
        a = 16'h7BFF; // largest normal number
        b = 16'h7BFF; // largest normal number
        expected = 16'h7C00; // +inf
        #10;
        if (s !== expected) begin
            $display("Error case 7: a=%h, b=%h, s=%h, expected=%h", a, b, s, expected);
            error_flag = 1;
        end
        
        // Test case 8: Opposite infinities (should produce NaN)
        a = 16'h7C00; // +inf
        b = 16'hFC00; // -inf
        #10;
        if (!(s[14:10] === 5'b11111 && s[9:0] !== 0)) begin
            $display("Error case 8: a=%h, b=%h, s=%h, expected NaN", a, b, s);
            error_flag = 1;
        end
        
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        
        $finish;
    end
    
endmodule