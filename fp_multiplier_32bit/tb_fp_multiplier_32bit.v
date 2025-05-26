`timescale 1ns/1ps

module tb_fp_multiplier_32bit;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    
    // Outputs
    wire [31:0] p;
    
    // Instantiate the Unit Under Test (UUT)
    fp_multiplier_32bit uut (
        .a(a),
        .b(b),
        .p(p)
    );
    
    // Test cases
    reg error_flag = 0;
    
    initial begin
        // Test case 1: 1.0 * 2.0 = 2.0
        a = 32'h3F800000; // 1.0
        b = 32'h40000000; // 2.0
        #10;
        if (p !== 32'h40000000) begin
            $display("Error: Input a=%h, b=%h | Output p=%h | Expected 40000000", a, b, p);
            error_flag = 1;
        end
        
        // Test case 2: -1.5 * 3.0 = -4.5
        a = 32'hBFC00000; // -1.5
        b = 32'h40400000; // 3.0
        #10;
        if (p !== 32'hC0900000) begin
            $display("Error: Input a=%h, b=%h | Output p=%h | Expected C0900000", a, b, p);
            error_flag = 1;
        end
        
        // Test case 3: 0.0 * 5.0 = 0.0
        a = 32'h00000000; // 0.0
        b = 32'h40A00000; // 5.0
        #10;
        if (p !== 32'h00000000) begin
            $display("Error: Input a=%h, b=%h | Output p=%h | Expected 00000000", a, b, p);
            error_flag = 1;
        end
        
        // Test case 4: Infinity * 2.0 = Infinity
        a = 32'h7F800000; // +Inf
        b = 32'h40000000; // 2.0
        #10;
        if (p !== 32'h7F800000) begin
            $display("Error: Input a=%h, b=%h | Output p=%h | Expected 7F800000", a, b, p);
            error_flag = 1;
        end
        
        // Test case 5: NaN * 1.0 = NaN
        a = 32'h7FC00000; // NaN
        b = 32'h3F800000; // 1.0
        #10;
        if (p[30:23] !== 8'hFF || p[22:0] === 23'd0) begin
            $display("Error: Input a=%h, b=%h | Output p=%h | Expected NaN pattern", a, b, p);
            error_flag = 1;
        end
        
        // Test case 6: 0.0 * Infinity = NaN
        a = 32'h00000000; // 0.0
        b = 32'h7F800000; // +Inf
        #10;
        if (p !== 32'h7FC00000) begin
            $display("Error: Input a=%h, b=%h | Output p=%h | Expected 7FC00000", a, b, p);
            error_flag = 1;
        end
        
        // Test case 7: Small numbers (denormal)
        a = 32'h00000001; // ~1.4e-45
        b = 32'h00000001; // ~1.4e-45
        #10;
        if (p !== 32'h00000000) begin
            $display("Error: Input a=%h, b=%h | Output p=%h | Expected 00000000", a, b, p);
            error_flag = 1;
        end
        
        // Test case 8: Overflow case
        a = 32'h7F7FFFFF; // Max normal
        b = 32'h7F7FFFFF; // Max normal
        #10;
        if (p !== 32'h7F800000) begin
            $display("Error: Input a=%h, b=%h | Output p=%h | Expected 7F800000", a, b, p);
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