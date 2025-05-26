`timescale 1ns/1ps

module tb_mux_4to1_32bit;

    // Inputs
    reg [31:0] d0;
    reg [31:0] d1;
    reg [31:0] d2;
    reg [31:0] d3;
    reg [1:0]  sel;

    // Output
    wire [31:0] y;

    // Instantiate the Unit Under Test (UUT)
    mux_4to1_32bit uut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );

    reg error_flag = 0;

    initial begin
        // Initialize Inputs
        d0 = 32'h00000000;
        d1 = 32'h00000000;
        d2 = 32'h00000000;
        d3 = 32'h00000000;
        sel = 2'b00;

        // Wait 100 ns for global reset to finish
        #100;

        // Test case 1: Select d0
        d0 = 32'hAAAAAAAA;
        d1 = 32'hBBBBBBBB;
        d2 = 32'hCCCCCCCC;
        d3 = 32'hDDDDDDDD;
        sel = 2'b00;
        #10;
        if (y !== d0) begin
            $display("Error: Test case 1 failed - Input: sel=%b, Output: %h, Expected: %h", sel, y, d0);
            error_flag = 1;
        end

        // Test case 2: Select d1
        sel = 2'b01;
        #10;
        if (y !== d1) begin
            $display("Error: Test case 2 failed - Input: sel=%b, Output: %h, Expected: %h", sel, y, d1);
            error_flag = 1;
        end

        // Test case 3: Select d2
        sel = 2'b10;
        #10;
        if (y !== d2) begin
            $display("Error: Test case 3 failed - Input: sel=%b, Output: %h, Expected: %h", sel, y, d2);
            error_flag = 1;
        end

        // Test case 4: Select d3
        sel = 2'b11;
        #10;
        if (y !== d3) begin
            $display("Error: Test case 4 failed - Input: sel=%b, Output: %h, Expected: %h", sel, y, d3);
            error_flag = 1;
        end

        // Test case 5: Change inputs with same select
        d0 = 32'h11111111;
        d1 = 32'h22222222;
        d2 = 32'h33333333;
        d3 = 32'h44444444;
        sel = 2'b10;
        #10;
        if (y !== d2) begin
            $display("Error: Test case 5 failed - Input: sel=%b, Output: %h, Expected: %h", sel, y, d2);
            error_flag = 1;
        end

        // All tests completed
        #10;
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        $finish;
    end

endmodule