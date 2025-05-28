`timescale 1ns/1ps

module tb_fft_8pt_8bit;

// Parameters
parameter CLK_PERIOD = 10;

// Signals
reg clk;
reg rst;
reg signed [7:0] x_re;
reg signed [7:0] x_im;
wire signed [7:0] y_re;
wire signed [7:0] y_im;

// Expected outputs for test cases
reg signed [7:0] expected_re [0:7];
reg signed [7:0] expected_im [0:7];

// Error counter and loop variable
integer error_count; // Moved outside initial block
integer i; // Moved outside initial block

// Instantiate DUT
fft_8pt_8bit dut (
    .clk(clk),
    .rst(rst),
    .x_re(x_re),
    .x_im(x_im),
    .y_re(y_re),
    .y_im(y_im)
);

// Clock generation
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

// Test procedure
initial begin
    error_count = 0;
    
    // Initialize expected outputs for impulse input (1 + j0 at t=0)
    expected_re[0] = 8'sb01111111; // DC component
    expected_re[1] = 8'sb01111111;
    expected_re[2] = 8'sb01111111;
    expected_re[3] = 8'sb01111111;
    expected_re[4] = 8'sb01111111;
    expected_re[5] = 8'sb01111111;
    expected_re[6] = 8'sb01111111;
    expected_re[7] = 8'sb01111111;
    
    expected_im[0] = 8'sb00000000;
    expected_im[1] = 8'sb00000000;
    expected_im[2] = 8'sb00000000;
    expected_im[3] = 8'sb00000000;
    expected_im[4] = 8'sb00000000;
    expected_im[5] = 8'sb00000000;
    expected_im[6] = 8'sb00000000;
    expected_im[7] = 8'sb00000000;

    // Reset sequence
    rst = 1;
    x_re = 0;
    x_im = 0;
    #(CLK_PERIOD*2);
    rst = 0;
    #(CLK_PERIOD);

    // Test case 1: Impulse response (all frequency components should be equal)
    x_re = 8'sb01111111; // 1.0
    x_im = 8'sb00000000; // 0.0
    #(CLK_PERIOD);
    x_re = 0;
    x_im = 0;
    
    // Wait for computation to complete (4 stages + output)
    #(CLK_PERIOD*8);
    
    // Check outputs
    for (i = 0; i < 8; i = i + 1) begin
        if (y_re !== expected_re[i] || y_im !== expected_im[i]) begin
            $display("Error at output %0d: Input (%0d, %0d), Expected (%0d, %0d), Got (%0d, %0d)", 
                    i, 8'sb01111111, 8'sb00000000, expected_re[i], expected_im[i], y_re, y_im);
            error_count = error_count + 1;
        end
        #(CLK_PERIOD);
    end

    // Test case 2: DC input (all samples 1 + j0)
    expected_re[0] = 8'sb01111111; // DC component
    expected_re[1] = 0;
    expected_re[2] = 0;
    expected_re[3] = 0;
    expected_re[4] = 0;
    expected_re[5] = 0;
    expected_re[6] = 0;
    expected_re[7] = 0;
    
    expected_im[0] = 0;
    expected_im[1] = 0;
    expected_im[2] = 0;
    expected_im[3] = 0;
    expected_im[4] = 0;
    expected_im[5] = 0;
    expected_im[6] = 0;
    expected_im[7] = 0;

    // Apply DC input
    for (i = 0; i < 8; i = i + 1) begin
        x_re = 8'sb01111111;
        x_im = 8'sb00000000;
        #(CLK_PERIOD);
    end
    x_re = 0;
    x_im = 0;
    
    // Wait for computation to complete
    #(CLK_PERIOD*8);
    
    // Check outputs
    for (i = 0; i < 8; i = i + 1) begin
        if (y_re !== expected_re[i] || y_im !== expected_im[i]) begin
            $display("Error at output %0d: Input (%0d, %0d), Expected (%0d, %0d), Got (%0d, %0d)", 
                    i, 8'sb01111111, 8'sb00000000, expected_re[i], expected_im[i], y_re, y_im);
            error_count = error_count + 1;
        end
        #(CLK_PERIOD);
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