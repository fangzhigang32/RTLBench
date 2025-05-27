`timescale 1ns/1ps

module tb_xor_gate;

    // Inputs
    reg a;
    reg b;
    
    // Output
    wire y;
    
    // Instantiate the Unit Under Test (UUT)
    xor_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );
    
    // Test stimulus
    integer error_count = 0;
    
    initial begin
        // Initialize inputs
        a = 0;
        b = 0;
        
        // Test case 1: 0 XOR 0
        #10 a = 0; b = 0;
        #10 if (y !== 0) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 0)", a, b, y);
            error_count = error_count + 1;
        end
        
        // Test case 2: 0 XOR 1
        #10 a = 0; b = 1;
        #10 if (y !== 1) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 1)", a, b, y);
            error_count = error_count + 1;
        end
        
        // Test case 3: 1 XOR 0
        #10 a = 1; b = 0;
        #10 if (y !== 1) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 1)", a, b, y);
            error_count = error_count + 1;
        end
        
        // Test case 4: 1 XOR 1
        #10 a = 1; b = 1;
        #10 if (y !== 0) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 0)", a, b, y);
            error_count = error_count + 1;
        end
        
        // Final result
        #10 if (error_count == 0) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end
        
        // Finish simulation
        #10 $finish;
    end

endmodule