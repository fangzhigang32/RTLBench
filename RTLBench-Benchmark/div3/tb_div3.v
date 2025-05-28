`timescale 1ns/1ps

module tb_div3();

reg clk;
reg rst;
wire clk_out;

// Instantiate the DUT
div3 uut (
    .clk(clk),
    .rst(rst),
    .clk_out(clk_out)
);

// Declare variables outside initial block for Verilog compatibility
integer error_count;
integer i;
reg [1:0] cycle_count; // Track cycles for expected output
reg expected_out;

// Clock generation: 100MHz (10ns period)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize and reset
    error_count = 0;
    cycle_count = 0;
    expected_out = 0;
    rst = 1;
    #20; // Hold reset for 2 cycles
    rst = 0;
    
    // Verify initial state after reset
    @(posedge clk); // Sample at clock edge
    if (clk_out !== 1'b0) begin
        $display("Error at %0t: Initial clk_out should be 0 after reset, got %b", $time, clk_out);
        error_count = error_count + 1;
    end
    
    // Test for 15 clock cycles (5 complete output cycles)
    for (i = 0; i < 15; i = i + 1) begin
        @(posedge clk); // Wait for rising edge
        cycle_count = (cycle_count + 1) % 3; // Update cycle counter
        
        // Expected output: high for first 1.5 cycles, low for next 1.5 cycles
        if (cycle_count == 0) begin
            expected_out = 1; // Start of high phase
        end else if (cycle_count == 2) begin
            expected_out = 0; // Start of low phase
        end
        
        // Check output
        #1; // Small delay to ensure output is stable
        if (clk_out !== expected_out) begin
            $display("Error at %0t (cycle %0d): Expected clk_out = %b, got %b", 
                     $time, i+1, expected_out, clk_out);
            error_count = error_count + 1;
        end
    end
    
    // Verify frequency and duty cycle
    // Measure one complete output cycle (3 input cycles)
    @(posedge clk_out); // Wait for first rising edge
    #1;
    if (rst !== 0) $display("Warning: Reset active during frequency test");
    @(posedge clk_out); // Wait for next rising edge
    #1;
    if ($time != 40 && $time != 70) begin // Expected period = 30ns (3 input cycles)
        $display("Error at %0t: Output period incorrect, expected 30ns", $time);
        error_count = error_count + 1;
    end
    
    // Test reset functionality during operation
    @(posedge clk);
    rst = 1;
    @(posedge clk);
    #1; // Sample after edge
    if (clk_out !== 1'b0) begin
        $display("Error at %0t: clk_out should be 0 after reset, got %b", $time, clk_out);
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