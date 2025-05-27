`timescale 1ns/1ps

module tb_nor_gate;

    // Inputs
    reg a;
    reg b;

    // Output
    wire y;

    // Instantiate the Unit Under Test (UUT)
    nor_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );

    reg error_flag = 0;

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;

        // Wait for global reset
        #100;

        // Test case 1: 0 NOR 0 = 1
        a = 0; b = 0;
        #10;
        if (y !== 1) begin
            $display("Error: a=%b, b=%b, y=%b (expected 1)", a, b, y);
            error_flag = 1;
        end

        // Test case 2: 0 NOR 1 = 0
        a = 0; b = 1;
        #10;
        if (y !== 0) begin
            $display("Error: a=%b, b=%b, y=%b (expected 0)", a, b, y);
            error_flag = 1;
        end

        // Test case 3: 1 NOR 0 = 0
        a = 1; b = 0;
        #10;
        if (y !== 0) begin
            $display("Error: a=%b, b=%b, y=%b (expected 0)", a, b, y);
            error_flag = 1;
        end

        // Test case 4: 1 NOR 1 = 0
        a = 1; b = 1;
        #10;
        if (y !== 0) begin
            $display("Error: a=%b, b=%b, y=%b (expected 0)", a, b, y);
            error_flag = 1;
        end

        // Final result
        if (error_flag == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end

        // Finish simulation
        $finish;
    end

endmodule