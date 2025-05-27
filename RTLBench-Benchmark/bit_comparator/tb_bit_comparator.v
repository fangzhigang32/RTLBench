`timescale 1ns/1ps

module tb_bit_comparator;

    // Inputs
    reg a;
    reg b;

    // Outputs - changed to 3-bit to match UUT
    wire [2:0] gt;
    wire [2:0] eq;
    wire [2:0] lt;

    // Test counters
    integer pass_count = 0;
    integer fail_count = 0;
    integer error_flag = 0;

    // Instantiate the Unit Under Test (UUT)
    bit_comparator uut (
        .a(a),
        .b(b),
        .gt(gt),
        .eq(eq),
        .lt(lt)
    );

    // Task to check output and report result
    task check_output;
        input reg test_a, test_b;
        input [2:0] exp_gt, exp_eq, exp_lt;
        input integer test_num;
        begin
            a = test_a;
            b = test_b;
            #10; // Wait for propagation delay

            // Check for undefined or high-impedance states
            if (gt === 3'bx || gt === 3'bz || eq === 3'bx || eq === 3'bz || lt === 3'bx || lt === 3'bz) begin
                $display("Error in Test %0d: a=%b, b=%b, outputs contain X or Z (gt=%b, eq=%b, lt=%b)",
                         test_num, a, b, gt, eq, lt);
                fail_count = fail_count + 1;
                error_flag = 1;
            end
            else if (gt !== exp_gt || eq !== exp_eq || lt !== exp_lt) begin
                $display("Error in Test %0d: a=%b, b=%b, gt=%b (exp:%b), eq=%b (exp:%b), lt=%b (exp:%b)",
                         test_num, a, b, gt, exp_gt, eq, exp_eq, lt, exp_lt);
                fail_count = fail_count + 1;
                error_flag = 1;
            end
            else begin
                pass_count = pass_count + 1;
            end
        end
    endtask

    initial begin
        // Test case 1: a=0, b=0
        check_output(0, 0, 3'b000, 3'b111, 3'b000, 1);

        // Test case 2: a=0, b=1
        check_output(0, 1, 3'b000, 3'b000, 3'b111, 2);

        // Test case 3: a=1, b=0
        check_output(1, 0, 3'b111, 3'b000, 3'b000, 3);

        // Test case 4: a=1, b=1
        check_output(1, 1, 3'b000, 3'b111, 3'b000, 4);

        // Final output
        if (error_flag == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end

        // Finish simulation
        $finish;
    end

endmodule