`timescale 1ns/1ps

module tb_d_ff_en();

    // Inputs
    reg clk;
    reg rst;
    reg d;
    reg en;

    // Output
    wire q;

    // Instantiate the Unit Under Test (UUT)
    d_ff_en uut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .en(en),
        .q(q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Variables for tracking test results
    integer error_count = 0;
    integer total_tests = 7;

    // Task to apply stimulus and check output
    task apply_test;
        input rst_val;
        input en_val;
        input d_val;
        input expected_q;
        reg [8*20:0] test_name;  // Test name storage
        begin
            rst = rst_val;
            en = en_val;
            d = d_val;
            #2; // Ensure inputs are stable before clock edge
            @(posedge clk); // Wait for rising edge
            #1; // Small delay to account for propagation
            if (q !== expected_q) begin
                $display("Error: Test failed. Input: rst=%b, en=%b, d=%b. Output: q=%b, expected %b", 
                        rst_val, en_val, d_val, q, expected_q);
                error_count = error_count + 1;
            end
        end
    endtask

    // Stimulus and checking
    initial begin
        // Initialize inputs
        rst = 1;
        d = 0;
        en = 0;
        #10;

        // Test case 0: Initial reset check
        if (q !== 1'b0) begin
            $display("Error: Initial reset failed. q = %b, expected 0", q);
            error_count = error_count + 1;
        end

        // Test case 1: Reset test
        $display("Running: Reset test");
        apply_test(1, 1, 1, 1'b0);

        // Test case 2: Enable test with d=1
        $display("Running: Enable test (d=1)");
        apply_test(0, 1, 1, 1'b1);

        // Test case 3: Enable test with d=0
        $display("Running: Enable test (d=0)");
        apply_test(0, 1, 0, 1'b0);

        // Test case 4: Disable test (q should hold previous value, which is 0)
        $display("Running: Disable test");
        apply_test(0, 0, 1, 1'b0);

        // Test case 5: Reset while enabled
        $display("Running: Reset while enabled");
        apply_test(1, 1, 1, 1'b0);

        // Test case 6: Non-edge trigger test (change d mid-cycle, q should not change)
        $display("Running: Non-edge trigger test");
        rst = 0;
        en = 1;
        d = 1;
        @(posedge clk); // q should be 1
        #2; // Change d mid-cycle
        d = 0;
        #3; // Wait before next clock edge
        if (q !== 1'b1) begin
            $display("Error: Non-edge trigger test failed. q = %b, expected 1", q);
            error_count = error_count + 1;
        end

        #10;
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end

endmodule