`timescale 1ns/1ps

module tb_uart_tx_16bit;

// Inputs
reg clk;
reg rst;
reg tx_en;
reg [15:0] din;

// Outputs
wire tx;

// Error flag declaration moved to module scope
reg error_flag;

// Instantiate the Unit Under Test (UUT)
uart_tx_16bit uut (
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
initial begin
    // Initialize Inputs
    error_flag = 0; // Initialize error_flag here
    rst = 1;
    tx_en = 0;
    din = 16'h0000;
    
    // Wait 100 ns for global reset
    #100;
    rst = 0;
    
    // Test Case 1: Basic transmission
    din = 16'hA55A;
    tx_en = 1;
    #10;
    tx_en = 0;
    
    // Wait for transmission to complete (18 clock cycles * 10ns = 180ns)
    #180;
    
    // Check if stop bit is properly sent
    if (tx !== 1'b1) begin
        $display("Error: Test Case 1 - Stop bit not detected. Input: %h, Output: %b, Expected: 1", din, tx);
        error_flag = 1;
    end
    
    // Test Case 2: Back-to-back transmission
    din = 16'h1234;
    tx_en = 1;
    #10;
    tx_en = 0;
    #180;
    
    din = 16'h5678;
    tx_en = 1;
    #10;
    tx_en = 0;
    #180;
    
    // Check if stop bit is properly sent
    if (tx !== 1'b1) begin
        $display("Error: Test Case 2 - Stop bit not detected. Input: %h, Output: %b, Expected: 1", din, tx);
        error_flag = 1;
    end
    
    // Test Case 3: Reset during transmission
    din = 16'h9ABC;
    tx_en = 1;
    #10;
    tx_en = 0;
    #50; // Interrupt transmission
    
    rst = 1;
    #10;
    rst = 0;
    
    // Check if reset properly forces tx high
    if (tx !== 1'b1) begin
        $display("Error: Test Case 3 - Reset not forcing tx high. Input: %h, Output: %b, Expected: 1", din, tx);
        error_flag = 1;
    end
    
    // Test Case 4: Verify data bits
    din = 16'h0001; // LSB first
    tx_en = 1;
    #10;
    tx_en = 0;
    
    // Wait for start bit
    #10;
    if (tx !== 1'b0) begin
        $display("Error: Test Case 4 - Start bit not detected. Input: %h, Output: %b, Expected: 0", din, tx);
        error_flag = 1;
    end
    
    // Check each data bit
    #10; // First data bit (LSB)
    if (tx !== 1'b1) begin
        $display("Error: Test Case 4 - Data bit 0 mismatch. Input: %h, Output: %b, Expected: 1", din, tx);
        error_flag = 1;
    end
    
    #10; // Second data bit
    if (tx !== 1'b0) begin
        $display("Error: Test Case 4 - Data bit 1 mismatch. Input: %h, Output: %b, Expected: 0", din, tx);
        error_flag = 1;
    end
    
    // Continue checking remaining bits...
    
    #160; // Wait for stop bit
    if (tx !== 1'b1) begin
        $display("Error: Test Case 4 - Stop bit not detected. Input: %h, Output: %b, Expected: 1", din, tx);
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