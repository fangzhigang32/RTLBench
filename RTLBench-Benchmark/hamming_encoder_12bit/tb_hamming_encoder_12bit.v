`timescale 1ns/1ps

module tb_hamming_encoder_12bit;

    // Inputs
    reg [7:0] d;
    
    // Outputs
    wire [11:0] c;
    
    // Instantiate the Unit Under Test (UUT)
    hamming_encoder_12bit uut (
        .d(d),
        .c(c)
    );
    
    // Expected output array
    reg [11:0] expected [0:7];
    
    // Error flag
    reg error_flag = 0;
    
    initial begin
        // Initialize expected outputs for test cases
        expected[0] = 12'b000000000000;
        expected[1] = 12'b110010101101;
        expected[2] = 12'b101101010110;
        expected[3] = 12'b111111111111;
        expected[4] = 12'b000100000001;
        expected[5] = 12'b011100000000;
        expected[6] = 12'b100110011011;
        expected[7] = 12'b011001100110;
        
        // Test stimulus
        for (integer i = 0; i < 8; i = i + 1) begin
            case(i)
                0: d = 8'h00;
                1: d = 8'h55;
                2: d = 8'hAA;
                3: d = 8'hFF;
                4: d = 8'h01;
                5: d = 8'h80;
                6: d = 8'h33;
                7: d = 8'hCC;
            endcase
            
            #10; // Wait for propagation
            
            if (c !== expected[i]) begin
                error_flag = 1;
                $display("Test case %0d failed: Input = 8'h%02h", i, d);
                $display("  Expected: 12'b%012b", expected[i]);
                $display("  Got:      12'b%012b", c);
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