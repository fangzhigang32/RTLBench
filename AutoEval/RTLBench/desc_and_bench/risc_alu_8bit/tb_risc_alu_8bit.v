`timescale 1ns/1ps

module tb_risc_alu_8bit;

    // Inputs
    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] op;

    // Outputs
    wire [7:0] y;
    wire z;
    wire n;
    wire c;
    wire v;

    // Instantiate the Unit Under Test (UUT)
    risc_alu_8bit uut (
        .a(a),
        .b(b),
        .op(op),
        .y(y),
        .z(z),
        .n(n),
        .c(c),
        .v(v)
    );

    integer i;
    reg [7:0] expected_y;
    reg expected_z;
    reg expected_n;
    reg expected_c;
    reg expected_v;
    reg all_tests_pass;
    reg [8:0] temp_sub; // Moved declaration to module level

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        op = 0;
        all_tests_pass = 1;
        temp_sub = 0; // Initialize temp_sub

        // Wait for global reset
        #100;

        // Test case 1: Addition
        op = 3'b000;
        a = 8'h12;
        b = 8'h34;
        expected_y = a + b;
        expected_z = (expected_y == 0);
        expected_n = expected_y[7];
        expected_c = (a + b) > 255;
        expected_v = (~a[7] & ~b[7] & expected_y[7]) | (a[7] & b[7] & ~expected_y[7]);
        #10;
        if (y !== expected_y || z !== expected_z || n !== expected_n || c !== expected_c || v !== expected_v) begin
            $display("Error in Addition: a=%h, b=%h, op=%b", a, b, op);
            $display("  Expected: y=%h, z=%b, n=%b, c=%b, v=%b", expected_y, expected_z, expected_n, expected_c, expected_v);
            $display("  Got:      y=%h, z=%b, n=%b, c=%b, v=%b", y, z, n, c, v);
            all_tests_pass = 0;
        end

        // Test case 2: Subtraction
        op = 3'b001;
        a = 8'h55;
        b = 8'h22;
        expected_y = a - b;
        expected_z = (expected_y == 0);
        expected_n = expected_y[7];
        expected_c = a < b;
        expected_v = (a[7] & ~b[7] & ~expected_y[7]) | (~a[7] & b[7] & expected_y[7]);
        #10;
        if (y !== expected_y || z !== expected_z || n !== expected_n || c !== expected_c || v !== expected_v) begin
            $display("Error in Subtraction: a=%h, b=%h, op=%b", a, b, op);
            $display("  Expected: y=%h, z=%b, n=%b, c=%b, v=%b", expected_y, expected_z, expected_n, expected_c, expected_v);
            $display("  Got:      y=%h, z=%b, n=%b, c=%b, v=%b", y, z, n, c, v);
            all_tests_pass = 0;
        end

        // Test case 3: AND
        op = 3'b010;
        a = 8'hAA;
        b = 8'h55;
        expected_y = a & b;
        expected_z = (expected_y == 0);
        expected_n = expected_y[7];
        expected_c = 0;
        expected_v = 0;
        #10;
        if (y !== expected_y || z !== expected_z || n !== expected_n || c !== expected_c || v !== expected_v) begin
            $display("Error in AND: a=%h, b=%h, op=%b", a, b, op);
            $display("  Expected: y=%h, z=%b, n=%b, c=%b, v=%b", expected_y, expected_z, expected_n, expected_c, expected_v);
            $display("  Got:      y=%h, z=%b, n=%b, c=%b, v=%b", y, z, n, c, v);
            all_tests_pass = 0;
        end

        // Test case 4: OR
        op = 3'b011;
        a = 8'hAA;
        b = 8'h55;
        expected_y = a | b;
        expected_z = (expected_y == 0);
        expected_n = expected_y[7];
        expected_c = 0;
        expected_v = 0;
        #10;
        if (y !== expected_y || z !== expected_z || n !== expected_n || c !== expected_c || v !== expected_v) begin
            $display("Error in OR: a=%h, b=%h, op=%b", a, b, op);
            $display("  Expected: y=%h, z=%b, n=%b, c=%b, v=%b", expected_y, expected_z, expected_n, expected_c, expected_v);
            $display("  Got:      y=%h, z=%b, n=%b, c=%b, v=%b", y, z, n, c, v);
            all_tests_pass = 0;
        end

        // Test case 5: XOR
        op = 3'b100;
        a = 8'hAA;
        b = 8'h55;
        expected_y = a ^ b;
        expected_z = (expected_y == 0);
        expected_n = expected_y[7];
        expected_c = 0;
        expected_v = 0;
        #10;
        if (y !== expected_y || z !== expected_z || n !== expected_n || c !== expected_c || v !== expected_v) begin
            $display("Error in XOR: a=%h, b=%h, op=%b", a, b, op);
            $display("  Expected: y=%h, z=%b, n=%b, c=%b, v=%b", expected_y, expected_z, expected_n, expected_c, expected_v);
            $display("  Got:      y=%h, z=%b, n=%b, c=%b, v=%b", y, z, n, c, v);
            all_tests_pass = 0;
        end

        // Test case 6: Shift left
        op = 3'b101;
        a = 8'h01;
        b = 8'h02;
        expected_y = a << b[2:0];
        expected_z = (expected_y == 0);
        expected_n = expected_y[7];
        expected_c = 0;
        expected_v = 0;
        #10;
        if (y !== expected_y || z !== expected_z || n !== expected_n || c !== expected_c || v !== expected_v) begin
            $display("Error in Shift left: a=%h, b=%h, op=%b", a, b, op);
            $display("  Expected: y=%h, z=%b, n=%b, c=%b, v=%b", expected_y, expected_z, expected_n, expected_c, expected_v);
            $display("  Got:      y=%h, z=%b, n=%b, c=%b, v=%b", y, z, n, c, v);
            all_tests_pass = 0;
        end

        // Test case 7: Shift right
        op = 3'b110;
        a = 8'h80;
        b = 8'h01;
        expected_y = a >> b[2:0];
        expected_z = (expected_y == 0);
        expected_n = expected_y[7];
        expected_c = 0;
        expected_v = 0;
        #10;
        if (y !== expected_y || z !== expected_z || n !== expected_n || c !== expected_c || v !== expected_v) begin
            $display("Error in Shift right: a=%h, b=%h, op=%b", a, b, op);
            $display("  Expected: y=%h, z=%b, n=%b, c=%b, v=%b", expected_y, expected_z, expected_n, expected_c, expected_v);
            $display("  Got:      y=%h, z=%b, n=%b, c=%b, v=%b", y, z, n, c, v);
            all_tests_pass = 0;
        end

        // Test case 8: Compare
        op = 3'b111;
        a = 8'h50;
        b = 8'h30;
        expected_y = 8'h00;
        expected_z = (a == b);
        expected_n = (a < b);
        expected_c = (a < b);
        begin
            temp_sub = a - b; // Assign value to temp_sub
            expected_v = (a[7] & ~b[7] & ~temp_sub[7]) | (~a[7] & b[7] & temp_sub[7]);
        end
        #10;
        if (y !== expected_y || z !== expected_z || n !== expected_n || c !== expected_c || v !== expected_v) begin
            $display("Error in Compare: a=%h, b=%h, op=%b", a, b, op);
            $display("  Expected: y=%h, z=%b, n=%b, c=%b, v=%b", expected_y, expected_z, expected_n, expected_c, expected_v);
            $display("  Got:      y=%h, z=%b, n=%b, c=%b, v=%b", y, z, n, c, v);
            all_tests_pass = 0;
        end

        // Final result
        if (all_tests_pass) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end

        $finish;
    end

endmodule