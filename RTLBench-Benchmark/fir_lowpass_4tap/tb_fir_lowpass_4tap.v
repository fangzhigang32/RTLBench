`timescale 1ns/1ps

module tb_fir_lowpass_4tap();

// Inputs
reg clk;
reg rst;
reg [7:0] x;

// Outputs
wire [7:0] y;

// Instantiate the Unit Under Test (UUT)
fir_lowpass_4tap uut (
    .clk(clk),
    .rst(rst),
    .x(x),
    .y(y)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
reg error_flag;
initial begin
    error_flag = 0;
    
    // Initialize Inputs
    rst = 1;
    x = 0;
    
    // Wait for global reset
    #20;
    rst = 0;
    
    // Test case 1: Step input
    x = 8'b11111100; // 252 (0.25*252 = 63)
    #10;
    if (y !== 8'b00000000) begin
        $display("Error case 1: Input=%b, Output=%b, Expected=00000000", x, y);
        error_flag = 1;
    end
    
    #10; // After 1 clock
    if (y !== 8'b00111100) begin
        $display("Error case 2: Input=%b, Output=%b, Expected=00111100", x, y);
        error_flag = 1;
    end
    
    #10; // After 2 clocks
    if (y !== 8'b00111100) begin
        $display("Error case 3: Input=%b, Output=%b, Expected=00111100", x, y);
        error_flag = 1;
    end
    
    #10; // After 3 clocks
    if (y !== 8'b00111100) begin
        $display("Error case 4: Input=%b, Output=%b, Expected=00111100", x, y);
        error_flag = 1;
    end
    
    // Test case 2: Alternating input
    x = 8'b00000000;
    #10;
    x = 8'b11111100;
    #10;
    x = 8'b00000000;
    #10;
    x = 8'b11111100;
    #10;
    
    // Check final output after pipeline fills
    if (y !== 8'b00111100) begin
        $display("Error case 5: Input=%b, Output=%b, Expected=00111100", x, y);
        error_flag = 1;
    end
    
    // Test case 3: Ramp input
    x = 8'b00000100; // 4
    #10;
    x = 8'b00001000; // 8
    #10;
    x = 8'b00001100; // 12
    #10;
    x = 8'b00010000; // 16
    #10;
    
    // Check final output (0.25*(4+8+12+16) = 10)
    if (y !== 8'b00001010) begin
        $display("Error case 6: Input=%b, Output=%b, Expected=00001010", x, y);
        error_flag = 1;
    end
    
    if (error_flag)
        $display("Exist Function Error");
    else
        $display("No Function Error");
    
    $finish;
end

endmodule