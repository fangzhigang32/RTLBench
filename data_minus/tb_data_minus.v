`timescale 1ns/1ps

module tb_data_minus;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] a;
    reg [7:0] b;

    // Output
    wire [7:0] c;

    // Test pass/fail counter
    integer test_passed = 0;
    integer test_failed = 0;

    // Instantiate the Unit Under Test (UUT)
    data_minus uut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .c(c)
    );

    // Clock generation (100MHz, adjustable based on target technology)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock (10ns period)
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        rst = 1;
        a = 0;
        b = 0;
        #10;

        // Test case 0: Check initial state before reset
        if (c !== 8'd0) begin
            $display("Error: Test case 0 failed. Input: a=%d, b=%d, Expected: 0, Got: %d", a, b, c);
            test_failed = test_failed + 1;
        end

        // Test case 1: Check reset state
        #10; // Wait for one clock cycle
        if (c !== 8'd0) begin
            $display("Error: Test case 1 failed. Input: a=%d, b=%d, Expected: 0, Got: %d", a, b, c);
            test_failed = test_failed + 1;
        end else begin
            test_passed = test_passed + 1;
        end

        // Release reset
        @(negedge clk); // Align reset release with clock edge
        rst = 0;
        #10;

        // Test case 2: a > b
        a = 8'd100;
        b = 8'd50;
        @(posedge clk); // Wait for positive clock edge
        #10; // Check after one cycle
        if (c !== 8'd50) begin
            $display("Error: Test case 2 failed. Input: a=%d, b=%d, Expected: 50, Got: %d", a, b, c);
            test_failed = test_failed + 1;
        end else begin
            test_passed = test_passed + 1;
        end

        // Test case 3: b > a
        a = 8'd30;
        b = 8'd75;
        @(posedge clk);
        #10;
        if (c !== 8'd45) begin
            $display("Error: Test case 3 failed. Input: a=%d, b=%d, Expected: 45, Got: %d", a, b, c);
            test_failed = test_failed + 1;
        end else begin
            test_passed = test_passed + 1;
        end

        // Test case 4: a == b
        a = 8'd200;
        b = 8'd200;
        @(posedge clk);
        #10;
        if (c !== 8'd0) begin
            $display("Error: Test case 4 failed. Input: a=%d, b=%d, Expected: 0, Got: %d", a, b, c);
            test_failed = test_failed + 1;
        end else begin
            test_passed = test_passed + 1;
        end

        // Test case 5: edge case (max difference)
        a = 8'd255;
        b = 8'd0;
        @(posedge clk);
        #10;
        if (c !== 8'd255) begin
            $display("Error: Test case 5 failed. Input: a=%d, b=%d, Expected: 255, Got: %d", a, b, c);
            test_failed = test_failed + 1;
        end else begin
            test_passed = test_passed + 1;
        end

        // Test case 6: multiple random tests
        repeat (100) begin
            a = $urandom % 256; // Random 8-bit value
            b = $urandom % 256;
            @(posedge clk);
            #10;
            if (c !== (a > b ? a - b : b - a)) begin
                $display("Error: Test case 6 failed. Input: a=%d, b=%d, Expected: %d, Got: %d", a, b, (a > b ? a - b : b - a), c);
                test_failed = test_failed + 1;
            end else begin
                test_passed = test_passed + 1;
            end
        end

        // Test case 7: setup/hold time stress test
        @(posedge clk);
        #4; // Apply inputs 1ns before positive edge (assuming 5ns setup time)
        a = 8'd150;
        b = 8'd100;
        @(posedge clk);
        #10;
        if (c !== 8'd50) begin
            $display("Error: Test case 7 failed. Input: a=%d, b=%d, Expected: 50, Got: %d", a, b, c);
            test_failed = test_failed + 1;
        end else begin
            test_passed = test_passed + 1;
        end

        // Test case 8: hold time stress test
        @(posedge clk);
        a = 8'd120;
        b = 8'd70;
        #2; // Change inputs 2ns after positive edge (assuming 2ns hold time)
        a = 8'd0; // Simulate input change to stress hold time
        @(posedge clk);
        #10;
        if (c !== 8'd50) begin
            $display("Error: Test case 8 failed. Input: a=%d, b=%d, Expected: 50, Got: %d", a, b, c);
            test_failed = test_failed + 1;
        end else begin
            test_passed = test_passed + 1;
        end

        // Test case 9: async reset release timing
        @(negedge clk);
        #2; // Release reset mid-cycle to test async behavior
        rst = 1;
        #3;
        rst = 0;
        @(posedge clk);
        #10;
        if (c !== 8'd0) begin
            $display("Error: Test case 9 failed. Input: a=%d, b=%d, Expected: 0, Got: %d", a, b, c);
            test_failed = test_failed + 1;
        end else begin
            test_passed = test_passed + 1;
        end

        // Final output
        if (test_failed == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end

        // End simulation
        $finish;
    end

endmodule