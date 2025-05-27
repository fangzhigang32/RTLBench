`timescale 1ns/1ps

module tb_half_adder;

    // Inputs
    reg a;
    reg b;
    
    // Outputs
    wire s;
    wire c;
    
    // Instantiate the Unit Under Test (UUT)
    half_adder uut (
        .a(a),
        .b(b),
        .s(s),
        .c(c)
    );
    
    // Test stimulus and checking
    reg error_flag;
    initial begin
        error_flag = 0;
        
        // Initialize inputs
        a = 0;
        b = 0;
        
        // Wait for global reset
        #10;
        
        // Test case 1: 0 + 0
        a = 0; b = 0;
        #10;
        if (s !== 0 || c !== 0) begin
            $display("Error: Input a=%b, b=%b: got s=%b, c=%b, expected s=0, c=0", a, b, s, c);
            error_flag = 1;
        end
        
        // Test case 2: 0 + 1
        a = 0; b = 1;
        #10;
        if (s !== 1 || c !== 0) begin
            $display("Error: Input a=%b, b=%b: got s=%b, c=%b, expected s=1, c=0", a, b, s, c);
            error_flag = 1;
        end
        
        // Test case 3: 1 + 0
        a = 1; b = 0;
        #10;
        if (s !== 1 || c !== 0) begin
            $display("Error: Input a=%b, b=%b: got s=%b, c=%b, expected s=1, c=0", a, b, s, c);
            error_flag = 1;
        end
        
        // Test case 4: 1 + 1
        a = 1; b = 1;
        #10;
        if (s !== 0 || c !== 1) begin
            $display("Error: Input a=%b, b=%b: got s=%b, c=%b, expected s=0, c=1", a, b, s, c);
            error_flag = 1;
        end
        
        // Final result
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        $finish;
    end

endmodule