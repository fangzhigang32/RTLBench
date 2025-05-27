`timescale 1ns/1ps

module tb_and_gate_4input;

    // Inputs
    reg a;
    reg b;
    reg c;
    reg d;
    
    // Output
    wire y;
    
    // Instantiate the Unit Under Test (UUT)
    and_gate_4input uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .y(y)
    );
    
    reg error_flag;

    // Stimulus generation and checking
    initial begin
        error_flag = 0;
        
        // Initialize inputs
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        
        // Wait for global reset
        #100;
        
        // Test case 1: All inputs 0
        a = 0; b = 0; c = 0; d = 0;
        #10;
        if (y !== 1'b0) begin
            $display("Error: Case 1 - Input: %b%b%b%b, Output: %b, Expected: 0", a, b, c, d, y);
            error_flag = 1;
        end
        
        // Test case 2: All inputs 1
        a = 1; b = 1; c = 1; d = 1;
        #10;
        if (y !== 1'b1) begin
            $display("Error: Case 2 - Input: %b%b%b%b, Output: %b, Expected: 1", a, b, c, d, y);
            error_flag = 1;
        end
        
        // Test case 3: One input 0 (a=0)
        a = 0; b = 1; c = 1; d = 1;
        #10;
        if (y !== 1'b0) begin
            $display("Error: Case 3 - Input: %b%b%b%b, Output: %b, Expected: 0", a, b, c, d, y);
            error_flag = 1;
        end
        
        // Test case 4: One input 0 (b=0)
        a = 1; b = 0; c = 1; d = 1;
        #10;
        if (y !== 1'b0) begin
            $display("Error: Case 4 - Input: %b%b%b%b, Output: %b, Expected: 0", a, b, c, d, y);
            error_flag = 1;
        end
        
        // Test case 5: One input 0 (c=0)
        a = 1; b = 1; c = 0; d = 1;
        #10;
        if (y !== 1'b0) begin
            $display("Error: Case 5 - Input: %b%b%b%b, Output: %b, Expected: 0", a, b, c, d, y);
            error_flag = 1;
        end
        
        // Test case 6: One input 0 (d=0)
        a = 1; b = 1; c = 1; d = 0;
        #10;
        if (y !== 1'b0) begin
            $display("Error: Case 6 - Input: %b%b%b%b, Output: %b, Expected: 0", a, b, c, d, y);
            error_flag = 1;
        end
        
        // Test case 7: Two inputs 0
        a = 1; b = 0; c = 1; d = 0;
        #10;
        if (y !== 1'b0) begin
            $display("Error: Case 7 - Input: %b%b%b%b, Output: %b, Expected: 0", a, b, c, d, y);
            error_flag = 1;
        end
        
        // Test case 8: Three inputs 0
        a = 1; b = 0; c = 0; d = 0;
        #10;
        if (y !== 1'b0) begin
            $display("Error: Case 8 - Input: %b%b%b%b, Output: %b, Expected: 0", a, b, c, d, y);
            error_flag = 1;
        end
        
        // Finish simulation
        #100;
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        $finish;
    end

endmodule