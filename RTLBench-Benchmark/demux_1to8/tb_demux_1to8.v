`timescale 1ns/1ps

module tb_demux_1to8;
    // Inputs
    reg d;
    reg [2:0] sel;
    
    // Outputs
    wire [7:0] y;
    
    // Instantiate the Unit Under Test (UUT)
    demux_1to8 uut (
        .d(d),
        .sel(sel),
        .y(y)
    );
    
    reg error_flag;
    
    initial begin
        error_flag = 0;
        
        // Initialize Inputs
        d = 0;
        sel = 0;
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Test case 1: sel=000, d=1
        d = 1; sel = 3'b000; #10;
        if (y !== 8'b00000001) begin
            $display("Error: sel=000, d=1, y=%b, expected 00000001", y);
            error_flag = 1;
        end
        
        // Test case 2: sel=001, d=1
        d = 1; sel = 3'b001; #10;
        if (y !== 8'b00000010) begin
            $display("Error: sel=001, d=1, y=%b, expected 00000010", y);
            error_flag = 1;
        end
        
        // Test case 3: sel=010, d=1
        d = 1; sel = 3'b010; #10;
        if (y !== 8'b00000100) begin
            $display("Error: sel=010, d=1, y=%b, expected 00000100", y);
            error_flag = 1;
        end
        
        // Test case 4: sel=011, d=1
        d = 1; sel = 3'b011; #10;
        if (y !== 8'b00001000) begin
            $display("Error: sel=011, d=1, y=%b, expected 00001000", y);
            error_flag = 1;
        end
        
        // Test case 5: sel=100, d=1
        d = 1; sel = 3'b100; #10;
        if (y !== 8'b00010000) begin
            $display("Error: sel=100, d=1, y=%b, expected 00010000", y);
            error_flag = 1;
        end
        
        // Test case 6: sel=101, d=1
        d = 1; sel = 3'b101; #10;
        if (y !== 8'b00100000) begin
            $display("Error: sel=101, d=1, y=%b, expected 00100000", y);
            error_flag = 1;
        end
        
        // Test case 7: sel=110, d=1
        d = 1; sel = 3'b110; #10;
        if (y !== 8'b01000000) begin
            $display("Error: sel=110, d=1, y=%b, expected 01000000", y);
            error_flag = 1;
        end
        
        // Test case 8: sel=111, d=1
        d = 1; sel = 3'b111; #10;
        if (y !== 8'b10000000) begin
            $display("Error: sel=111, d=1, y=%b, expected 10000000", y);
            error_flag = 1;
        end
        
        // Test case 9: sel=000, d=0
        d = 0; sel = 3'b000; #10;
        if (y !== 8'b00000000) begin
            $display("Error: sel=000, d=0, y=%b, expected 00000000", y);
            error_flag = 1;
        end
        
        // Test case 10: sel=101, d=0
        d = 0; sel = 3'b101; #10;
        if (y !== 8'b00000000) begin
            $display("Error: sel=101, d=0, y=%b, expected 00000000", y);
            error_flag = 1;
        end
        
        // Additional test cases for all sel values with d=0
        d = 0; sel = 3'b001; #10;
        if (y !== 8'b00000000) begin
            $display("Error: sel=001, d=0, y=%b, expected 00000000", y);
            error_flag = 1;
        end
        
        d = 0; sel = 3'b010; #10;
        if (y !== 8'b00000000) begin
            $display("Error: sel=010, d=0, y=%b, expected 00000000", y);
            error_flag = 1;
        end
        
        d = 0; sel = 3'b011; #10;
        if (y !== 8'b00000000) begin
            $display("Error: sel=011, d=0, y=%b, expected 00000000", y);
            error_flag = 1;
        end
        
        d = 0; sel = 3'b100; #10;
        if (y !== 8'b00000000) begin
            $display("Error: sel=100, d=0, y=%b, expected 00000000", y);
            error_flag = 1;
        end
        
        d = 0; sel = 3'b110; #10;
        if (y !== 8'b00000000) begin
            $display("Error: sel=110, d=0, y=%b, expected 00000000", y);
            error_flag = 1;
        end
        
        d = 0; sel = 3'b111; #10;
        if (y !== 8'b00000000) begin
            $display("Error: sel=111, d=0, y=%b, expected 00000000", y);
            error_flag = 1;
        end
        
        // Final result
        if (error_flag == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end
endmodule