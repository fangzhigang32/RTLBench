`timescale 1ns/1ps

module tb_restoring_divider_16bit();

    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] q;
    wire [15:0] r;
    reg error_flag;

    // Instantiate the DUT (no clk, reset, or done since it's combinational)
    restoring_divider_16bit dut (
        .a(a),
        .b(b),
        .q(q),
        .r(r)
    );

    // Test cases
    task test_case;
        input [15:0] dividend;
        input [15:0] divisor;
        input [15:0] expected_q;
        input [15:0] expected_r;
        begin
            a = dividend;
            b = divisor;
            #10; // Allow some time for combinational logic to settle
            
            if (q !== expected_q || r !== expected_r) begin
                error_flag = 1;
                $display("Test failed: %d / %d", dividend, divisor);
                $display("  Got: q=%d, r=%d", q, r);
                $display("  Expected: q=%d, r=%d", expected_q, expected_r);
            end
        end
    endtask

    // Main test sequence
    initial begin
        // Initialize signals
        a = 0;
        b = 0;
        error_flag = 0;

        // Run test cases
        #10; // Initial delay
        
        // Test case 1: Normal division
        test_case(16'd1000, 16'd25, 16'd40, 16'd0);
        
        // Test case 2: Division with remainder
        test_case(16'd1001, 16'd25, 16'd40, 16'd1);
        
        // Test case 3: Large numbers
        test_case(16'd65535, 16'd1234, 16'd53, 16'd133);
        
        // Test case 4: Divide by 1
        test_case(16'd32767, 16'd1, 16'd32767, 16'd0);
        
        // Test case 5: Divide by zero (should handle specially, e.g., q=FFFF, r=FFFF)
        test_case(16'd500, 16'd0, 16'hFFFF, 16'hFFFF);
        
        // Test case 6: Small dividend
        test_case(16'd5, 16'd10, 16'd0, 16'd5);
        
        // Final result
        if (error_flag) begin
            $display("Test FAILED - Some cases had errors!");
        end else begin
            $display("Test PASSED - All cases correct!");
        end
        
        // Finish simulation
        #100;
        $finish;
    end

    // Monitor to observe changes
    initial begin
        $monitor("At time %t: a=%d, b=%d, q=%d, r=%d", 
                 $time, a, b, q, r);
    end

endmodule