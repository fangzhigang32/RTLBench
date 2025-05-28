`timescale 1ns/1ps

module tb_fp_adder_64bit;

    reg [63:0] a, b;
    wire [63:0] s;
    reg error_flag;
    
    // Instantiate the DUT
    fp_adder_64bit dut (
        .a(a),
        .b(b),
        .s(s)
    );
    
    // Test cases
    initial begin
        error_flag = 0;
        
        // Test case 1: Simple addition
        a = 64'h3FF0000000000000; // 1.0
        b = 64'h3FF0000000000000; // 1.0
        #10;
        if (s !== 64'h4000000000000000) begin // Expected 2.0
            $display("Error case 1: 1.0 + 1.0 = %h, expected 4000000000000000", s);
            error_flag = 1;
        end
        
        // Test case 2: Addition with different exponents
        a = 64'h3FF0000000000000; // 1.0
        b = 64'h3FE0000000000000; // 0.5
        #10;
        if (s !== 64'h3FF8000000000000) begin // Expected 1.5
            $display("Error case 2: 1.0 + 0.5 = %h, expected 3FF8000000000000", s);
            error_flag = 1;
        end
        
        // Test case 3: Subtraction
        a = 64'h3FF0000000000000; // 1.0
        b = 64'hBFE0000000000000; // -0.5
        #10;
        if (s !== 64'h3FE0000000000000) begin // Expected 0.5
            $display("Error case 3: 1.0 + (-0.5) = %h, expected 3FE0000000000000", s);
            error_flag = 1;
        end
        
        // Test case 4: Special case - zero
        a = 64'h0000000000000000; // +0.0
        b = 64'h0000000000000000; // +0.0
        #10;
        if (s !== 64'h0000000000000000) begin // Expected +0.0
            $display("Error case 4: 0.0 + 0.0 = %h, expected 0000000000000000", s);
            error_flag = 1;
        end
        
        // Test case 5: Special case - infinity
        a = 64'h7FF0000000000000; // +inf
        b = 64'h7FF0000000000000; // +inf
        #10;
        if (s !== 64'h7FF0000000000000) begin // Expected +inf
            $display("Error case 5: +inf + +inf = %h, expected 7FF0000000000000", s);
            error_flag = 1;
        end
        
        // Test case 6: Special case - NaN
        a = 64'h7FF0000000000001; // NaN
        b = 64'h3FF0000000000000; // 1.0
        #10;
        if (s !== 64'h7FF8000000000000) begin // Expected canonical NaN
            $display("Error case 6: NaN + 1.0 = %h, expected 7FF8000000000000", s);
            error_flag = 1;
        end
        
        // Test case 7: Large exponent difference
        a = 64'h7FEFFFFFFFFFFFFF; // Largest normal number
        b = 64'h0000000000000001; // Smallest denormal number
        #10;
        if (s !== 64'h7FEFFFFFFFFFFFFF) begin // Expected largest normal number
            $display("Error case 7: Large + small = %h, expected 7FEFFFFFFFFFFFFF", s);
            error_flag = 1;
        end
        
        // Test case 8: Opposite infinities (should be NaN)
        a = 64'h7FF0000000000000; // +inf
        b = 64'hFFF0000000000000; // -inf
        #10;
        if (s !== 64'h7FF8000000000000) begin // Expected NaN
            $display("Error case 8: +inf + -inf = %h, expected 7FF8000000000000", s);
            error_flag = 1;
        end
        
        if (error_flag)
            $display("Exist Function Error");
        else
            $display("No Function Error");
            
        $finish;
    end
    
    // Monitor
    initial begin
        $monitor("At time %t: a = %h, b = %h, s = %h", $time, a, b, s);
    end

endmodule