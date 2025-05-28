`timescale 1ns/1ps

module tb_comb_multiplier_4bit;

    // Inputs
    reg [3:0] a;
    reg [3:0] b;
    
    // Outputs
    wire [7:0] p;
    
    // Test variables
    integer i, j;
    integer error_count = 0;
    reg [7:0] expected;
    
    // Instantiate the Unit Under Test (UUT)
    comb_multiplier_4bit uut (
        .a(a),
        .b(b),
        .p(p)
    );
    
    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        
        // Test initial state (a=0, b=0)
        expected = 0;
        #10;
        if (p !== expected) begin
            $display("Error: a=%b (%0d), b=%b (%0d), p=%b (%0d), expected=%b (%0d)", 
                     a, a, b, b, p, p, expected, expected);
            error_count = error_count + 1;
        end
        
        // Test all possible input combinations
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i;
                b = j;
                expected = i * j;
                #10; // Wait for combinational logic propagation (10ns)
                
                if (p !== expected) begin
                    $display("Error: a=%b (%0d), b=%b (%0d), p=%b (%0d), expected=%b (%0d)", 
                             a, a, b, b, p, p, expected, expected);
                    error_count = error_count + 1;
                end
            end
        end
        
        // Final summary
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end

endmodule