`timescale 1ns/1ps

module tb_rs_encoder_15_11();

    // Inputs
    reg [10:0] d;
    
    // Outputs
    wire [14:0] c;
    
    // Instantiate the Unit Under Test (UUT)
    rs_encoder_15_11 uut (
        .d(d),
        .c(c)
    );
    
    // Test cases
    reg [14:0] expected;
    integer i;
    integer error_count;
    
    initial begin
        error_count = 0;
        
        // Test case 1: All zeros
        d = 11'b00000000000;
        expected = 15'b000000000000000;
        #10;
        if (c !== expected) begin
            $display("Error case 1: Input = %b, Output = %b, Expected = %b", d, c, expected);
            error_count = error_count + 1;
        end
        
        // Test case 2: All ones
        d = 11'b11111111111;
        expected = 15'b111111111110100;
        #10;
        if (c !== expected) begin
            $display("Error case 2: Input = %b, Output = %b, Expected = %b", d, c, expected);
            error_count = error_count + 1;
        end
        
        // Test case 3: Alternating pattern
        d = 11'b10101010101;
        expected = 15'b101010101010000;
        #10;
        if (c !== expected) begin
            $display("Error case 3: Input = %b, Output = %b, Expected = %b", d, c, expected);
            error_count = error_count + 1;
        end
        
        // Test case 4: Random pattern 1
        d = 11'b11010010110;
        expected = 15'b110100101100101;
        #10;
        if (c !== expected) begin
            $display("Error case 4: Input = %b, Output = %b, Expected = %b", d, c, expected);
            error_count = error_count + 1;
        end
        
        // Test case 5: Random pattern 2
        d = 11'b00101110101;
        expected = 15'b001011101011100;
        #10;
        if (c !== expected) begin
            $display("Error case 5: Input = %b, Output = %b, Expected = %b", d, c, expected);
            error_count = error_count + 1;
        end
        
        // Summary
        if (error_count == 0) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end
        $finish;
    end

endmodule