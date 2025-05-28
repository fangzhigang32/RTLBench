`timescale 1ns/1ps

module tb_sync_fifo_8x8;

// Inputs
reg clk;
reg rst;
reg wr;
reg rd;
reg [7:0] din;

// Outputs
wire [7:0] dout;
wire empty;
wire full;

// Instantiate the Unit Under Test (UUT)
sync_fifo_8x8 uut (
    .clk(clk),
    .rst(rst),
    .wr(wr),
    .rd(rd),
    .din(din),
    .dout(dout),
    .empty(empty),
    .full(full)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
reg test_failed;
initial begin
    test_failed = 0;
    
    // Initialize Inputs
    rst = 1;
    wr = 0;
    rd = 0;
    din = 0;
    
    // Reset the FIFO
    #10;
    rst = 0;
    
    // Test Case 1: Write to FIFO until full
    for (integer i = 1; i <= 8; i = i + 1) begin
        #10;
        wr = 1;
        din = i;
        #10;
        wr = 0;
        if (i < 8 && full) begin
            $display("Error: Test Case 1 - FIFO full too early at i=%0d", i);
            $display("Input: wr=%b, din=%h", wr, din);
            $display("Output: full=%b", full);
            $display("Expected: full=0");
            test_failed = 1;
        end
        if (i == 8 && !full) begin
            $display("Error: Test Case 1 - FIFO not full when expected");
            $display("Input: wr=%b, din=%h", wr, din);
            $display("Output: full=%b", full);
            $display("Expected: full=1");
            test_failed = 1;
        end
    end
    
    // Test Case 2: Read from FIFO until empty
    for (integer i = 1; i <= 8; i = i + 1) begin
        #10;
        rd = 1;
        #10;
        rd = 0;
        if (dout !== i) begin
            $display("Error: Test Case 2 - Expected dout=%0d, got %0d at i=%0d", i, dout, i);
            $display("Input: rd=%b", rd);
            $display("Output: dout=%h", dout);
            $display("Expected: dout=%h", i);
            test_failed = 1;
        end
        if (i < 8 && empty) begin
            $display("Error: Test Case 2 - FIFO empty too early at i=%0d", i);
            $display("Input: rd=%b", rd);
            $display("Output: empty=%b", empty);
            $display("Expected: empty=0");
            test_failed = 1;
        end
        if (i == 8 && !empty) begin
            $display("Error: Test Case 2 - FIFO not empty when expected");
            $display("Input: rd=%b", rd);
            $display("Output: empty=%b", empty);
            $display("Expected: empty=1");
            test_failed = 1;
        end
    end
    
    // Test Case 3: Simultaneous read and write
    #10;
    wr = 1;
    din = 8'hAA;
    rd = 1;
    #10;
    wr = 0;
    rd = 0;
    if (empty) begin
        $display("Error: Test Case 3 - FIFO should not be empty after simultaneous R/W");
        $display("Input: wr=%b, rd=%b, din=%h", wr, rd, din);
        $display("Output: empty=%b", empty);
        $display("Expected: empty=0");
        test_failed = 1;
    end
    
    // Test Case 4: Write when full
    #10;
    wr = 1;
    din = 8'hFF;
    #10;
    wr = 0;
    if (count !== 3'd1) begin
        $display("Error: Test Case 4 - Count should be 1 after write to full FIFO");
        $display("Input: wr=%b, din=%h", wr, din);
        $display("Output: count=%0d", count);
        $display("Expected: count=1");
        test_failed = 1;
    end
    
    // Test Case 5: Read when empty
    #10;
    rd = 1;
    #10;
    rd = 0;
    if (!empty) begin
        $display("Error: Test Case 5 - FIFO should be empty after read");
        $display("Input: rd=%b", rd);
        $display("Output: empty=%b", empty);
        $display("Expected: empty=1");
        test_failed = 1;
    end
    
    if (test_failed) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    $finish;
end

// Count monitoring (for debugging)
wire [2:0] count = uut.count;

endmodule