`timescale 1ns/1ps

module tb_eq_comparator_8bit;

    // Inputs
    reg [7:0] a;
    reg [7:0] b;
    
    // Output
    wire eq;
    
    // Instantiate the Unit Under Test (UUT)
    eq_comparator_8bit uut (
        .a(a),
        .b(b),
        .eq(eq)
    );
    
    reg error_flag = 0;
    
    initial begin
        // Initialize Inputs
        a = 8'b0;
        b = 8'b0;
        
        // Wait for global reset
        #10;
        
        // Test case 1: Equal inputs
        a = 8'hAA;
        b = 8'hAA;
        #10;
        if (eq !== 1'b1) begin
            $display("Error: Test case 1 failed - a=%h, b=%h, eq=%b (expected 1)", a, b, eq);
            error_flag = 1;
        end
        
        // Test case 2: Unequal inputs
        a = 8'h55;
        b = 8'hAA;
        #10;
        if (eq !== 1'b0) begin
            $display("Error: Test case 2 failed - a=%h, b=%h, eq=%b (expected 0)", a, b, eq);
            error_flag = 1;
        end
        
        // Test case 3: Zero inputs
        a = 8'h00;
        b = 8'h00;
        #10;
        if (eq !== 1'b1) begin
            $display("Error: Test case 3 failed - a=%h, b=%h, eq=%b (expected 1)", a, b, eq);
            error_flag = 1;
        end
        
        // Test case 4: Maximum value comparison
        a = 8'hFF;
        b = 8'hFF;
        #10;
        if (eq !== 1'b1) begin
            $display("Error: Test case 4 failed - a=%h, b=%h, eq=%b (expected 1)", a, b, eq);
            error_flag = 1;
        end
        
        // Test case 5: One-bit difference
        a = 8'hF0;
        b = 8'hF1;
        #10;
        if (eq !== 1'b0) begin
            $display("Error: Test case 5 failed - a=%h, b=%h, eq=%b (expected 0)", a, b, eq);
            error_flag = 1;
        end
        
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        
        $finish;
    end

endmodule