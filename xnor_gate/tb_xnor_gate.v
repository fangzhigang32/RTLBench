`timescale 1ns/1ps

module tb_xnor_gate;

    // Inputs
    reg a;
    reg b;
    
    // Output
    wire y;
    
    // Instantiate the Unit Under Test (UUT)
    xnor_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );
    
    reg error_flag = 0;
    
    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        
        // Wait for global reset
        #100;
        
        // Test case 1: 0 XNOR 0
        a = 0; b = 0;
        #10;
        if (y !== 1) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 1)", a, b, y);
            error_flag = 1;
        end
        
        // Test case 2: 0 XNOR 1
        a = 0; b = 1;
        #10;
        if (y !== 0) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 0)", a, b, y);
            error_flag = 1;
        end
        
        // Test case 3: 1 XNOR 0
        a = 1; b = 0;
        #10;
        if (y !== 0) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 0)", a, b, y);
            error_flag = 1;
        end
        
        // Test case 4: 1 XNOR 1
        a = 1; b = 1;
        #10;
        if (y !== 1) begin
            $display("Error: a=%b, b=%b, y=%b (Expected: 1)", a, b, y);
            error_flag = 1;
        end
        
        // Final status message
        if (error_flag) begin
            $display("Exist Function Error");
        end
        else begin
            $display("No Function Error");
        end
        
        // Finish simulation
        $finish;
    end

endmodule