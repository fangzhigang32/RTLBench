`timescale 1ns/1ps

module tb_pipeline_fft_8pt();

// Inputs
reg clk;
reg rst;
reg signed [7:0] x_re;
reg signed [7:0] x_im;

// Outputs
wire signed [7:0] y_re;
wire signed [7:0] y_im;

// Instantiate the Unit Under Test (UUT)
pipeline_fft_8pt uut (
    .clk(clk),
    .rst(rst),
    .x_re(x_re),
    .x_im(x_im),
    .y_re(y_re),
    .y_im(y_im)
);

reg error_flag;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize Inputs
    rst = 1;
    x_re = 0;
    x_im = 0;
    error_flag = 0;
    
    // Wait for global reset
    #20;
    rst = 0;
    
    // Test case 1: Input = 1 + 0j
    x_re = 8'sb01000000; // 1.0
    x_im = 8'sb00000000; // 0.0
    #100; // Increased delay to account for full pipeline latency
    
    // Check output (should be 1 + 0j)
    if (y_re !== 8'sb01000000 || y_im !== 8'sb00000000) begin
        $display("Test case 1 failed: Input %b + j%b, Got %b + j%b, Expected 01000000 + j00000000", 
                x_re, x_im, y_re, y_im);
        error_flag = 1;
    end
    
    // Test case 2: Input = 0 + 1j
    x_re = 8'sb00000000; // 0.0
    x_im = 8'sb01000000; // 1.0
    #100;
    
    // Check output (should be 0 - 1j)
    if (y_re !== 8'sb00000000 || y_im !== 8'sb11000000) begin
        $display("Test case 2 failed: Input %b + j%b, Got %b + j%b, Expected 00000000 + j11000000", 
                x_re, x_im, y_re, y_im);
        error_flag = 1;
    end
    
    // Test case 3: Input = 0.7071 + 0.7071j
    x_re = 8'sb00101101; // 0.7071
    x_im = 8'sb00101101; // 0.7071
    #100;
    
    // Check output (should be 0 - 1.4142j)
    if (y_re !== 8'sb00000000 || y_im !== 8'sb10101101) begin
        $display("Test case 3 failed: Input %b + j%b, Got %b + j%b, Expected 00000000 + j10101101", 
                x_re, x_im, y_re, y_im);
        error_flag = 1;
    end
    
    // Test case 4: Input = -0.5 - 0.5j
    x_re = 8'sb11000000; // -0.5
    x_im = 8'sb11000000; // -0.5
    #100;
    
    // Check output (should be -1 + 0j)
    if (y_re !== 8'sb11000000 || y_im !== 8'sb00000000) begin
        $display("Test case 4 failed: Input %b + j%b, Got %b + j%b, Expected 11000000 + j00000000", 
                x_re, x_im, y_re, y_im);
        error_flag = 1;
    end
    
    // Finish simulation
    #20;
    if (error_flag) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule