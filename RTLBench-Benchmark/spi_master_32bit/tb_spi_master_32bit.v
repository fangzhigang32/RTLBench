`timescale 1ns/1ps

module tb_spi_master_32bit();

// Inputs
reg clk;
reg rst;
reg spi_en;
reg [31:0] din;

// Outputs
wire mosi;
wire sclk;
wire cs;

// Instantiate the Unit Under Test (UUT)
spi_master_32bit uut (
    .clk(clk),
    .rst(rst),
    .spi_en(spi_en),
    .din(din),
    .mosi(mosi),
    .sclk(sclk),
    .cs(cs)
);

reg error_flag;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize Inputs
    error_flag = 0;
    rst = 1;
    spi_en = 0;
    din = 0;
    
    // Reset the system
    #20;
    rst = 0;
    
    // Test Case 1: Basic transmission
    #10;
    din = 32'hA5A5A5A5;
    spi_en = 1;
    #10;
    spi_en = 0;
    
    // Wait for transmission to complete
    #1300;
    
    // Check outputs
    if (cs !== 1'b1 || sclk !== 1'b0 || mosi !== 1'b0) begin
        $display("Error Case 1: Final state not correct. cs=%b, sclk=%b, mosi=%b (expected cs=1, sclk=0, mosi=0)", cs, sclk, mosi);
        error_flag = 1;
    end
    
    // Test Case 2: Verify data transmission
    #20;
    din = 32'h12345678;
    spi_en = 1;
    #10;
    spi_en = 0;
    
    // Wait for transmission to complete
    #1300;
    
    // Check outputs
    if (cs !== 1'b1 || sclk !== 1'b0 || mosi !== 1'b0) begin
        $display("Error Case 2: Final state not correct. cs=%b, sclk=%b, mosi=%b (expected cs=1, sclk=0, mosi=0)", cs, sclk, mosi);
        error_flag = 1;
    end
    
    // Test Case 3: Reset during transmission
    #20;
    din = 32'hFFFFFFFF;
    spi_en = 1;
    #10;
    spi_en = 0;
    
    // Apply reset during transmission
    #200;
    rst = 1;
    #20;
    rst = 0;
    
    // Check outputs after reset
    if (cs !== 1'b1 || sclk !== 1'b0 || mosi !== 1'b0) begin
        $display("Error Case 3: Reset not working. cs=%b, sclk=%b, mosi=%b (expected cs=1, sclk=0, mosi=0)", cs, sclk, mosi);
        error_flag = 1;
    end
    
    // Final result
    if (error_flag) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    
    // End simulation
    #100;
    $finish;
end

// Monitor SPI signals
initial begin
    $monitor("Time=%0t, cs=%b, sclk=%b, mosi=%b, bit_counter=%d", $time, cs, sclk, mosi, uut.bit_counter);
end

endmodule