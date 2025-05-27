// Verilog Testbench for 8-bit odd parity checker
`timescale 1ns/1ps

module tb_parity_checker_8bit;

    // Inputs
    reg [7:0] d;
    
    // Outputs
    wire p;
    
    // Instantiate the Unit Under Test (UUT)
    parity_checker_8bit uut (
        .d(d),
        .p(p)
    );
    
    integer i;
    reg expected;
    reg error_flag;
    
    initial begin
        // Initialize Inputs
        d = 0;
        error_flag = 0;
        
        // Wait for global reset
        #100;
        
        // Test case 1: All zeros (should be 1 for odd parity)
        d = 8'b00000000;
        expected = 1'b1;
        #10;
        if (p !== expected) begin
            $display("Error: Case 1 - Input=%b, Output=%b, Expected=%b", d, p, expected);
            error_flag = 1;
        end
        
        // Test case 2: All ones (should be 0 for odd parity)
        d = 8'b11111111;
        expected = 1'b0;
        #10;
        if (p !== expected) begin
            $display("Error: Case 2 - Input=%b, Output=%b, Expected=%b", d, p, expected);
            error_flag = 1;
        end
        
        // Test case 3: Single 1 (should be 1 for odd parity)
        d = 8'b00000001;
        expected = 1'b1;
        #10;
        if (p !== expected) begin
            $display("Error: Case 3 - Input=%b, Output=%b, Expected=%b", d, p, expected);
            error_flag = 1;
        end
        
        // Test case 4: Alternating bits (should be 0 for odd parity)
        d = 8'b10101010;
        expected = 1'b0;
        #10;
        if (p !== expected) begin
            $display("Error: Case 4 - Input=%b, Output=%b, Expected=%b", d, p, expected);
            error_flag = 1;
        end
        
        // Test case 5: Random pattern 1
        d = 8'b11001100;
        expected = 1'b0;
        #10;
        if (p !== expected) begin
            $display("Error: Case 5 - Input=%b, Output=%b, Expected=%b", d, p, expected);
            error_flag = 1;
        end
        
        // Test case 6: Random pattern 2
        d = 8'b01010111;
        expected = 1'b0;
        #10;
        if (p !== expected) begin
            $display("Error: Case 6 - Input=%b, Output=%b, Expected=%b", d, p, expected);
            error_flag = 1;
        end
        
        // Test case 7: Exhaustive test (check all 256 possible inputs)
        for (i = 0; i < 256; i = i + 1) begin
            d = i;
            expected = ^d;
            #10;
            if (p !== expected) begin
                $display("Error: Case 7 - Input=%b, Output=%b, Expected=%b", d, p, expected);
                error_flag = 1;
                $finish;
            end
        end
        
        if (error_flag == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end
    
endmodule