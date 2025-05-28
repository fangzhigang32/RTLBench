`timescale 1ns/1ps

module tb_hamming_decoder_12bit;

    // Inputs
    reg [11:0] c;
    
    // Outputs
    wire [7:0] d;
    wire err;
    
    // Instantiate the Unit Under Test (UUT)
    hamming_decoder_12bit uut (
        .c(c),
        .d(d),
        .err(err)
    );
    
    integer i;
    reg [7:0] expected_d;
    reg expected_err;
    reg all_passed;
    
    initial begin
        all_passed = 1; // Assume all tests pass initially
        
        // Test case 1: No error
        c = 12'b101010101010;
        expected_d = 8'b10101010;
        expected_err = 0;
        #10;
        if (d !== expected_d || err !== expected_err) begin
            $display("Test case 1 failed: Input=%b, Output d=%b (expected %b), err=%b (expected %b)", 
                     c, d, expected_d, err, expected_err);
            all_passed = 0;
        end
        
        // Test case 2: Single-bit error (bit 0 flipped)
        c = 12'b001010101010;
        expected_d = 8'b10101010;
        expected_err = 1;
        #10;
        if (d !== expected_d || err !== expected_err) begin
            $display("Test case 2 failed: Input=%b, Output d=%b (expected %b), err=%b (expected %b)", 
                     c, d, expected_d, err, expected_err);
            all_passed = 0;
        end
        
        // Test case 3: Single-bit error (bit 5 flipped)
        c = 12'b101010101110;
        expected_d = 8'b10101010;
        expected_err = 1;
        #10;
        if (d !== expected_d || err !== expected_err) begin
            $display("Test case 3 failed: Input=%b, Output d=%b (expected %b), err=%b (expected %b)", 
                     c, d, expected_d, err, expected_err);
            all_passed = 0;
        end
        
        // Test case 4: Single-bit error (bit 11 flipped)
        c = 12'b101010101011;
        expected_d = 8'b10101011;
        expected_err = 1;
        #10;
        if (d !== expected_d || err !== expected_err) begin
            $display("Test case 4 failed: Input=%b, Output d=%b (expected %b), err=%b (expected %b)", 
                     c, d, expected_d, err, expected_err);
            all_passed = 0;
        end
        
        // Test case 5: Two-bit error (should not be correctable)
        c = 12'b001010101110;
        expected_d = 8'b10101010; // Note: This will be incorrect for 2-bit errors
        expected_err = 1;
        #10;
        if (d !== expected_d || err !== expected_err) begin
            $display("Test case 5 failed: Input=%b, Output d=%b (expected %b), err=%b (expected %b)", 
                     c, d, expected_d, err, expected_err);
            all_passed = 0;
        end
        
        // Test case 6: All zeros
        c = 12'b000000000000;
        expected_d = 8'b00000000;
        expected_err = 0;
        #10;
        if (d !== expected_d || err !== expected_err) begin
            $display("Test case 6 failed: Input=%b, Output d=%b (expected %b), err=%b (expected %b)", 
                     c, d, expected_d, err, expected_err);
            all_passed = 0;
        end
        
        // Test case 7: All ones
        c = 12'b111111111111;
        expected_d = 8'b11111111;
        expected_err = 0;
        #10;
        if (d !== expected_d || err !== expected_err) begin
            $display("Test case 7 failed: Input=%b, Output d=%b (expected %b), err=%b (expected %b)", 
                     c, d, expected_d, err, expected_err);
            all_passed = 0;
        end
        
        // Final result
        if (all_passed) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        
        $finish;
    end

endmodule