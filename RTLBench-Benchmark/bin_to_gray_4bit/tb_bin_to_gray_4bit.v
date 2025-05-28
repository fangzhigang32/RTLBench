`timescale 1ns/1ps

module tb_bin_to_gray_4bit;

    // Inputs
    reg [3:0] b;
    
    // Outputs
    wire [3:0] g;
    
    // Error flag to track test failures
    reg error_flag;
    
    // Instantiate the Unit Under Test (UUT)
    bin_to_gray_4bit uut (
        .b(b),
        .g(g)
    );
    
    // Test stimulus and checking
    initial begin
        // Initialize Inputs and error flag
        b = 4'b0000;
        error_flag = 0;
        
        // Wait for global reset
        #10;
        
        // Test case 1: 0000
        b = 4'b0000;
        #10;
        if (g !== 4'b0000) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b0000);
            error_flag = 1;
        end
        
        // Test case 2: 0001
        b = 4'b0001;
        #10;
        if (g !== 4'b0001) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b0001);
            error_flag = 1;
        end
        
        // Test case 3: 0010
        b = 4'b0010;
        #10;
        if (g !== 4'b0011) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b0011);
            error_flag = 1;
        end
        
        // Test case 4: 0011
        b = 4'b0011;
        #10;
        if (g !== 4'b0010) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b0010);
            error_flag = 1;
        end
        
        // Test case 5: 0100
        b = 4'b0100;
        #10;
        if (g !== 4'b0110) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b0110);
            error_flag = 1;
        end
        
        // Test case 6: 0101
        b = 4'b0101;
        #10;
        if (g !== 4'b0111) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b0111);
            error_flag = 1;
        end
        
        // Test case 7: 0110
        b = 4'b0110;
        #10;
        if (g !== 4'b0101) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b0101);
            error_flag = 1;
        end
        
        // Test case 8: 0111
        b = 4'b0111;
        #10;
        if (g !== 4'b0100) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b0100);
            error_flag = 1;
        end
        
        // Test case 9: 1000
        b = 4'b1000;
        #10;
        if (g !== 4'b1100) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b1100);
            error_flag = 1;
        end
        
        // Test case 10: 1001
        b = 4'b1001;
        #10;
        if (g !== 4'b1101) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b1101);
            error_flag = 1;
        end
        
        // Test case 11: 1010
        b = 4'b1010;
        #10;
        if (g !== 4'b1111) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b1111);
            error_flag = 1;
        end
        
        // Test case 12: 1011
        b = 4'b1011;
        #10;
        if (g !== 4'b1110) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b1110);
            error_flag = 1;
        end
        
        // Test case 13: 1100
        b = 4'b1100;
        #10;
        if (g !== 4'b1010) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b1010);
            error_flag = 1;
        end
        
        // Test case 14: 1101
        b = 4'b1101;
        #10;
        if (g !== 4'b1011) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b1011);
            error_flag = 1;
        end
        
        // Test case 15: 1110
        b = 4'b1110;
        #10;
        if (g !== 4'b1001) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b1001);
            error_flag = 1;
        end
        
        // Test case 16: 1111
        b = 4'b1111;
        #10;
        if (g !== 4'b1000) begin
            $display("Error: Input=%b, Output=%b, Expected=%b", b, g, 4'b1000);
            error_flag = 1;
        end
        
        // Final check
        if (error_flag == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end

endmodule