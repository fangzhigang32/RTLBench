`timescale 1ns/1ps

module tb_decoder_4to16;
    reg [3:0] d;
    wire [15:0] y;

    // Instantiate the Unit Under Test (UUT)
    decoder_4to16 uut (
        .d(d),
        .y(y)
    );

    integer i;
    reg [15:0] expected;
    reg error_flag;

    initial begin
        error_flag = 0;

        // Test all possible valid input combinations
        for (i = 0; i < 16; i = i + 1) begin
            d = i;
            expected = (1 << i);
            #10; // Simulate propagation delay

            if (y !== expected) begin
                $display("Error at time %t, Test case %0d: Input = %b, Output = %b, Expected = %b", 
                         $time, i, d, y, expected);
                error_flag = 1;
            end
        end

        // Test invalid input cases
        // Case 1: All X
        d = 4'bxxxx;
        #10;
        if (y !== 16'b0000000000000000) begin
            $display("Error at time %t, Invalid input case (xxxx): Output = %b, Expected = 0000000000000000", 
                     $time, y);
            error_flag = 1;
        end

        // Case 2: All Z
        d = 4'bzzzz;
        #10;
        if (y !== 16'b0000000000000000) begin
            $display("Error at time %t, Invalid input case (zzzz): Output = %b, Expected = 0000000000000000", 
                     $time, y);
            error_flag = 1;
        end

        // Case 3: Mixed X and valid bits
        d = 4'bx01x;
        #10;
        if (y !== 16'b0000000000000000) begin
            $display("Error at time %t, Invalid input case (x01x): Output = %b, Expected = 0000000000000000", 
                     $time, y);
            error_flag = 1;
        end

        // Test rapid input switching to verify combinational behavior
        d = 4'b1111;
        #5; // Shorter delay to test transient response
        expected = (1 << 15);
        if (y !== expected) begin
            $display("Error at time %t, Rapid switch case (1111): Output = %b, Expected = %b", 
                     $time, y, expected);
            error_flag = 1;
        end
        d = 4'b0000;
        #5;
        expected = (1 << 0);
        if (y !== expected) begin
            $display("Error at time %t, Rapid switch case (0000): Output = %b, Expected = %b", 
                     $time, y, expected);
            error_flag = 1;
        end

        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        $finish;
    end

    // Monitor input and output changes
    initial begin
        $monitor("Time = %t, d = %b, y = %b", $time, d, y);
    end
endmodule