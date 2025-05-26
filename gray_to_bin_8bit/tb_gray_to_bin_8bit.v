`timescale 1ns/1ps

module tb_gray_to_bin_8bit;

    // Inputs
    reg [7:0] g;
    
    // Outputs
    wire [7:0] b;
    
    // Instantiate the Unit Under Test (UUT)
    gray_to_bin_8bit uut (
        .g(g),
        .b(b)
    );
    
    integer i;
    reg [7:0] expected_b;
    reg test_failed;
    
    initial begin
        // Initialize
        g = 0;
        test_failed = 0;
        
        // Wait for global reset
        #100;
        
        // Test all possible 8-bit Gray code inputs
        for (i = 0; i < 256; i = i + 1) begin
            g = i;
            #10;
            
            // Calculate expected binary output
            expected_b[7] = g[7];
            expected_b[6] = g[6] ^ expected_b[7];
            expected_b[5] = g[5] ^ expected_b[6];
            expected_b[4] = g[4] ^ expected_b[5];
            expected_b[3] = g[3] ^ expected_b[4];
            expected_b[2] = g[2] ^ expected_b[3];
            expected_b[1] = g[1] ^ expected_b[2];
            expected_b[0] = g[0] ^ expected_b[1];
            
            // Check output against expected value
            if (b !== expected_b) begin
                $display("Error: g=%b, b=%b, expected_b=%b", g, b, expected_b);
                test_failed = 1;
            end
        end
        
        // Final result
        if (test_failed) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        $finish;
    end

endmodule