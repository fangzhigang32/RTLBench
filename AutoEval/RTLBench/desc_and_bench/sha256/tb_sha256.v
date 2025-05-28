`timescale 1ns/1ps

module tb_sha256();

// Inputs
reg clk;
reg rst;
reg start;
reg [511:0] d;

// Outputs
wire [255:0] h;
wire done;

// Instantiate the Unit Under Test (UUT)
sha256 uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .d(d),
    .h(h),
    .done(done)
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
    start = 0;
    d = 0;
    
    // Wait 100 ns for global reset
    #100;
    rst = 0;
    
    // Test case 1: Empty message
    #10;
    start = 1;
    d = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    #10;
    start = 0;
    
    // Wait for completion
    wait(done);
    #10;
    
    // Check output against known hash of empty string
    if (h !== 256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855) begin
        test_failed = 1;
        $display("Test case 1 failed");
        $display("Input:    80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
        $display("Expected: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
        $display("Got:      %h", h);
    end
    
    // Test case 2: "abc" message
    #100;
    start = 1;
    d = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
    #10;
    start = 0;
    
    // Wait for completion
    wait(done);
    #10;
    
    // Check output against known hash of "abc"
    if (h !== 256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad) begin
        test_failed = 1;
        $display("Test case 2 failed");
        $display("Input:    61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018");
        $display("Expected: ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad");
        $display("Got:      %h", h);
    end
    
    // Add more test cases as needed
    
    #100;
    if (test_failed) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule