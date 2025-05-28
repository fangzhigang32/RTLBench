`timescale 1ns/1ps

module tb_t_ff;

// Inputs
reg clk;
reg rst;
reg t;

// Outputs
wire q;

// Instantiate the Unit Under Test (UUT)
t_ff uut (
    .clk(clk),
    .rst(rst),
    .t(t),
    .q(q)
);

integer error_count;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus and checking
initial begin
    error_count = 0;
    
    // Initialize Inputs
    rst = 1;
    t = 0;
    
    // Apply reset
    #10;
    rst = 0;
    
    // Test case 1: T=0, Q should not change
    t = 0;
    #10;
    if (q !== 1'b0) begin
        $display("Error: Case 1 - Input: t=%b, Output: q=%b, Expected: q=0", t, q);
        error_count = error_count + 1;
    end
    
    // Test case 2: T=1, Q should toggle
    t = 1;
    #10;
    if (q !== 1'b1) begin
        $display("Error: Case 2 - Input: t=%b, Output: q=%b, Expected: q=1", t, q);
        error_count = error_count + 1;
    end
    
    // Test case 3: T=1, Q should toggle again
    #10;
    if (q !== 1'b0) begin
        $display("Error: Case 3 - Input: t=%b, Output: q=%b, Expected: q=0", t, q);
        error_count = error_count + 1;
    end
    
    // Test case 4: T=0, Q should not change
    t = 0;
    #10;
    if (q !== 1'b0) begin
        $display("Error: Case 4 - Input: t=%b, Output: q=%b, Expected: q=0", t, q);
        error_count = error_count + 1;
    end
    
    // Test case 5: Reset test
    rst = 1;
    #10;
    if (q !== 1'b0) begin
        $display("Error: Case 5 - Input: rst=%b, Output: q=%b, Expected: q=0", rst, q);
        error_count = error_count + 1;
    end
    
    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end
    else begin
        $display("Exist Function Error");
    end
    
    $finish;
end

endmodule