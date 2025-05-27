`timescale 1ns/1ps

module tb_full_subtractor;

    // Inputs
    reg a;
    reg b;
    reg bin;

    // Outputs
    wire d;
    wire bout;

    // Instantiate the Unit Under Test (UUT)
    full_subtractor uut (
        .a(a),
        .b(b),
        .bin(bin),
        .d(d),
        .bout(bout)
    );

    reg error_flag = 0;

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        bin = 0;

        // Wait for global reset
        #100;

        // Test case 1: 0 - 0 - 0
        a = 0; b = 0; bin = 0;
        #10;
        if (d !== 0 || bout !== 0) begin
            $display("Error case 1: a=%b, b=%b, bin=%b, d=%b (expected 0), bout=%b (expected 0)", 
                     a, b, bin, d, bout);
            error_flag = 1;
        end

        // Test case 2: 0 - 0 - 1
        a = 0; b = 0; bin = 1;
        #10;
        if (d !== 1 || bout !== 1) begin
            $display("Error case 2: a=%b, b=%b, bin=%b, d=%b (expected 1), bout=%b (expected 1)", 
                     a, b, bin, d, bout);
            error_flag = 1;
        end

        // Test case 3: 0 - 1 - 0
        a = 0; b = 1; bin = 0;
        #10;
        if (d !== 1 || bout !== 1) begin
            $display("Error case 3: a=%b, b=%b, bin=%b, d=%b (expected 1), bout=%b (expected 1)", 
                     a, b, bin, d, bout);
            error_flag = 1;
        end

        // Test case 4: 0 - 1 - 1
        a = 0; b = 1; bin = 1;
        #10;
        if (d !== 0 || bout !== 1) begin
            $display("Error case 4: a=%b, b=%b, bin=%b, d=%b (expected 0), bout=%b (expected 1)", 
                     a, b, bin, d, bout);
            error_flag = 1;
        end

        // Test case 5: 1 - 0 - 0
        a = 1; b = 0; bin = 0;
        #10;
        if (d !== 1 || bout !== 0) begin
            $display("Error case 5: a=%b, b=%b, bin=%b, d=%b (expected 1), bout=%b (expected 0)", 
                     a, b, bin, d, bout);
            error_flag = 1;
        end

        // Test case 6: 1 - 0 - 1
        a = 1; b = 0; bin = 1;
        #10;
        if (d !== 0 || bout !== 0) begin
            $display("Error case 6: a=%b, b=%b, bin=%b, d=%b (expected 0), bout=%b (expected 0)", 
                     a, b, bin, d, bout);
            error_flag = 1;
        end

        // Test case 7: 1 - 1 - 0
        a = 1; b = 1; bin = 0;
        #10;
        if (d !== 0 || bout !== 0) begin
            $display("Error case 7: a=%b, b=%b, bin=%b, d=%b (expected 0), bout=%b (expected 0)", 
                     a, b, bin, d, bout);
            error_flag = 1;
        end

        // Test case 8: 1 - 1 - 1
        a = 1; b = 1; bin = 1;
        #10;
        if (d !== 1 || bout !== 1) begin
            $display("Error case 8: a=%b, b=%b, bin=%b, d=%b (expected 1), bout=%b (expected 1)", 
                     a, b, bin, d, bout);
            error_flag = 1;
        end

        // Final result
        if (error_flag == 0) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end

        // Finish simulation
        $finish;
    end

endmodule