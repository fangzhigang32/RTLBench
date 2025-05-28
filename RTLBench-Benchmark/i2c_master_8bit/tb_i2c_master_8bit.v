`timescale 1ns / 1ps

module tb_i2c_master_8bit();

// Inputs
reg clk;
reg rst;
reg start;
reg [7:0] din;

// Outputs
wire sda;
wire scl;

// Instantiate the Unit Under Test (UUT)
i2c_master_8bit uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .din(din),
    .sda(sda),
    .scl(scl)
);

// Clock generation
initial begin
    clk = 0;
    forever #50 clk = ~clk; // 10MHz clock (100ns period)
end

// Test stimulus
reg test_failed = 0;
initial begin
    // Initialize Inputs
    rst = 1;
    start = 0;
    din = 8'h00;
    
    // Wait 100ns for global reset
    #100;
    rst = 0;
    
    // Test Case 1: Send data 0xA5
    din = 8'hA5;
    start = 1;
    #100;
    start = 0;
    
    // Wait for transmission to complete (about 100us for 8 bits at 100kHz)
    #100000;
    
    // Check if SCL and SDA are high (IDLE state)
    if (scl !== 1'b1 || sda !== 1'b1) begin
        $display("Error: Test Case 1 - After transmission, expected SCL=1, SDA=1, got SCL=%b, SDA=%b", scl, sda);
        test_failed = 1;
    end
    
    // Test Case 2: Send data 0x5A
    din = 8'h5A;
    start = 1;
    #100;
    start = 0;
    
    // Wait for transmission to complete
    #100000;
    
    // Check if SCL and SDA are high (IDLE state)
    if (scl !== 1'b1 || sda !== 1'b1) begin
        $display("Error: Test Case 2 - After transmission, expected SCL=1, SDA=1, got SCL=%b, SDA=%b", scl, sda);
        test_failed = 1;
    end
    
    // Test Case 3: Reset during transmission
    din = 8'hAA;
    start = 1;
    #100;
    start = 0;
    
    // Apply reset in middle of transmission
    #50000;
    rst = 1;
    #100;
    rst = 0;
    
    // Check if outputs went high during reset
    if (scl !== 1'b1 || sda !== 1'b1) begin
        $display("Error: Test Case 3 - After reset, expected SCL=1, SDA=1, got SCL=%b, SDA=%b", scl, sda);
        test_failed = 1;
    end
    
    // Final result
    if (test_failed) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    $finish;
end

// SDA monitoring (check for expected pattern for 0xA5)
reg [7:0] expected_data;
reg [2:0] bit_check;
initial begin
    expected_data = 8'hA5;
    bit_check = 0;
    
    // Wait for start condition (SDA falling while SCL is high)
    forever begin
        @(negedge sda);
        if (scl == 1'b1) begin
            break;
        end
    end
    #1000; // Wait past start condition
    
    // Check each data bit
    for (bit_check = 0; bit_check < 8; bit_check = bit_check + 1) begin
        @(posedge scl);
        #10; // Sample in middle of SCL high
        if (sda !== expected_data[7-bit_check]) begin
            $display("Error: Bit %d, expected %b, got %b", bit_check, expected_data[7-bit_check], sda);
            test_failed = 1;
        end
        @(negedge scl);
    end
    
    // Check stop condition (SDA rising while SCL is high)
    forever begin
        @(posedge sda);
        if (scl == 1'b1) begin
            break;
        end
    end
end

endmodule