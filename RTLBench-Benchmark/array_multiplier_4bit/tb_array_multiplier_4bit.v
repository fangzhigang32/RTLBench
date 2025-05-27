`timescale 1ns/1ps

module tb_array_multiplier_4bit;

    // Inputs
    reg [3:0] a;
    reg [3:0] b;
    
    // Outputs
    wire [7:0] p;
    
    // Instantiate the Unit Under Test (UUT)
    array_multiplier_4bit uut (
        .a(a),
        .b(b),
        .p(p)
    );
    
    integer i, j;
    reg [7:0] expected;
    integer pass_count = 0;
    integer fail_count = 0;
    integer error_flag = 0;
    
    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        
        // Test all possible 4-bit input combinations
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i;
                b = j;
                expected = i * j;
                #10; // Allow propagation delay for combinational logic
                
                if (p !== expected) begin
                    $display("Error: a=%d, b=%d, p=%d, expected=%d", 
                             a, b, p, expected);
                    fail_count = fail_count + 1;
                    error_flag = 1;
                end
                else begin
                    pass_count = pass_count + 1;
                end
            end
        end
        
        // Final result output
        if (error_flag == 0) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end
        $finish;
    end

endmodule