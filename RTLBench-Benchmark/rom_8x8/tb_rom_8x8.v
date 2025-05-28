`timescale 1ns/1ps

module tb_rom_8x8;

    // Inputs
    reg [2:0] addr;
    
    // Outputs
    wire [7:0] dout;
    
    // Instantiate the Unit Under Test (UUT)
    rom_8x8 uut (
        .addr(addr),
        .dout(dout)
    );
    
    // Test stimulus
    reg error_flag;
    
    initial begin
        error_flag = 0;
        
        // Initialize Inputs
        addr = 0;
        
        // Wait for global reset
        #10;
        
        // Test all address cases
        addr = 3'b000; #10;
        if (dout !== 8'h00) begin
            $display("Error at addr=%b: got %h, expected 8'h00", addr, dout);
            error_flag = 1;
        end
        
        addr = 3'b001; #10;
        if (dout !== 8'h01) begin
            $display("Error at addr=%b: got %h, expected 8'h01", addr, dout);
            error_flag = 1;
        end
        
        addr = 3'b010; #10;
        if (dout !== 8'h02) begin
            $display("Error at addr=%b: got %h, expected 8'h02", addr, dout);
            error_flag = 1;
        end
        
        addr = 3'b011; #10;
        if (dout !== 8'h03) begin
            $display("Error at addr=%b: got %h, expected 8'h03", addr, dout);
            error_flag = 1;
        end
        
        addr = 3'b100; #10;
        if (dout !== 8'h04) begin
            $display("Error at addr=%b: got %h, expected 8'h04", addr, dout);
            error_flag = 1;
        end
        
        addr = 3'b101; #10;
        if (dout !== 8'h05) begin
            $display("Error at addr=%b: got %h, expected 8'h05", addr, dout);
            error_flag = 1;
        end
        
        addr = 3'b110; #10;
        if (dout !== 8'h06) begin
            $display("Error at addr=%b: got %h, expected 8'h06", addr, dout);
            error_flag = 1;
        end
        
        addr = 3'b111; #10;
        if (dout !== 8'h07) begin
            $display("Error at addr=%b: got %h, expected 8'h07", addr, dout);
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