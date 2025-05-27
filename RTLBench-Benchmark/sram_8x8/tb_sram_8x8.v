`timescale 1ns/1ps

module tb_sram_8x8;

// Inputs
reg clk;
reg we;
reg re;
reg [2:0] addr;
reg [7:0] din;

// Outputs
wire [7:0] dout;

// Local array to store written data for verification
reg [7:0] test_mem [0:7]; // Array to mimic SRAM memory for comparison

// Error flag declaration at module level
reg error_flag;

// Instantiate the Unit Under Test (UUT)
sram_8x8 uut (
    .clk(clk),
    .we(we),
    .re(re),
    .addr(addr),
    .din(din),
    .dout(dout)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus and verification
initial begin
    // Initialize error_flag
    error_flag = 0;
    
    // Initialize inputs
    we = 0;
    re = 0;
    addr = 0;
    din = 0;
    
    // Initialize test_mem
    for (integer i = 0; i < 8; i = i + 1) begin
        test_mem[i] = 8'b0;
    end
    
    // Wait for global reset
    #10;
    
    // Test case 1: Write data to all addresses
    for (integer i = 0; i < 8; i = i + 1) begin
        we = 1;
        re = 0;
        addr = i;
        din = $random;
        test_mem[i] = din; // Store written data in test_mem
        #10;
    end
    we = 0;
    
    // Test case 2: Read back data and verify
    for (integer i = 0; i < 8; i = i + 1) begin
        we = 0;
        re = 1;
        addr = i;
        #10;
        if (dout !== test_mem[i]) begin
            $display("Error at address %d: Input %h, Output %h, Expected %h", i, addr, dout, test_mem[i]);
            error_flag = 1;
        end
    end
    re = 0;
    #10;
    
    // Test case 3: Verify output is zero when re is low
    if (dout !== 8'b0) begin
        $display("Error: Output not zero when re is low. Input %h, Output %h, Expected 00", addr, dout);
        error_flag = 1;
    end
    
    // Test case 4: Simultaneous read and write
    we = 1;
    re = 1;
    addr = 3;
    din = 8'hAA;
    test_mem[3] = din; // Update test_mem with new data
    #10;
    if (dout !== test_mem[3]) begin
        $display("Error during simultaneous R/W: Input %h, Output %h, Expected %h", addr, dout, test_mem[3]);
        error_flag = 1;
    end
    
    // Test case 5: Read after write
    we = 0;
    re = 1;
    #10;
    if (dout !== 8'hAA) begin
        $display("Error reading after write: Input %h, Output %h, Expected AA", addr, dout);
        error_flag = 1;
    end
    
    if (error_flag) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule