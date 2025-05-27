`timescale 1ns/1ps

module tb_d_ff;

// Inputs
reg clk;
reg rst;
reg d;

// Outputs
wire q;

// Error counter for reporting
integer error_count;

// Instantiate the Unit Under Test (UUT)
d_ff uut (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
);

// Clock generation: 10ns period (100MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus and checking
initial begin
    // Initialize inputs
    error_count = 0;
    rst = 0;
    d = 0;
    
    // Wait for initial stabilization
    #10;
    
    // Test case 1: Reset test
    rst = 1;
    #2; // Ensure setup time before clock edge
    @(posedge clk);
    #1; // Wait for propagation
    if (q !== 1'b0) begin
        $display("Error: Reset test failed at time %t. Input: rst=%b, d=%b | Output: q=%b | Expected: 0", $time, rst, d, q);
        error_count = error_count + 1;
    end
    
    // Test case 2: Data capture test
    rst = 0;
    d = 1;
    #2; // Ensure setup time
    @(posedge clk);
    #1; // Wait for propagation
    if (q !== 1'b1) begin
        $display("Error: Data capture test failed at time %t. Input: rst=%b, d=%b | Output: q=%b | Expected: 1", $time, rst, d, q);
        error_count = error_count + 1;
    end
    
    // Test case 3: Reset override test
    rst = 1;
    d = 1; // d is 1, but reset should override
    #2;
    @(posedge clk);
    #1;
    if (q !== 1'b0) begin
        $display("Error: Reset override test failed at time %t. Input: rst=%b, d=%b | Output: q=%b | Expected: 0", $time, rst, d, q);
        error_count = error_count + 1;
    end
    
    // Test case 4: Normal operation test
    rst = 0;
    d = 0;
    #2;
    @(posedge clk);
    #1;
    if (q !== 1'b0) begin
        $display("Error: Normal operation test (d=0) failed at time %t. Input: rst=%b, d=%b | Output: q=%b | Expected: 0", $time, rst, d, q);
        error_count = error_count + 1;
    end
    
    // Test case 5: Data toggle test (verify hold time)
    d = 1;
    #2;
    @(posedge clk);
    #1;
    if (q !== 1'b1) begin
        $display("Error: Data toggle test (d=1) failed at time %t. Input: rst=%b, d=%b | Output: q=%b | Expected: 1", $time, rst, d, q);
        error_count = error_count + 1;
    end
    
    // Test case 6: Rapid data change test (stress setup/hold)
    d = 0;
    #1; // Change d close to clock edge
    @(posedge clk);
    #1;
    if (q !== 1'b0) begin
        $display("Warning: Rapid data change test (d=0) may indicate setup/hold violation at time %t. Input: rst=%b, d=%b | Output: q=%b | Expected: 0", $time, rst, d, q);
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