`timescale 1ns/1ps

module tb_tmr_voter_8bit;

    // Inputs
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;

    // Outputs
    wire [7:0] y;
    wire       err;

    // Instantiate the Unit Under Test (UUT)
    tmr_voter_8bit uut (
        .a(a),
        .b(b),
        .c(c),
        .y(y),
        .err(err)
    );

    integer i;
    reg [7:0] expected_y;
    reg expected_err;
    reg error_flag;

    initial begin
        error_flag = 0;

        // Test case 1: All inputs equal
        a = 8'hAA;
        b = 8'hAA;
        c = 8'hAA;
        #10;
        expected_y = 8'hAA;
        expected_err = 0;
        if (y !== expected_y || err !== expected_err) begin
            $display("Error in Test case 1: a=%h, b=%h, c=%h, y=%h (expected %h), err=%b (expected %b)", 
                     a, b, c, y, expected_y, err, expected_err);
            error_flag = 1;
        end

        // Test case 2: Single bit error in one input
        a = 8'h55;
        b = 8'h55;
        c = 8'h54;
        #10;
        expected_y = 8'h55;
        expected_err = 1;
        if (y !== expected_y || err !== expected_err) begin
            $display("Error in Test case 2: a=%h, b=%h, c=%h, y=%h (expected %h), err=%b (expected %b)", 
                     a, b, c, y, expected_y, err, expected_err);
            error_flag = 1;
        end

        // Test case 3: Multiple bit errors
        a = 8'h0F;
        b = 8'hF0;
        c = 8'hFF;
        #10;
        expected_y = 8'hFF;
        expected_err = 1;
        if (y !== expected_y || err !== expected_err) begin
            $display("Error in Test case 3: a=%h, b=%h, c=%h, y=%h (expected %h), err=%b (expected %b)", 
                     a, b, c, y, expected_y, err, expected_err);
            error_flag = 1;
        end

        // Test case 4: Random test cases
        for (i = 0; i < 10; i = i + 1) begin
            a = $random;
            b = $random;
            c = $random;
            #10;
            
            // Calculate expected outputs
            expected_y[0] = (a[0] & b[0]) | (a[0] & c[0]) | (b[0] & c[0]);
            expected_y[1] = (a[1] & b[1]) | (a[1] & c[1]) | (b[1] & c[1]);
            expected_y[2] = (a[2] & b[2]) | (a[2] & c[2]) | (b[2] & c[2]);
            expected_y[3] = (a[3] & b[3]) | (a[3] & c[3]) | (b[3] & c[3]);
            expected_y[4] = (a[4] & b[4]) | (a[4] & c[4]) | (b[4] & c[4]);
            expected_y[5] = (a[5] & b[5]) | (a[5] & c[5]) | (b[5] & c[5]);
            expected_y[6] = (a[6] & b[6]) | (a[6] & c[6]) | (b[6] & c[6]);
            expected_y[7] = (a[7] & b[7]) | (a[7] & c[7]) | (b[7] & c[7]);
            expected_err = (a != b) | (b != c) | (a != c);
            
            if (y !== expected_y || err !== expected_err) begin
                $display("Error in Random Test case %0d: a=%h, b=%h, c=%h, y=%h (expected %h), err=%b (expected %b)", 
                         i, a, b, c, y, expected_y, err, expected_err);
                error_flag = 1;
            end
        end

        if (error_flag) begin
            $display("Exist Function Error");
        end
        else begin
            $display("No Function Error");
        end
        $finish;
    end

endmodule