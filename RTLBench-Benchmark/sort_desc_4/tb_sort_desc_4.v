`timescale 1ns/1ps

module tb_sort_desc_4;

    // Inputs
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;

    // Outputs
    wire [3:0] ra;
    wire [3:0] rb;
    wire [3:0] rc;
    wire [3:0] rd;

    // Instantiate the Unit Under Test (UUT)
    sort_desc_4 uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .ra(ra),
        .rb(rb),
        .rc(rc),
        .rd(rd)
    );

    integer i;
    reg [3:0] expected [0:3];
    reg error_flag;

    initial begin
        error_flag = 0;

        // Test case 1: Random values
        a = 4'd5; b = 4'd2; c = 4'd8; d = 4'd3;
        expected[0] = 4'd8; expected[1] = 4'd5; expected[2] = 4'd3; expected[3] = 4'd2;
        #10;
        if (ra !== expected[0] || rb !== expected[1] || rc !== expected[2] || rd !== expected[3]) begin
            $display("Error Case 1: Inputs a=%0d, b=%0d, c=%0d, d=%0d", a, b, c, d);
            $display("  Expected: ra=%0d, rb=%0d, rc=%0d, rd=%0d", expected[0], expected[1], expected[2], expected[3]);
            $display("  Got:      ra=%0d, rb=%0d, rc=%0d, rd=%0d", ra, rb, rc, rd);
            error_flag = 1;
        end

        // Test case 2: All equal values
        a = 4'd7; b = 4'd7; c = 4'd7; d = 4'd7;
        expected[0] = 4'd7; expected[1] = 4'd7; expected[2] = 4'd7; expected[3] = 4'd7;
        #10;
        if (ra !== expected[0] || rb !== expected[1] || rc !== expected[2] || rd !== expected[3]) begin
            $display("Error Case 2: Inputs a=%0d, b=%0d, c=%0d, d=%0d", a, b, c, d);
            $display("  Expected: ra=%0d, rb=%0d, rc=%0d, rd=%0d", expected[0], expected[1], expected[2], expected[3]);
            $display("  Got:      ra=%0d, rb=%0d, rc=%0d, rd=%0d", ra, rb, rc, rd);
            error_flag = 1;
        end

        // Test case 3: Already sorted descending
        a = 4'd9; b = 4'd6; c = 4'd4; d = 4'd1;
        expected[0] = 4'd9; expected[1] = 4'd6; expected[2] = 4'd4; expected[3] = 4'd1;
        #10;
        if (ra !== expected[0] || rb !== expected[1] || rc !== expected[2] || rd !== expected[3]) begin
            $display("Error Case 3: Inputs a=%0d, b=%0d, c=%0d, d=%0d", a, b, c, d);
            $display("  Expected: ra=%0d, rb=%0d, rc=%0d, rd=%0d", expected[0], expected[1], expected[2], expected[3]);
            $display("  Got:      ra=%0d, rb=%0d, rc=%0d, rd=%0d", ra, rb, rc, rd);
            error_flag = 1;
        end

        // Test case 4: Random values with duplicates
        a = 4'd3; b = 4'd5; c = 4'd3; d = 4'd0;
        expected[0] = 4'd5; expected[1] = 4'd3; expected[2] = 4'd3; expected[3] = 4'd0;
        #10;
        if (ra !== expected[0] || rb !== expected[1] || rc !== expected[2] || rd !== expected[3]) begin
            $display("Error Case 4: Inputs a=%0d, b=%0d, c=%0d, d=%0d", a, b, c, d);
            $display("  Expected: ra=%0d, rb=%0d, rc=%0d, rd=%0d", expected[0], expected[1], expected[2], expected[3]);
            $display("  Got:      ra=%0d, rb=%0d, rc=%0d, rd=%0d", ra, rb, rc, rd);
            error_flag = 1;
        end

        // Test case 5: Minimum and maximum values
        a = 4'd0; b = 4'd15; c = 4'd0; d = 4'd15;
        expected[0] = 4'd15; expected[1] = 4'd15; expected[2] = 4'd0; expected[3] = 4'd0;
        #10;
        if (ra !== expected[0] || rb !== expected[1] || rc !== expected[2] || rd !== expected[3]) begin
            $display("Error Case 5: Inputs a=%0d, b=%0d, c=%0d, d=%0d", a, b, c, d);
            $display("  Expected: ra=%0d, rb=%0d, rc=%0d, rd=%0d", expected[0], expected[1], expected[2], expected[3]);
            $display("  Got:      ra=%0d, rb=%0d, rc=%0d, rd=%0d", ra, rb, rc, rd);
            error_flag = 1;
        end

        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end

        $finish;
    end

endmodule