`timescale 1ns/1ps

module tb_crc16();

reg clk;
reg rst;
reg en;
reg [7:0] d;
wire [15:0] c;

// Instantiate the DUT
crc16 dut (
    .clk(clk),
    .rst(rst),
    .en(en),
    .d(d),
    .c(c)
);

reg error_flag;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    error_flag = 0;
    
    // Initialize inputs
    rst = 1;
    en = 0;
    d = 8'h00;
    
    // Reset sequence
    #10;
    rst = 0;
    en = 1;
    
    // Test case 1: Single byte 0x00
    d = 8'h00;
    #10;
    if (c !== 16'hC0C1) begin
        $display("Error case 1: Input=%h, Output=%h, Expected=16'hC0C1", d, c);
        error_flag = 1;
    end
    
    // Test case 2: Single byte 0xFF
    d = 8'hFF;
    #10;
    if (c !== 16'h0100) begin
        $display("Error case 2: Input=%h, Output=%h, Expected=16'h0100", d, c);
        error_flag = 1;
    end
    
    // Test case 3: Sequence 0x01, 0x02
    d = 8'h01;
    #10;
    d = 8'h02;
    #10;
    if (c !== 16'h0280) begin
        $display("Error case 3: Input sequence 01->02, Output=%h, Expected=16'h0280", c);
        error_flag = 1;
    end
    
    // Test case 4: Disable check (multiple cycles)
    en = 0;
    d = 8'hAA;
    #20; // Check for two cycles
    if (c !== 16'h0280) begin
        $display("Error case 4: Input=%h (disabled), Output=%h, Expected=16'h0280 (no change when disabled)", d, c);
        error_flag = 1;
    end
    
    // Test case 5: Reset check
    rst = 1;
    #10;
    if (c !== 16'hFFFF) begin
        $display("Error case 5: After reset, Output=%h, Expected=16'hFFFF (reset value)", c);
        error_flag = 1;
    end
    
    // Test case 6: Boundary input (three 0xFF bytes)
    rst = 0;
    en = 1;
    d = 8'hFF;
    #10;
    d = 8'hFF;
    #10;
    d = 8'hFF;
    #10;
    if (c !== 16'h4100) begin
        $display("Error case 6: Input sequence FF->FF->FF, Output=%h, Expected=16'h4100", c);
        error_flag = 1;
    end
    
    // Test case 7: Reset and enable concurrent
    rst = 1;
    en = 1;
    d = 8'h55;
    #10;
    rst = 0;
    #10;
    if (c !== 16'hC0C1) begin
        $display("Error case 7: Input=%h with reset, Output=%h, Expected=16'hC0C1", d, c);
        error_flag = 1;
    end
    
    // Final summary
    if (error_flag) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule