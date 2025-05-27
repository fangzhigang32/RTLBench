`timescale 1ns/1ps

module tb_or_gate_32bit;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    
    // Outputs
    wire [31:0] y;
    
    // Instantiate the Unit Under Test (UUT)
    or_gate_32bit uut (
        .a(a),
        .b(b),
        .y(y)
    );
    
    reg error_flag;
    
    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        error_flag = 0;
        
        // Wait 100 ns for global reset
        #100;
        
        // Test Case 1: All zeros
        a = 32'h00000000;
        b = 32'h00000000;
        #10;
        if (y !== (a | b)) begin
            $display("Error: Case 1 - a=%h, b=%h, y=%h, expected=%h", a, b, y, (a | b));
            error_flag = 1;
        end
        
        // Test Case 2: All ones
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        #10;
        if (y !== (a | b)) begin
            $display("Error: Case 2 - a=%h, b=%h, y=%h, expected=%h", a, b, y, (a | b));
            error_flag = 1;
        end
        
        // Test Case 3: Alternating bits
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        #10;
        if (y !== (a | b)) begin
            $display("Error: Case 3 - a=%h, b=%h, y=%h, expected=%h", a, b, y, (a | b));
            error_flag = 1;
        end
        
        // Test Case 4: Random values
        a = 32'h12345678;
        b = 32'h9ABCDEF0;
        #10;
        if (y !== (a | b)) begin
            $display("Error: Case 4 - a=%h, b=%h, y=%h, expected=%h", a, b, y, (a | b));
            error_flag = 1;
        end
        
        // Test Case 5: Mixed values
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        #10;
        if (y !== (a | b)) begin
            $display("Error: Case 5 - a=%h, b=%h, y=%h, expected=%h", a, b, y, (a | b));
            error_flag = 1;
        end
        
        // Final result
        if (error_flag == 0) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end
        $finish;
    end

endmodule