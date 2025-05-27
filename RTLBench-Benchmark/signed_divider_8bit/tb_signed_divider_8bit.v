`timescale 1ns/1ps

module tb_signed_divider_8bit;

    // Inputs
    reg signed [7:0] a;
    reg signed [7:0] b;
    
    // Outputs
    wire signed [7:0] q;
    wire signed [7:0] r;
    
    // Instantiate the Unit Under Test (UUT)
    signed_divider_8bit uut (
        .a(a),
        .b(b),
        .q(q),
        .r(r)
    );
    
    integer i;
    reg [31:0] test_count;
    reg [31:0] pass_count;
    reg [31:0] fail_count;
    reg error_flag;
    
    initial begin
        // Initialize counters
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        error_flag = 0;
        
        // Test case 1: Basic positive division
        a = 8'd100;
        b = 8'd25;
        #10;
        test_count = test_count + 1;
        if (!(q === 8'd4 && r === 8'd0)) begin
            fail_count = fail_count + 1;
            error_flag = 1;
            $display("Error: Test case 1 failed - a=%d, b=%d, q=%d (expected 4), r=%d (expected 0)", a, b, q, r);
        end else begin
            pass_count = pass_count + 1;
        end
        
        // Test case 2: Division with remainder
        a = 8'd100;
        b = 8'd30;
        #10;
        test_count = test_count + 1;
        if (!(q === 8'd3 && r === 8'd10)) begin
            fail_count = fail_count + 1;
            error_flag = 1;
            $display("Error: Test case 2 failed - a=%d, b=%d, q=%d (expected 3), r=%d (expected 10)", a, b, q, r);
        end else begin
            pass_count = pass_count + 1;
        end
        
        // Test case 3: Negative dividend
        a = -8'd100;
        b = 8'd30;
        #10;
        test_count = test_count + 1;
        if (!(q === -8'd3 && r === -8'd10)) begin
            fail_count = fail_count + 1;
            error_flag = 1;
            $display("Error: Test case 3 failed - a=%d, b=%d, q=%d (expected -3), r=%d (expected -10)", a, b, q, r);
        end else begin
            pass_count = pass_count + 1;
        end
        
        // Test case 4: Negative divisor
        a = 8'd100;
        b = -8'd30;
        #10;
        test_count = test_count + 1;
        if (!(q === -8'd3 && r === 8'd10)) begin
            fail_count = fail_count + 1;
            error_flag = 1;
            $display("Error: Test case 4 failed - a=%d, b=%d, q=%d (expected -3), r=%d (expected 10)", a, b, q, r);
        end else begin
            pass_count = pass_count + 1;
        end
        
        // Test case 5: Both negative
        a = -8'd100;
        b = -8'd30;
        #10;
        test_count = test_count + 1;
        if (!(q === 8'd3 && r === -8'd10)) begin
            fail_count = fail_count + 1;
            error_flag = 1;
            $display("Error: Test case 5 failed - a=%d, b=%d, q=%d (expected 3), r=%d (expected -10)", a, b, q, r);
        end else begin
            pass_count = pass_count + 1;
        end
        
        // Test case 6: Division by zero
        a = 8'd100;
        b = 8'd0;
        #10;
        test_count = test_count + 1;
        if (!(q === 8'hFF && r === 8'hFF)) begin
            fail_count = fail_count + 1;
            error_flag = 1;
            $display("Error: Test case 6 failed - a=%d, b=%d, q=%d (expected FF), r=%d (expected FF)", a, b, q, r);
        end else begin
            pass_count = pass_count + 1;
        end
        
        // Test case 7: Random tests
        for (i = 0; i < 10; i = i + 1) begin
            a = $random;
            b = $random;
            while (b === 0) b = $random; // Avoid division by zero
            #10;
            test_count = test_count + 1;
            if (!(q === a / b && r === a % b)) begin
                fail_count = fail_count + 1;
                error_flag = 1;
                $display("Error: Random test %0d failed - a=%d, b=%d, q=%d (expected %d), r=%d (expected %d)", 
                         i+1, a, b, q, a/b, r, a%b);
            end else begin
                pass_count = pass_count + 1;
            end
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