`timescale 1ns/1ps

module tb_spi_master_16bit;

// Inputs
reg clk;
reg rst;
reg spi_en;
reg [15:0] din;

// Outputs
wire mosi;
wire sclk;
wire cs;

// Instantiate the Unit Under Test (UUT)
spi_master_16bit uut (
    .clk(clk),
    .rst(rst),
    .spi_en(spi_en),
    .din(din),
    .mosi(mosi),
    .sclk(sclk),
    .cs(cs)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
reg error_flag = 0;
initial begin
    // Initialize Inputs
    rst = 1;
    spi_en = 0;
    din = 16'h0000;
    
    // Apply reset
    #20;
    rst = 0;
    
    // Test case 1: Basic transmission
    #10;
    din = 16'hA5A5;
    spi_en = 1;
    #10;
    spi_en = 0;
    
    // Wait for transmission to complete
    #320;
    
    // Check outputs
    if (cs !== 1'b1 || mosi !== 1'b0 || sclk !== 1'b0) begin
        $display("Error: Test case 1 failed");
        $display("Input: din=%h, spi_en=%b", 16'hA5A5, 1'b1);
        $display("Output: cs=%b, mosi=%b, sclk=%b", cs, mosi, sclk);
        $display("Expected: cs=1, mosi=0, sclk=0");
        error_flag = 1;
    end
    
    // Test case 2: Verify data transmission
    #20;
    din = 16'h55AA;
    spi_en = 1;
    #10;
    spi_en = 0;
    
    // Wait for transmission to complete
    #320;
    
    // Check outputs
    if (cs !== 1'b1 || mosi !== 1'b0 || sclk !== 1'b0) begin
        $display("Error: Test case 2 failed");
        $display("Input: din=%h, spi_en=%b", 16'h55AA, 1'b1);
        $display("Output: cs=%b, mosi=%b, sclk=%b", cs, mosi, sclk);
        $display("Expected: cs=1, mosi=0, sclk=0");
        error_flag = 1;
    end
    
    // Test case 3: Verify reset during transmission
    #20;
    din = 16'h1234;
    spi_en = 1;
    #10;
    spi_en = 0;
    
    // Apply reset during transmission
    #100;
    rst = 1;
    #20;
    rst = 0;
    
    // Check outputs after reset
    if (cs !== 1'b1 || mosi !== 1'b0 || sclk !== 1'b0) begin
        $display("Error: Test case 3 failed");
        $display("Input: din=%h, spi_en=%b, rst pulsed", 16'h1234, 1'b1);
        $display("Output: cs=%b, mosi=%b, sclk=%b", cs, mosi, sclk);
        $display("Expected: cs=1, mosi=0, sclk=0");
        error_flag = 1;
    end
    
    // End simulation
    #100;
    if (error_flag) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    $finish;
end

// Monitor signals
initial begin
    $monitor("Time=%0t: rst=%b, spi_en=%b, din=%h, mosi=%b, sclk=%b, cs=%b", 
             $time, rst, spi_en, din, mosi, sclk, cs);
end

endmodule