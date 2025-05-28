`timescale 1ns/1ps

module tb_mux_2to1_32bit;

    // Inputs
    reg [31:0] d0;
    reg [31:0] d1;
    reg sel;

    // Output
    wire [31:0] y;

    // Instantiate the Unit Under Test (UUT)
    mux_2to1_32bit uut (
        .d0(d0),
        .d1(d1),
        .sel(sel),
        .y(y)
    );

    reg error_flag = 0;

    initial begin
        // Initialize Inputs
        d0 = 32'h00000000;
        d1 = 32'h00000000;
        sel = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Test Case 1: sel=0, d0=0xAAAAAAAA, d1=0x55555555
        d0 = 32'hAAAAAAAA;
        d1 = 32'h55555555;
        sel = 0;
        #10;
        if (y !== d0) begin
            $display("Error: Test Case 1 failed. Input: d0=%h, d1=%h, sel=%b | Output: %h | Expected: %h", d0, d1, sel, y, d0);
            error_flag = 1;
        end

        // Test Case 2: sel=1, d0=0xAAAAAAAA, d1=0x55555555
        sel = 1;
        #10;
        if (y !== d1) begin
            $display("Error: Test Case 2 failed. Input: d0=%h, d1=%h, sel=%b | Output: %h | Expected: %h", d0, d1, sel, y, d1);
            error_flag = 1;
        end

        // Test Case 3: sel=0, d0=0x12345678, d1=0x87654321
        d0 = 32'h12345678;
        d1 = 32'h87654321;
        sel = 0;
        #10;
        if (y !== d0) begin
            $display("Error: Test Case 3 failed. Input: d0=%h, d1=%h, sel=%b | Output: %h | Expected: %h", d0, d1, sel, y, d0);
            error_flag = 1;
        end

        // Test Case 4: sel=1, d0=0x12345678, d1=0x87654321
        sel = 1;
        #10;
        if (y !== d1) begin
            $display("Error: Test Case 4 failed. Input: d0=%h, d1=%h, sel=%b | Output: %h | Expected: %h", d0, d1, sel, y, d1);
            error_flag = 1;
        end

        // Test Case 5: sel=0, d0=32'hFFFFFFFF, d1=32'h00000000
        d0 = 32'hFFFFFFFF;
        d1 = 32'h00000000;
        sel = 0;
        #10;
        if (y !== d0) begin
            $display("Error: Test Case 5 failed. Input: d0=%h, d1=%h, sel=%b | Output: %h | Expected: %h", d0, d1, sel, y, d0);
            error_flag = 1;
        end

        // Test Case 6: sel=1, d0=32'hFFFFFFFF, d1=32'h00000000
        sel = 1;
        #10;
        if (y !== d1) begin
            $display("Error: Test Case 6 failed. Input: d0=%h, d1=%h, sel=%b | Output: %h | Expected: %h", d0, d1, sel, y, d1);
            error_flag = 1;
        end

        // Final Summary
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end

        $finish;
    end

endmodule