`timescale 1ns/1ps

module tb_half_subtractor;

    // Inputs
    reg a;
    reg b;

    // Outputs
    wire d;
    wire bout;

    // Instantiate the Unit Under Test (UUT)
    half_subtractor uut (
        .a(a),
        .b(b),
        .d(d),
        .bout(bout)
    );

    reg error_flag = 0;

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Test case 1: 0 - 0
        a = 0; b = 0;
        #10;
        if (d !== 0 || bout !== 0) begin
            $display("Error at 0-0: d=%b, bout=%b (expected d=0, bout=0)", d, bout);
            error_flag = 1;
        end

        // Test case 2: 0 - 1
        a = 0; b = 1;
        #10;
        if (d !== 1 || bout !== 1) begin
            $display("Error at 0-1: d=%b, bout=%b (expected d=1, bout=1)", d, bout);
            error_flag = 1;
        end

        // Test case 3: 1 - 0
        a = 1; b = 0;
        #10;
        if (d !== 1 || bout !== 0) begin
            $display("Error at 1-0: d=%b, bout=%b (expected d=1, bout=0)", d, bout);
            error_flag = 1;
        end

        // Test case 4: 1 - 1
        a = 1; b = 1;
        #10;
        if (d !== 0 || bout !== 0) begin
            $display("Error at 1-1: d=%b, bout=%b (expected d=0, bout=0)", d, bout);
            error_flag = 1;
        end

        // Final status output
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end

        // Finish simulation
        $finish;
    end

endmodule