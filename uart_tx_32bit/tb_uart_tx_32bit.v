`timescale 1ns/1ps

module tb_uart_tx_32bit;

// Inputs
reg clk;
reg rst;
reg tx_en;
reg [31:0] din;

// Outputs
wire tx;

// Instantiate the Unit Under Test (UUT)
uart_tx_32bit uut (
    .clk(clk),
    .rst(rst),
    .tx_en(tx_en),
    .din(din),
    .tx(tx)
);

integer error_count;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize Inputs
    error_count = 0;
    rst = 1;
    tx_en = 0;
    din = 32'h00000000;
    
    // Reset the system
    #20;
    rst = 0;
    
    // Test Case 1: Simple transmission
    din = 32'hA5A5A5A5;
    tx_en = 1;
    #10;
    tx_en = 0;
    
    // Wait for transmission to complete (34 clock cycles: start + 32 data + stop)
    #680;
    
    // Verify stop bit is high
    if (tx !== 1'b1) begin
        $display("Error: Test Case 1 - Stop bit not high. Got %b, expected 1", tx);
        error_count = error_count + 1;
    end
    
    // Test Case 2: Back-to-back transmission
    din = 32'h12345678;
    tx_en = 1;
    #10;
    tx_en = 0;
    
    // Wait for first transmission to complete
    #680;
    
    // Verify first transmission completed
    if (tx !== 1'b1) begin
        $display("Error: Test Case 2 - First transmission stop bit not high. Got %b, expected 1", tx);
        error_count = error_count + 1;
    end
    
    // Start second transmission
    din = 32'h9ABCDEF0;
    tx_en = 1;
    #10;
    tx_en = 0;
    
    // Wait for second transmission to complete
    #680;
    
    // Verify second transmission completed
    if (tx !== 1'b1) begin
        $display("Error: Test Case 2 - Second transmission stop bit not high. Got %b, expected 1", tx);
        error_count = error_count + 1;
    end
    
    // Test Case 3: Transmission with reset during operation
    din = 32'hDEADBEEF;
    tx_en = 1;
    #10;
    tx_en = 0;
    
    // Wait until mid-transmission
    #200;
    rst = 1;
    #20;
    rst = 0;
    
    // Verify tx line goes high after reset
    if (tx !== 1'b1) begin
        $display("Error: Test Case 3 - TX not high after reset. Got %b, expected 1", tx);
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

// Monitor the outputs
initial begin
    $monitor("Time = %t, TX = %b", $time, tx);
end

endmodule