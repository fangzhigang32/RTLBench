`timescale 1ns/1ps

module tb_gray_counter_4bit;

// Inputs
reg clk;
reg rst;
reg en;

// Outputs
wire [3:0] q;

// Instantiate the Unit Under Test (UUT)
gray_counter_4bit uut (
    .clk(clk),
    .rst(rst),
    .en(en),
    .q(q)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Expected gray code sequence
reg [3:0] expected_gray [0:15];
initial begin
    expected_gray[0] = 4'b0000;
    expected_gray[1] = 4'b0001;
    expected_gray[2] = 4'b0011;
    expected_gray[3] = 4'b0010;
    expected_gray[4] = 4'b0110;
    expected_gray[5] = 4'b0111;
    expected_gray[6] = 4'b0101;
    expected_gray[7] = 4'b0100;
    expected_gray[8] = 4'b1100;
    expected_gray[9] = 4'b1101;
    expected_gray[10] = 4'b1111;
    expected_gray[11] = 4'b1110;
    expected_gray[12] = 4'b1010;
    expected_gray[13] = 4'b1011;
    expected_gray[14] = 4'b1001;
    expected_gray[15] = 4'b1000;
end

integer i;
integer error_count;
integer test_case_count;

initial begin
    // Initialize Inputs
    rst = 1;
    en = 0;
    error_count = 0;
    test_case_count = 0;

    // Wait for global reset
    #10;
    rst = 0;
    en = 1;

    // Test all 16 states
    for (i = 0; i < 16; i = i + 1) begin
        test_case_count = test_case_count + 1;
        @(posedge clk);
        if (q !== expected_gray[i]) begin
            $display("Error: Test case %0d failed", test_case_count);
            $display("Input: en=%b, rst=%b", en, rst);
            $display("Output: %b", q);
            $display("Expected: %b", expected_gray[i]);
            error_count = error_count + 1;
        end
        #1; // Small delay after clock edge for better visibility
    end

    // Test disable
    test_case_count = test_case_count + 1;
    en = 0;
    @(posedge clk);
    if (q !== expected_gray[15]) begin
        $display("Error: Test case %0d failed", test_case_count);
        $display("Input: en=%b, rst=%b", en, rst);
        $display("Output: %b", q);
        $display("Expected: %b", expected_gray[15]);
        error_count = error_count + 1;
    end

    // Test reset
    test_case_count = test_case_count + 1;
    rst = 1;
    @(posedge clk);
    if (q !== 4'b0000) begin
        $display("Error: Test case %0d failed", test_case_count);
        $display("Input: en=%b, rst=%b", en, rst);
        $display("Output: %b", q);
        $display("Expected: 0000");
        error_count = error_count + 1;
    end

    // Summary
    if (error_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end

    $finish;
end

endmodule