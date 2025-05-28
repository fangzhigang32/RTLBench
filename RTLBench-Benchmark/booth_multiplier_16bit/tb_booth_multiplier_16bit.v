`timescale 1ns/1ps

module tb_booth_multiplier_16bit;

    // Inputs
    reg signed [15:0] a;
    reg signed [15:0] b;
    
    // Output
    wire signed [31:0] p;
    
    // Instantiate the Unit Under Test (UUT)
    booth_multiplier_16bit uut (
        .a(a),
        .b(b),
        .p(p)
    );
    
    integer i;
    reg signed [31:0] expected;
    reg test_passed;
    reg any_failed;
    
    initial begin
        test_passed = 1; // Assume all tests pass initially
        any_failed = 0;
        //$display("Starting Booth Multiplier Testbench...");
        
        // Test case 1: Positive x Positive
        a = 16'd125;
        b = 16'd30;
        expected = a * b;
        #10; // Allow propagation delay
        run_test_case(1);
        
        // Test case 2: Negative x Positive
        a = -16'd200;
        b = 16'd50;
        expected = a * b;
        #10;
        run_test_case(2);
        
        // Test case 3: Positive x Negative
        a = 16'd300;
        b = -16'd40;
        expected = a * b;
        #10;
        run_test_case(3);
        
        // Test case 4: Negative x Negative
        a = -16'd150;
        b = -16'd25;
        expected = a * b;
        #10;
        run_test_case(4);
        
        // Test case 5: Zero case
        a = 16'd0;
        b = -16'd32768;
        expected = a * b;
        #10;
        run_test_case(5);
        
        // Test case 6: Max positive values
        a = 16'd32767;
        b = 16'd32767;
        expected = a * b;
        #10;
        check_overflow(6); // Check for overflow
        run_test_case(6);
        
        // Test case 7: Min negative values
        a = -16'd32768;
        b = -16'd32768;
        expected = a * b;
        #10;
        check_overflow(7); // Check for overflow
        run_test_case(7);
        
        // Random test cases with fixed seed for reproducibility
        $urandom(12345); // Set random seed
        for (i = 0; i < 10; i = i + 1) begin
            a = $urandom;
            b = $urandom;
            expected = a * b;
            #10;
            run_test_case(i + 8);
        end
        
        // Summary
        if (!any_failed) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end
    
    // Task to run a single test case
    task run_test_case(input integer test_num);
        begin
            if (p !== expected) begin
                $display("Error: Test case %d failed", test_num);
                $display("Input: a=%d, b=%d", a, b);
                $display("Output: %d, Expected: %d", p, expected);
                test_passed = 0;
                any_failed = 1;
            end
            // No output for passed tests
        end
    endtask
    
    // Task to check for overflow
    task check_overflow(input integer test_num);
        reg signed [31:0] temp;
        begin
            temp = a * b; // Perform multiplication in 32-bit arithmetic
            if ((a[15] == b[15] && temp[31] != 0) || (a[15] != b[15] && temp[31] != 1)) begin
                //$display("Warning: Test case %d may cause overflow", test_num);
            end
        end
    endtask
    
endmodule