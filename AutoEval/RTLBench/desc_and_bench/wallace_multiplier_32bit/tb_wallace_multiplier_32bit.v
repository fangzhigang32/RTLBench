`timescale 1ns/1ps

module tb_wallace_multiplier_32bit;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    
    // Outputs
    wire [63:0] p;
    
    // Instantiate the Unit Under Test (UUT)
    wallace_multiplier_32bit uut (
        .a(a),
        .b(b),
        .p(p)
    );
    
    // Test stimulus
    reg error_flag = 0;
    
    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        
        // Wait 100 ns for global reset
        #100;
        
        // Test case 1: Simple multiplication
        a = 32'd5;
        b = 32'd3;
        #100;
        if (p !== 64'd15) begin
            $display("Error case 1: a=%d, b=%d, p=%d, expected=%d", a, b, p, 64'd15);
            error_flag = 1;
        end
        
        // Test case 2: Maximum value multiplication
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        #100;
        if (p !== 64'hFFFFFFFE00000001) begin
            $display("Error case 2: a=%h, b=%h, p=%h, expected=%h", a, b, p, 64'hFFFFFFFE00000001);
            error_flag = 1;
        end
        
        // Test case 3: Random values
        a = 32'd123456789;
        b = 32'd987654321;
        #100;
        if (p !== 64'd121932631112635269) begin
            $display("Error case 3: a=%d, b=%d, p=%d, expected=%d", a, b, p, 64'd121932631112635269);
            error_flag = 1;
        end
        
        // Test case 4: Power of two
        a = 32'd1024;
        b = 32'd2048;
        #100;
        if (p !== 64'd2097152) begin
            $display("Error case 4: a=%d, b=%d, p=%d, expected=%d", a, b, p, 64'd2097152);
            error_flag = 1;
        end
        
        // Test case 5: Zero case
        a = 32'd0;
        b = 32'd123456;
        #100;
        if (p !== 64'd0) begin
            $display("Error case 5: a=%d, b=%d, p=%d, expected=%d", a, b, p, 64'd0);
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