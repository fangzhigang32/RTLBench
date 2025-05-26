`timescale 1ns/1ps

module tb_cordic_8bit;

// Parameters
parameter CLK_PERIOD = 10; // Clock period in ns
parameter PIPELINE_STAGES = 8; // Assumed pipeline stages for 8-bit precision
parameter TOLERANCE = 1; // Allow ±1 LSB error

// Inputs
reg clk;
reg rst;
reg [7:0] z;

// Outputs
wire signed [7:0] sin;
wire signed [7:0] cos;

// Instantiate the Unit Under Test (UUT)
cordic_8bit uut (
    .clk(clk),
    .rst(rst),
    .z(z),
    .sin(sin),
    .cos(cos)
);

// Clock generation
always begin
    #(CLK_PERIOD/2) clk = ~clk;
end

// Test vectors and expected results
reg [7:0] test_angles [0:7];
reg signed [7:0] expected_sin [0:7];
reg signed [7:0] expected_cos [0:7];

integer i;
integer error_count;

// Function to check if output is within tolerance
function check_within_tolerance;
    input signed [7:0] actual;
    input signed [7:0] expected;
    begin
        check_within_tolerance = (actual >= expected - TOLERANCE) && (actual <= expected + TOLERANCE);
    end
endfunction

initial begin
    // Initialize test vectors
    test_angles[0] = 8'b00000000;  // 0 degrees
    expected_sin[0] = 8'b00000000;
    expected_cos[0] = 8'b01111111;
    
    test_angles[1] = 8'b00100000;  // 45 degrees
    expected_sin[1] = 8'b01001101;
    expected_cos[1] = 8'b01001101;
    
    test_angles[2] = 8'b01000000;  // 90 degrees
    expected_sin[2] = 8'b01111111;
    expected_cos[2] = 8'b00000000;
    
    test_angles[3] = 8'b01100000;  // 135 degrees
    expected_sin[3] = 8'b01001101;
    expected_cos[3] = 8'b10110011;
    
    test_angles[4] = 8'b10000000;  // 180 degrees
    expected_sin[4] = 8'b00000000;
    expected_cos[4] = 8'b10000001; // -127
    
    test_angles[5] = 8'b11000000;  // 270 degrees
    expected_sin[5] = 8'b10000001; // -127
    expected_cos[5] = 8'b00000000;
    
    test_angles[6] = 8'b11100000;  // 315 degrees
    expected_sin[6] = 8'b10110011; // -77
    expected_cos[6] = 8'b01001101; // 77
    
    test_angles[7] = 8'b00010000;  // 22.5 degrees (additional test case)
    expected_sin[7] = 8'b00100110; // Approx 38
    expected_cos[7] = 8'b01100110; // Approx 102

    // Initialize inputs
    clk = 0;
    rst = 1;
    z = 0;
    error_count = 0;

    // Reset the system
    #10;
    rst = 0;
    #10;

    // Run tests
    for (i = 0; i < 8; i = i + 1) begin
        z = test_angles[i];
        #(CLK_PERIOD * PIPELINE_STAGES); // Wait for pipeline completion
        
        if (!check_within_tolerance(sin, expected_sin[i]) || 
            !check_within_tolerance(cos, expected_cos[i])) begin
            $display("Error at test case %0d:", i);
            $display("  Input angle: %b (%0d degrees)", z, (z * 360) / 256);
            $display("  Expected sin: %b (%0d), got: %b (%0d)", 
                     expected_sin[i], expected_sin[i], sin, sin);
            $display("  Expected cos: %b (%0d), got: %b (%0d)", 
                     expected_cos[i], expected_cos[i], cos, cos);
            error_count = error_count + 1;
        end
    end

    // Test asynchronous reset (optional, if design supports async reset)
    #10;
    rst = 1; // Trigger reset mid-cycle
    #3;
    rst = 0;
    #10;
    z = test_angles[0]; // Re-test 0 degrees
    #(CLK_PERIOD * PIPELINE_STAGES);
    if (!check_within_tolerance(sin, expected_sin[0]) || 
        !check_within_tolerance(cos, expected_cos[0])) begin
        $display("Error in async reset test:");
        $display("  Input angle: %b (%0d degrees)", z, (z * 360) / 256);
        $display("  Expected sin: %b (%0d), got: %b (%0d)", 
                 expected_sin[0], expected_sin[0], sin, sin);
        $display("  Expected cos: %b (%0d), got: %b (%0d)", 
                 expected_cos[0], expected_cos[0], cos, cos);
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