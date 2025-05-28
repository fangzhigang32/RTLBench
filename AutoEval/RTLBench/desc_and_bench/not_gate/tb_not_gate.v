`timescale 1ns/1ps

module tb_not_gate;

    // Inputs
    reg a;

    // Outputs
    wire y;

    // Instantiate the Unit Under Test (UUT)
    not_gate uut (
        .a(a),
        .y(y)
    );

    reg error_flag = 0;

    initial begin
        // Initialize Inputs
        a = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Stimulus and verification
        a = 0;
        #10;
        if (y !== 1'b1) begin
            $display("Error: a=%b, y=%b (expected: 1)", a, y);
            error_flag = 1;
        end

        a = 1;
        #10;
        if (y !== 1'b0) begin
            $display("Error: a=%b, y=%b (expected: 0)", a, y);
            error_flag = 1;
        end

        // Final result
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end

        // End simulation
        $finish;
    end

endmodule