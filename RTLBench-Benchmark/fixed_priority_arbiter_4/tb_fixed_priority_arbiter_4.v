`timescale 1ns/1ps

module tb_fixed_priority_arbiter_4;

    // Inputs
    reg [3:0] req;

    // Outputs
    wire [3:0] gnt;

    // Instantiate the Unit Under Test (UUT)
    fixed_priority_arbiter_4 uut (
        .req(req),
        .gnt(gnt)
    );

    integer i;
    reg [3:0] expected_gnt;
    reg all_tests_passed;

    initial begin
        // Initialize Inputs
        req = 4'b0000;
        all_tests_passed = 1'b1;

        // Wait 100 ns for global reset to finish
        #100;

        // Test all possible input combinations
        for (i = 0; i < 16; i = i + 1) begin
            req = i;
            #10;

            // Calculate expected output
            expected_gnt[3] = req[3];
            expected_gnt[2] = ~req[3] & req[2];
            expected_gnt[1] = ~req[3] & ~req[2] & req[1];
            expected_gnt[0] = ~req[3] & ~req[2] & ~req[1] & req[0];

            // Check output
            if (gnt !== expected_gnt) begin
                $display("Error at time %0t: req = %b, gnt = %b, expected gnt = %b", 
                         $time, req, gnt, expected_gnt);
                all_tests_passed = 1'b0;
            end
        end

        // Final result
        if (all_tests_passed) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end

        $finish;
    end

endmodule