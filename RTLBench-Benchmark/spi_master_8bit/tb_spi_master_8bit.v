`timescale 1ns / 1ps

module tb_spi_master_8bit();

// Inputs
reg clk;
reg rst;
reg spi_en;
reg [7:0] din;

// Outputs
wire mosi;
wire sclk;
wire cs;

// Instantiate the Unit Under Test (UUT)
spi_master_8bit uut (
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
reg test_failed = 0;
initial begin
    // Initialize Inputs
    rst = 1;
    spi_en = 0;
    din = 8'h00;
    
    // Reset the system
    #20;
    rst = 0;
    
    // Test case 1: Basic transmission
    #10;
    spi_en = 1;
    din = 8'hAA;
    #200;
    
    // Check outputs
    if (cs !== 1'b1) begin
        $display("Error [Test 1]: CS should be high after transmission. Got %b, expected 1", cs);
        test_failed = 1;
    end
    
    // Test case 2: Multiple transmissions
    din = 8'h55;
    #20;
    din = 8'hF0;
    #200;
    
    // Check outputs
    if (cs !== 1'b1) begin
        $display("Error [Test 2]: CS should be high after transmission. Got %b, expected 1", cs);
        test_failed = 1;
    end
    
    // Test case 3: SPI disabled
    spi_en = 0;
    din = 8'hFF;
    #50;
    
    // Check outputs
    if (cs !== 1'b1 || sclk !== 1'b0 || mosi !== 1'b0) begin
        $display("Error [Test 3]: All outputs should be idle when SPI disabled. Got cs=%b, sclk=%b, mosi=%b", cs, sclk, mosi);
        test_failed = 1;
    end
    
    // Test case 4: Reset during transmission
    spi_en = 1;
    din = 8'hCC;
    #40;
    rst = 1;
    #20;
    rst = 0;
    
    // Check outputs
    if (cs !== 1'b1 || sclk !== 1'b0 || mosi !== 1'b0) begin
        $display("Error [Test 4]: Reset should clear all outputs. Got cs=%b, sclk=%b, mosi=%b", cs, sclk, mosi);
        test_failed = 1;
    end
    
    // Final result
    if (test_failed) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    
    // Finish simulation
    #100;
    $finish;
end

// Monitor SCLK and MOSI changes
always @(posedge sclk) begin
    $display("SCLK posedge at time %t, MOSI=%b", $time, mosi);
end

always @(negedge sclk) begin
    $display("SCLK negedge at time %t", $time);
end

endmodule