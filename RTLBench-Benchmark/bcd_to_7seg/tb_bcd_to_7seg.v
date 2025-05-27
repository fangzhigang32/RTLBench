`timescale 1ns/1ps

module tb_bcd_to_7seg;

    // Inputs
    reg [3:0] d;
    
    // Outputs
    wire [6:0] seg;
    
    // Instantiate the Unit Under Test (UUT)
    bcd_to_7seg uut (
        .d(d),
        .seg(seg)
    );
    
    // Expected output patterns (active low)
    reg [6:0] expected_seg [0:15];
    initial begin
        expected_seg[0]  = 7'b1000000; // 0
        expected_seg[1]  = 7'b1111001; // 1
        expected_seg[2]  = 7'b0100100; // 2
        expected_seg[3]  = 7'b0110000; // 3
        expected_seg[4]  = 7'b0011001; // 4
        expected_seg[5]  = 7'b0010010; // 5
        expected_seg[6]  = 7'b0000010; // 6
        expected_seg[7]  = 7'b1111000; // 7
        expected_seg[8]  = 7'b0000000; // 8
        expected_seg[9]  = 7'b0010000; // 9
        expected_seg[10] = 7'b1111111; // 10-15: blank
        expected_seg[11] = 7'b1111111;
        expected_seg[12] = 7'b1111111;
        expected_seg[13] = 7'b1111111;
        expected_seg[14] = 7'b1111111;
        expected_seg[15] = 7'b1111111;
    end
    
    integer i;
    reg test_pass;
    integer error_count;
    
    initial begin
        // Initialize inputs
        d = 4'b0000;
        test_pass = 1'b1;
        error_count = 0;
        
        // Wait for initial stabilization
        #10;
        
        // Test all possible input combinations
        for (i = 0; i < 16; i = i + 1) begin
            d = i;
            #10; // Wait for output to stabilize
            
            if (seg !== expected_seg[i]) begin
                $display("Error: d = %0d (binary %b), seg = %b, expected = %b", 
                         i, d, seg, expected_seg[i]);
                test_pass = 1'b0;
                error_count = error_count + 1;
            end
        end
        
        // Final result
        if (test_pass) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        
        $finish;
    end

endmodule