`timescale 1ns/1ps

module tb_unsigned_divider_8bit;

    // Inputs
    reg [7:0] a;
    reg [7:0] b;

    // Outputs
    wire [7:0] q;
    wire [7:0] r;

    // Instantiate the Unit Under Test (UUT)
    unsigned_divider_8bit uut (
        .a(a),
        .b(b),
        .q(q),
        .r(r)
    );

    integer i;
    reg [7:0] expected_q;
    reg [7:0] expected_r;
    reg error_flag;

    initial begin
        error_flag = 0;

        // Test case 1: Normal division
        a = 8'd100;
        b = 8'd25;
        expected_q = 8'd4;
        expected_r = 8'd0;
        #10;
        if (q !== expected_q || r !== expected_r) begin
            $display("Error: a=%d, b=%d, q=%d (expected %d), r=%d (expected %d)", 
                     a, b, q, expected_q, r, expected_r);
            error_flag = 1;
        end

        // Test case 2: Division with remainder
        a = 8'd57;
        b = 8'd10;
        expected_q = 8'd5;
        expected_r = 8'd7;
        #10;
        if (q !== expected_q || r !== expected_r) begin
            $display("Error: a=%d, b=%d, q=%d (expected %d), r=%d (expected %d)", 
                     a, b, q, expected_q, r, expected_r);
            error_flag = 1;
        end

        // Test case 3: Division by zero
        a = 8'd100;
        b = 8'd0;
        expected_q = 8'hFF;
        expected_r = 8'hFF;
        #10;
        if (q !== expected_q || r !== expected_r) begin
            $display("Error: a=%d, b=%d, q=%d (expected %d), r=%d (expected %d)", 
                     a, b, q, expected_q, r, expected_r);
            error_flag = 1;
        end

        // Test case 4: Random test cases
        for (i = 0; i < 10; i = i + 1) begin
            a = $random;
            b = $random % 8'd255 + 1; // Avoid division by zero
            expected_q = a / b;
            expected_r = a % b;
            #10;
            if (q !== expected_q || r !== expected_r) begin
                $display("Error: a=%d, b=%d, q=%d (expected %d), r=%d (expected %d)", 
                         a, b, q, expected_q, r, expected_r);
                error_flag = 1;
            end
        end

        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end

        $finish;
    end

endmodule