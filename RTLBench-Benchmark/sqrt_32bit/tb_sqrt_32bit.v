`timescale 1ns/1ps

module tb_sqrt_32bit;

// Inputs
reg [31:0] d;

// Outputs
wire [15:0] s;

// Instantiate the Unit Under Test (UUT)
sqrt_32bit uut (
    .d(d),
    .s(s)
);

integer i;
integer error_count;

initial begin
    error_count = 0;
    
    // Test case 1: Zero input
    d = 32'd0;
    #10;
    if (s !== 16'd0) begin
        $display("Error: Input=%d, Output=%d, Expected=%d", d, s, 16'd0);
        error_count = error_count + 1;
    end
    
    // Test case 2: Perfect square
    d = 32'd65536;
    #10;
    if (s !== 16'd256) begin
        $display("Error: Input=%d, Output=%d, Expected=%d", d, s, 16'd256);
        error_count = error_count + 1;
    end
    
    // Test case 3: Non-perfect square
    d = 32'd123456;
    #10;
    if (s !== 16'd351) begin
        $display("Error: Input=%d, Output=%d, Expected=%d", d, s, 16'd351);
        error_count = error_count + 1;
    end
    
    // Test case 4: Maximum 32-bit value
    d = 32'hFFFFFFFF;
    #10;
    if (s !== 16'd65535) begin
        $display("Error: Input=%d, Output=%d, Expected=%d", d, s, 16'd65535);
        error_count = error_count + 1;
    end
    
    // Test case 5: Random values
    for (i = 0; i < 10; i = i + 1) begin
        d = $random;
        #10;
        // No output for random test cases unless they fail
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