`timescale 1ns/1ps

module tb_decoder_3to8;
    // Inputs
    reg [2:0] d;
    
    // Outputs
    wire [7:0] y;
    
    // Instantiate the Unit Under Test (UUT)
    decoder_3to8 uut (
        .d(d),
        .y(y)
    );
    
    // Test stimulus and verification
    integer error_count = 0;
    
    initial begin
        // Initialize inputs
        d = 3'b000;
        #10;
        
        // Test case 0
        d = 3'b000;
        #10;
        if (y !== 8'b00000001) begin
            $display("Error: Test 0 failed: Input=%b, Output=%b, Expected=00000001", d, y);
            error_count = error_count + 1;
        end
        
        // Test case 1
        d = 3'b001;
        #10;
        if (y !== 8'b00000010) begin
            $display("Error: Test 1 failed: Input=%b, Output=%b, Expected=00000010", d, y);
            error_count = error_count + 1;
        end
        
        // Test case 2
        d = 3'b010;
        #10;
        if (y !== 8'b00000100) begin
            $display("Error: Test 2 failed: Input=%b, Output=%b, Expected=00000100", d, y);
            error_count = error_count + 1;
        end
        
        // Test case 3
        d = 3'b011;
        #10;
        if (y !== 8'b00001000) begin
            $display("Error: Test 3 failed: Input=%b, Output=%b, Expected=00001000", d, y);
            error_count = error_count + 1;
        end
        
        // Test case 4
        d = 3'b100;
        #10;
        if (y !== 8'b00010000) begin
            $display("Error: Test 4 failed: Input=%b, Output=%b, Expected=00010000", d, y);
            error_count = error_count + 1;
        end
        
        // Test case 5
        d = 3'b101;
        #10;
        if (y !== 8'b00100000) begin
            $display("Error: Test 5 failed: Input=%b, Output=%b, Expected=00100000", d, y);
            error_count = error_count + 1;
        end
        
        // Test case 6
        d = 3'b110;
        #10;
        if (y !== 8'b01000000) begin
            $display("Error: Test 6 failed: Input=%b, Output=%b, Expected=01000000", d, y);
            error_count = error_count + 1;
        end
        
        // Test case 7
        d = 3'b111;
        #10;
        if (y !== 8'b10000000) begin
            $display("Error: Test 7 failed: Input=%b, Output=%b, Expected=10000000", d, y);
            error_count = error_count + 1;
        end
        
        // Test combinational logic behavior (quick input change)
        d = 3'b000;
        #1;
        if (y !== 8'b00000001) begin
            $display("Error: Combinational test failed: Input=%b, Output=%b, Expected=00000001", d, y);
            error_count = error_count + 1;
        end
        
        // Final result
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end
endmodule