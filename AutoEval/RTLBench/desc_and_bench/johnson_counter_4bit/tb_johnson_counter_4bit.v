`timescale 1ns/1ps

module tb_johnson_counter_4bit;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [3:0] q;

    // Instantiate the Unit Under Test (UUT)
    johnson_counter_4bit uut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Expected Johnson counter sequence
    reg [3:0] expected_q [0:7];
    initial begin
        expected_q[0] = 4'b0000;
        expected_q[1] = 4'b1000;
        expected_q[2] = 4'b1100;
        expected_q[3] = 4'b1110;
        expected_q[4] = 4'b1111;
        expected_q[5] = 4'b0111;
        expected_q[6] = 4'b0011;
        expected_q[7] = 4'b0001;
    end

    integer i;
    reg test_failed;

    initial begin
        // Initialize Inputs
        rst = 1;
        test_failed = 0;

        // Wait for global reset
        #10;
        rst = 0;

        // Verify Johnson counter sequence
        for (i = 0; i < 8; i = i + 1) begin
            #10; // Wait for next clock edge
            if (q !== expected_q[i]) begin
                $display("Error at step %0d: Input rst=%b, Output q=%b, Expected q=%b", 
                         i, rst, q, expected_q[i]);
                test_failed = 1;
            end
        end

        // Test reset functionality
        rst = 1;
        #10;
        if (q !== 4'b0000) begin
            $display("Reset test failed: Input rst=%b, Output q=%b, Expected q=0000", 
                     rst, q);
            test_failed = 1;
        end

        // Print final test result
        if (test_failed) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end

        $finish;
    end

endmodule