`timescale 1ns/1ps

module tb_demux_1to4;
    // Inputs
    reg d;
    reg [1:0] sel;
    
    // Outputs
    wire [3:0] y;
    
    // Instantiate the Unit Under Test (UUT)
    demux_1to4 uut (
        .d(d),
        .sel(sel),
        .y(y)
    );
    
    reg error_flag = 0;
    
    initial begin
        // Initialize Inputs
        d = 0;
        sel = 2'b00;
        
        // Test case 0: Initial state (d=0, sel=00)
        #10 if (y !== 4'b0000) begin
            $display("Error: d=%b, sel=%b, got y=%b, expected 4'b0000", d, sel, y);
            error_flag = 1;
        end
        
        // Test case 1: sel = 00, d = 1
        #10 d = 1; sel = 2'b00;
        #10 if (y !== 4'b0001) begin
            $display("Error: d=%b, sel=%b, got y=%b, expected 4'b0001", d, sel, y);
            error_flag = 1;
        end
        
        // Test case 2: sel = 01, d = 1
        #10 sel = 2'b01;
        #10 if (y !== 4'b0010) begin
            $display("Error: d=%b, sel=%b, got y=%b, expected 4'b0010", d, sel, y);
            error_flag = 1;
        end
        
        // Test case 3: sel = 10, d = 1
        #10 sel = 2'b10;
        #10 if (y !== 4'b0100) begin
            $display("Error: d=%b, sel=%b, got y=%b, expected 4'b0100", d, sel, y);
            error_flag = 1;
        end
        
        // Test case 4: sel = 11, d = 1
        #10 sel = 2'b11;
        #10 if (y !== 4'b1000) begin
            $display("Error: d=%b, sel=%b, got y=%b, expected 4'b1000", d, sel, y);
            error_flag = 1;
        end
        
        // Test case 5: d = 0, test all sel values
        #10 d = 0; sel = 2'b00;
        #10 if (y !== 4'b0000) begin
            $display("Error: d=%b, sel=%b, got y=%b, expected 4'b0000", d, sel, y);
            error_flag = 1;
        end
        
        #10 sel = 2'b01;
        #10 if (y !== 4'b0000) begin
            $display("Error: d=%b, sel=%b, got y=%b, expected 4'b0000", d, sel, y);
            error_flag = 1;
        end
        
        #10 sel = 2'b10;
        #10 if (y !== 4'b0000) begin
            $display("Error: d=%b, sel=%b, got y=%b, expected 4'b0000", d, sel, y);
            error_flag = 1;
        end
        
        #10 sel = 2'b11;
        #10 if (y !== 4'b0000) begin
            $display("Error: d=%b, sel=%b, got y=%b, expected 4'b0000", d, sel, y);
            error_flag = 1;
        end
        
        // Final result
        #10 if (error_flag)
            $display("Exist Function Error");
        else
            $display("No Function Error");
            
        $finish;
    end
endmodule