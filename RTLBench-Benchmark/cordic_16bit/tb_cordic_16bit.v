`timescale 1ns/1ps

module tb_cordic_16bit;

// Inputs
reg clk;
reg rst;
reg signed [15:0] z;

// Outputs
wire signed [15:0] sin;
wire signed [15:0] cos;

// Instantiate the Unit Under Test (UUT)
cordic_16bit uut (
    .clk(clk),
    .rst(rst),
    .z(z),
    .sin(sin),
    .cos(cos)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test vectors and expected results
reg signed [15:0] test_angles [0:5];
reg signed [15:0] expected_sin [0:5];
reg signed [15:0] expected_cos [0:5];

integer i;
integer error_count;

function signed [15:0] abs(input signed [15:0] value);
    abs = (value < 0) ? -value : value;
endfunction

initial begin
    // Initialize test vectors
    test_angles[0] = 16'sb0000000000000000;
    expected_sin[0] = 16'sb0000000000000000;
    expected_cos[0] = 16'sb0001001101101110;
    
    test_angles[1] = 16'sb0010000000000000;
    expected_sin[1] = 16'sb0000110011001111;
    expected_cos[1] = 16'sb0000110011001111;
    
    test_angles[2] = 16'sb0100000000000000;
    expected_sin[2] = 16'sb0001001101101110;
    expected_cos[2] = 16'sb0000000000000000;
    
    test_angles[3] = 16'sb0110000000000000;
    expected_sin[3] = 16'sb0000110011001111;
    expected_cos[3] = 16'sb1111001100110001;
    
    test_angles[4] = 16'sb1110000000000000;
    expected_sin[4] = 16'sb1111001100110001;
    expected_cos[4] = 16'sb0000110011001111;
    
    test_angles[5] = 16'sb0011111111111111;
    expected_sin[5] = 16'sb0001001101101110;
    expected_cos[5] = 16'sb0000000000000010;

    // Initialize signals
    rst = 1;
    z = 0;
    error_count = 0;

    // Reset the design
    #20;
    rst = 0;
    #20;

    // Run tests
    for (i = 0; i < 6; i = i + 1) begin
        z = test_angles[i];
        @(posedge clk);
        // Wait fixed number of cycles for output to settle
        repeat(20) @(posedge clk);
        
        if (abs(sin - expected_sin[i]) > abs(expected_sin[i] >>> 4)) begin
            $display("Error: Test case %0d failed", i);
            $display("Input angle: %h", z);
            $display("Output sin: %h, Expected sin: %h", sin, expected_sin[i]);
            $display("Output cos: %h, Expected cos: %h", cos, expected_cos[i]);
            error_count = error_count + 1;
        end else if (abs(cos - expected_cos[i]) > abs(expected_cos[i] >>> 4)) begin
            $display("Error: Test case %0d failed", i);
            $display("Input angle: %h", z);
            $display("Output sin: %h, Expected sin: %h", sin, expected_sin[i]);
            $display("Output cos: %h, Expected cos: %h", cos, expected_cos[i]);
            error_count = error_count + 1;
        end
    end

    // Final summary
    if (error_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end

    $finish;
end

endmodule
