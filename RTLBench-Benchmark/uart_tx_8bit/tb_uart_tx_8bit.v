`timescale 1ns/1ps

module tb_uart_tx_8bit;

// Inputs
reg clk;
reg rst;
reg tx_en;
reg [7:0] din;

// Outputs
wire tx;

// Instantiate the Unit Under Test (UUT)
uart_tx_8bit uut (
    .clk(clk),
    .rst(rst),
    .tx_en(tx_en),
    .din(din),
    .tx(tx)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
reg [3:0] error_count = 0;

initial begin
    // Initialize Inputs
    rst = 1;
    tx_en = 0;
    din = 8'h00;
    
    // Reset the system
    #20;
    rst = 0;
    
    // Test case 1: Send 0x55
    #10;
    din = 8'h55;
    tx_en = 1;
    #10;
    tx_en = 0;
    
    // Wait for transmission to complete (10 bits * 10ns per bit = 100ns)
    #100;
    
    // Check output
    if (tx !== 1'b1) begin
        $display("Error: Test case 1 (0x55) failed - Stop bit not high. Got %b, expected 1", tx);
        error_count = error_count + 1;
    end
    
    // Test case 2: Send 0xAA
    #20;
    din = 8'hAA;
    tx_en = 1;
    #10;
    tx_en = 0;
    
    // Wait for transmission to complete
    #100;
    
    // Check output
    if (tx !== 1'b1) begin
        $display("Error: Test case 2 (0xAA) failed - Stop bit not high. Got %b, expected 1", tx);
        error_count = error_count + 1;
    end
    
    // Test case 3: Send 0x00
    #20;
    din = 8'h00;
    tx_en = 1;
    #10;
    tx_en = 0;
    
    // Wait for transmission to complete
    #100;
    
    // Check output
    if (tx !== 1'b1) begin
        $display("Error: Test case 3 (0x00) failed - Stop bit not high. Got %b, expected 1", tx);
        error_count = error_count + 1;
    end
    
    // Test case 4: Send 0xFF
    #20;
    din = 8'hFF;
    tx_en = 1;
    #10;
    tx_en = 0;
    
    // Wait for transmission to complete
    #100;
    
    // Check output
    if (tx !== 1'b1) begin
        $display("Error: Test case 4 (0xFF) failed - Stop bit not high. Got %b, expected 1", tx);
        error_count = error_count + 1;
    end
    
    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end
    
    // End simulation
    #100;
    $finish;
end

endmodule