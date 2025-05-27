`timescale 1ns/1ps

module tb_bch_encoder_15_11();

reg [10:0] d;
wire [14:0] c;
reg error_flag;

// Instantiate the DUT
bch_encoder_15_11 dut (
    .d(d),
    .c(c)
);

// Expected output calculation function
function [14:0] expected_output;
    input [10:0] data;
    reg [3:0] parity;
    begin
        parity[0] = data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[7] ^ data[8] ^ data[10];
        parity[1] = data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[6] ^ data[7] ^ data[9] ^ data[10];
        parity[2] = data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[8] ^ data[9];
        parity[3] = data[0] ^ data[1] ^ data[2] ^ data[4] ^ data[5] ^ data[7] ^ data[8] ^ data[10];
        expected_output = {parity, data};
    end
endfunction

integer i;
initial begin
    error_flag = 0;

    // Test case 1: All zeros
    d = 11'b00000000000;
    #10;
    if (c !== expected_output(d)) begin
        $display("Error at test case 1: All zeros");
        $display("Input: %b", d);
        $display("Expected: %b, Got: %b", expected_output(d), c);
        error_flag = 1;
    end

    // Test case 2: All ones
    d = 11'b11111111111;
    #10;
    if (c !== expected_output(d)) begin
        $display("Error at test case 2: All ones");
        $display("Input: %b", d);
        $display("Expected: %b, Got: %b", expected_output(d), c);
        error_flag = 1;
    end

    // Test case 3: Alternating bits
    d = 11'b10101010101;
    #10;
    if (c !== expected_output(d)) begin
        $display("Error at test case 3: Alternating bits");
        $display("Input: %b", d);
        $display("Expected: %b, Got: %b", expected_output(d), c);
        error_flag = 1;
    end

    // Test case 4: Random pattern
    d = 11'b11010010110;
    #10;
    if (c !== expected_output(d)) begin
        $display("Error at test case 4: Random pattern");
        $display("Input: %b", d);
        $display("Expected: %b, Got: %b", expected_output(d), c);
        error_flag = 1;
    end

    // Test case 5: Single bit set
    for (i = 0; i < 11; i = i + 1) begin
        d = (1 << i);
        #10;
        if (c !== expected_output(d)) begin
            $display("Error at test case 5: Bit %0d set", i);
            $display("Input: %b", d);
            $display("Expected: %b, Got: %b", expected_output(d), c);
            error_flag = 1;
        end
    end

    // Final check
    if (error_flag) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule