`timescale 1ns/1ps

module tb_round_robin_arbiter_4;

reg clk;
reg rst;
reg [3:0] req;
wire [3:0] gnt;

// Instantiate the DUT
round_robin_arbiter_4 dut (
    .clk(clk),
    .rst(rst),
    .req(req),
    .gnt(gnt)
);

integer error_count;

// Clock generation
always begin
    #5 clk = ~clk;
end

// Test stimulus and checking
initial begin
    error_count = 0;
    
    // Initialize signals
    clk = 0;
    rst = 1;
    req = 4'b0000;
    
    // Reset sequence
    #10 rst = 0;
    
    // Test case 1: Single request
    req = 4'b0001;
    #10;
    if (gnt !== 4'b0001) begin
        $display("Error: Test case 1 - Input: %b, Output: %b, Expected: 4'b0001", req, gnt);
        error_count = error_count + 1;
    end
    
    // Test case 2: Multiple requests - round robin
    req = 4'b0011;
    #10;
    if (gnt !== 4'b0010) begin
        $display("Error: Test case 2 - Input: %b, Output: %b, Expected: 4'b0010", req, gnt);
        error_count = error_count + 1;
    end
    
    // Test case 3: Continue round robin
    req = 4'b0111;
    #10;
    if (gnt !== 4'b0100) begin
        $display("Error: Test case 3 - Input: %b, Output: %b, Expected: 4'b0100", req, gnt);
        error_count = error_count + 1;
    end
    
    // Test case 4: Wrap around priority
    req = 4'b1111;
    #10;
    if (gnt !== 4'b1000) begin
        $display("Error: Test case 4 - Input: %b, Output: %b, Expected: 4'b1000", req, gnt);
        error_count = error_count + 1;
    end
    
    // Test case 5: No requests
    req = 4'b0000;
    #10;
    if (gnt !== 4'b0000) begin
        $display("Error: Test case 5 - Input: %b, Output: %b, Expected: 4'b0000", req, gnt);
        error_count = error_count + 1;
    end
    
    // Test case 6: Priority after reset
    rst = 1;
    #10;
    rst = 0;
    req = 4'b1001;
    #10;
    if (gnt !== 4'b0001) begin
        $display("Error: Test case 6 - Input: %b, Output: %b, Expected: 4'b0001", req, gnt);
        error_count = error_count + 1;
    end
    
    // Additional test case to verify all priority transitions
    req = 4'b1111;
    #10;
    if (gnt !== 4'b0010) begin
        $display("Error: Additional test case - Input: %b, Output: %b, Expected: 4'b0010", req, gnt);
        error_count = error_count + 1;
    end
    
    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end
    $finish;
end

endmodule