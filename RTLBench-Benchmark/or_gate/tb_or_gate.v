`timescale 1ns/1ps

module tb_or_gate;

    // Inputs
    reg a;
    reg b;
    
    // Outputs
    wire y;
    
    // Instantiate the Unit Under Test (UUT)
    or_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );
    
    reg error_flag;
    
    initial begin
        // Initialize Inputs and error flag
        a = 0;
        b = 0;
        error_flag = 0;
        
        // Wait 10 ns for global reset to finish
        #10;
        
        // Test case 1: 0 OR 0
        a = 0; b = 0;
        #10;
        if (y !== 0) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 0)", a, b, y);
            error_flag = 1;
        end
        
        // Test case 2: 0 OR 1
        a = 0; b = 1;
        #10;
        if (y !== 1) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 1)", a, b, y);
            error_flag = 1;
        end
        
        // Test case 3: 1 OR 0
        a = 1; b = 0;
        #10;
        if (y !== 1) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 1)", a, b, y);
            error_flag = 1;
        end
        
        // Test case 4: 1 OR 1
        a = 1; b = 1;
        #10;
        if (y !== 1) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 1)", a, b, y);
            error_flag = 1;
        end
        
        // Final result
        if (error_flag == 0) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end
        
        // Finish simulation
        $finish;
    end
    
endmodule