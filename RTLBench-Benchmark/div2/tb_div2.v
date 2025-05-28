`timescale 1ns/1ps

module tb_div2();

// Inputs
reg clk;
reg rst;

// Outputs
wire clk_out;

// Instantiate the Unit Under Test (UUT)
div2 uut (
    .clk(clk),
    .rst(rst),
    .clk_out(clk_out)
);

reg last_clk_out;

integer error_count;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock (10ns period)
end

// Test stimulus and checking
initial begin
    error_count = 0;
    
    // Initialize Inputs
    rst = 1;
    
    // Wait for two clock cycles to ensure stable initial state
    repeat(2) @(posedge clk);
    
    // Release reset
    rst = 0;
    
    // Verify initial state after reset
    @(posedge clk); // Wait for reset to take effect
    if (clk_out !== 1'b0) begin
        $display("Error: clk_out should be 0 after reset, got %b", clk_out);
        error_count = error_count + 1;
    end
    
    // Store initial clk_out value for toggle checking
    last_clk_out = clk_out;
    
    // Check toggle behavior for 4 cycles
    repeat(4) begin
        @(posedge clk); // Wait for next clock edge
        if (clk_out === last_clk_out) begin
            $display("Error: clk_out did not toggle, remains %b", clk_out);
            error_count = error_count + 1;
        end
        last_clk_out = clk_out; // Update last value
    end
    
    // Test reset during operation
    @(posedge clk);
    rst = 1;
    @(posedge clk); // Wait for reset to take effect
    if (clk_out !== 1'b0) begin
        $display("Error: clk_out should be 0 after reset, got %b", clk_out);
        error_count = error_count + 1;
    end
    
    // Release reset and check toggle again
    rst = 0;
    last_clk_out = clk_out;
    @(posedge clk);
    if (clk_out === last_clk_out) begin
        $display("Error: clk_out did not toggle after reset release, remains %b", clk_out);
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