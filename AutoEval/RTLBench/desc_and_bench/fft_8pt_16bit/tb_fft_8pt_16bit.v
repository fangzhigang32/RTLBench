`timescale 1ns/1ps

module tb_fft_8pt_16bit;

// Parameters
parameter CLK_PERIOD = 10;

// Signals
reg clk;
reg rst;
reg signed [15:0] x_re;
reg signed [15:0] x_im;
wire signed [15:0] y_re;
wire signed [15:0] y_im;

// Instantiate DUT
fft_8pt_16bit dut (
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

// Test vectors for 8-point FFT
reg signed [15:0] test_inputs_re [0:7];
reg signed [15:0] test_inputs_im [0:7];
reg signed [15:0] expected_outputs_re [0:7];
reg signed [15:0] expected_outputs_im [0:7];

initial begin
    test_inputs_re[0] = 16'h7FFF;
    test_inputs_re[1] = 16'h0000;
    test_inputs_re[2] = 16'h0000;
    test_inputs_re[3] = 16'h0000;
    test_inputs_re[4] = 16'h0000;
    test_inputs_re[5] = 16'h0000;
    test_inputs_re[6] = 16'h0000;
    test_inputs_re[7] = 16'h0000;

    test_inputs_im[0] = 16'h0000;
    test_inputs_im[1] = 16'h0000;
    test_inputs_im[2] = 16'h0000;
    test_inputs_im[3] = 16'h0000;
    test_inputs_im[4] = 16'h0000;
    test_inputs_im[5] = 16'h0000;
    test_inputs_im[6] = 16'h0000;
    test_inputs_im[7] = 16'h0000;

    expected_outputs_re[0] = 16'h7FFF;
    expected_outputs_re[1] = 16'h7FFF;
    expected_outputs_re[2] = 16'h7FFF;
    expected_outputs_re[3] = 16'h7FFF;
    expected_outputs_re[4] = 16'h7FFF;
    expected_outputs_re[5] = 16'h7FFF;
    expected_outputs_re[6] = 16'h7FFF;
    expected_outputs_re[7] = 16'h7FFF;

    expected_outputs_im[0] = 16'h0000;
    expected_outputs_im[1] = 16'h0000;
    expected_outputs_im[2] = 16'h0000;
    expected_outputs_im[3] = 16'h0000;
    expected_outputs_im[4] = 16'h0000;
    expected_outputs_im[5] = 16'h0000;
    expected_outputs_im[6] = 16'h0000;
    expected_outputs_im[7] = 16'h0000;
end

integer i, j;
integer error_count;

initial begin
    // Initialize
    rst = 1;
    x_re = 0;
    x_im = 0;
    error_count = 0;
    
    // Reset
    #(CLK_PERIOD*2);
    rst = 0;
    
    // Apply test vectors
    for (i = 0; i < 8; i = i + 1) begin
        x_re = test_inputs_re[i];
        x_im = test_inputs_im[i];
        #CLK_PERIOD;
    end
    
    // Wait for processing to complete (need more time for pipeline)
    #(CLK_PERIOD*30);
    
    // Read outputs and compare
    for (j = 0; j < 8; j = j + 1) begin
        if (y_re !== expected_outputs_re[j] || y_im !== expected_outputs_im[j]) begin
            $display("Error at output %0d: Input (%h, %h), Expected (%h, %h), Got (%h, %h)",
                     j, test_inputs_re[j], test_inputs_im[j], expected_outputs_re[j], expected_outputs_im[j], y_re, y_im);
            error_count = error_count + 1;
        end
        #CLK_PERIOD;
    end
    
    // Test summary
    if (error_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end
    
    $finish;
end

endmodule
