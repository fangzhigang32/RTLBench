`timescale 1ns/1ps

module tb_ring_fifo_8x8;

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
ring_fifo_8x8 uut (
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

// Test variables
integer i;
reg [7:0] expected_data;
reg test_pass;
reg any_error;

initial begin
    // Initialize Inputs
    rst = 1;
    wr = 0;
    rd = 0;
    din = 0;
    test_pass = 1;
    any_error = 0;

    // Reset the FIFO
    #10;
    rst = 0;
    #10;

    // Test 1: Check empty flag after reset
    if (!empty) begin
        $display("Error: FIFO not empty after reset. Input: rst=%b, Output: empty=%b, Expected: empty=1", 
                rst, empty);
        test_pass = 0;
        any_error = 1;
    end

    // Test 2: Write 8 values (fill FIFO)
    for (i = 0; i < 8; i = i + 1) begin
        wr = 1;
        din = i + 1;
        #10;
        wr = 0;
        #10;
    end

    // Check full flag
    if (!full) begin
        $display("Error: FIFO not full after 8 writes. Input: wr=%b, din=%h, Output: full=%b, Expected: full=1", 
                wr, din, full);
        test_pass = 0;
        any_error = 1;
    end

    // Test 3: Try to write when full (should not write)
    wr = 1;
    din = 8'hFF;
    #10;
    wr = 0;
    if (full !== 1'b1) begin
        $display("Error: FIFO full flag incorrect during overflow attempt. Input: wr=%b, din=%h, Output: full=%b, Expected: full=1", 
                wr, din, full);
        test_pass = 0;
        any_error = 1;
    end

    // Test 4: Read 8 values (empty FIFO)
    for (i = 0; i < 8; i = i + 1) begin
        expected_data = i + 1;
        rd = 1;
        #10;
        if (dout !== expected_data) begin
            $display("Error: Read data mismatch at position %d. Input: rd=%b, Output: dout=%h, Expected: %h", 
                     i, rd, dout, expected_data);
            test_pass = 0;
            any_error = 1;
        end
        rd = 0;
        #10;
    end

    // Check empty flag
    if (!empty) begin
        $display("Error: FIFO not empty after 8 reads. Input: rd=%b, Output: empty=%b, Expected: empty=1", 
                rd, empty);
        test_pass = 0;
        any_error = 1;
    end

    // Test 5: Try to read when empty (should not read)
    rd = 1;
    #10;
    rd = 0;
    if (empty !== 1'b1) begin
        $display("Error: FIFO empty flag incorrect during underflow attempt. Input: rd=%b, Output: empty=%b, Expected: empty=1", 
                rd, empty);
        test_pass = 0;
        any_error = 1;
    end

    // Test 6: Simultaneous read and write
    wr = 1;
    rd = 1;
    din = 8'hAA;
    #10;
    wr = 0;
    rd = 0;
    #10;

    // Final result
    if (any_error) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end

    $finish;
end

endmodule