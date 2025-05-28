`timescale 1ns/1ps

module tb_pipelined_cordic_16bit;

// Parameters
localparam CLK_PERIOD = 10;
localparam PIPELINE_DELAY = 17; // 16 stages + 1 initial cycle

// Signals
reg clk;
reg rst;
reg signed [15:0] z;
wire signed [15:0] sin;
wire signed [15:0] cos;

// Instantiate DUT
pipelined_cordic_16bit dut (
    .clk(clk),
    .rst(rst),
    .z(z),
    .sin(sin),
    .cos(cos)
);

// Clock generation
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

// Test vectors and expected results
reg signed [15:0] test_angles [0:3];
reg signed [15:0] expected_sin [0:3];
reg signed [15:0] expected_cos [0:3];

initial begin
    // Initialize test vectors
    test_angles[0] = 16'h0000; // 0 degrees
    test_angles[1] = 16'h3243; // 45 degrees
    test_angles[2] = 16'h6487; // 90 degrees
    test_angles[3] = 16'h8000; // 180 degrees
    
    expected_sin[0] = 16'h0000; // sin(0) = 0
    expected_sin[1] = 16'h5A82; // sin(45) ≈ 0.7071
    expected_sin[2] = 16'h7FFF; // sin(90) ≈ 1.0
    expected_sin[3] = 16'h0000; // sin(180) ≈ 0
    
    expected_cos[0] = 16'h7FFF; // cos(0) = 1
    expected_cos[1] = 16'h5A82; // cos(45) ≈ 0.7071
    expected_cos[2] = 16'h0000; // cos(90) ≈ 0
    expected_cos[3] = 16'h8000; // cos(180) ≈ -1
end

// Test procedure
integer i;
integer error_count = 0;
initial begin
    // Initialize
    rst = 1;
    z = 0;
    #(CLK_PERIOD*2);
    rst = 0;
    #(CLK_PERIOD);

    // Run tests
    for (i = 0; i < 4; i = i + 1) begin
        z = test_angles[i];
        #(CLK_PERIOD*PIPELINE_DELAY);

        // Check results
        if (sin !== expected_sin[i] || cos !== expected_cos[i]) begin
            $display("Error at test case %0d:", i);
            $display("  Input angle: %h", z);
            $display("  Expected sin: %h, got: %h", expected_sin[i], sin);
            $display("  Expected cos: %h, got: %h", expected_cos[i], cos);
            error_count = error_count + 1;
        end
    end

    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end
    else begin
        $display("Exist Function Error");
    end

    // Finish simulation
    $finish;
end

// Monitor
initial begin
    $monitor("At time %0t: z=%h, sin=%h, cos=%h", $time, z, sin, cos);
end

endmodule