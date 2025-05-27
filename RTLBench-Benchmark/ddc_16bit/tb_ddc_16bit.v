`timescale 1ns/1ps

module tb_ddc_16bit();

// Testbench parameters
parameter CLK_PERIOD = 10;              // Clock period in ns
parameter TEST_SAMPLES = 1000;         // Number of test samples
parameter NCO_FREQ = 0.25;             // NCO frequency (normalized to sampling rate)
parameter PI = 3.141592653589793;      // Pi constant for sine wave generation
parameter FILTER_SETTLING = 50;        // Filter settling time in clock cycles

// DUT signals
reg clk;
reg rst;
reg signed [15:0] x;
wire signed [15:0] i;
wire signed [15:0] q;

// Expected outputs
reg signed [15:0] expected_i;
reg signed [15:0] expected_q;

// Instantiate DUT
ddc_16bit dut (
    .clk(clk),
    .rst(rst),
    .x(x),
    .i(i),
    .q(q)
);

// Clock generation
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

// VCD dump for waveform analysis
initial begin
    $dumpfile("ddc_16bit_tb.vcd");
    $dumpvars(0, tb_ddc_16bit);
end

// Reset generation
initial begin
    rst = 1;
    #(CLK_PERIOD*2 + 3.5); // Asynchronous reset (non-edge aligned)
    rst = 0;
    #(CLK_PERIOD*FILTER_SETTLING); // Wait for filter settling
end

// Stimulus and checking
integer test_count;
integer error_count;
real phase;
initial begin
    error_count = 0;
    x = 16'd0;
    phase = 0.0;
    #(CLK_PERIOD*3); // Wait for initial reset

    // Test case 1: DC input
    x = 16'h4000; // DC input (0.5 in Q15 format)
    #(CLK_PERIOD*FILTER_SETTLING); // Wait for filter settling
    
    expected_i = 16'h1000; // Approximate DC gain after mixing and filtering
    expected_q = 16'h0000; // No Q component for DC input
    
    if (i !== expected_i || q !== expected_q) begin
        $display("Error in Test Case 1 (DC Input):");
        $display("Input: %h", x);
        $display("Output: i=%h, q=%h", i, q);
        $display("Expected: i=%h, q=%h", expected_i, expected_q);
        error_count = error_count + 1;
    end

    // Test case 2: Sinusoidal input
    for (test_count = 0; test_count < TEST_SAMPLES; test_count = test_count + 1) begin
        x = $rtoi(32767 * $sin(2.0 * PI * 0.26 * test_count)); // Q15 format
        phase = phase + 2.0 * PI * 0.01; // Frequency offset = 0.26 - 0.25 = 0.01
        #(CLK_PERIOD);
        
        if (test_count > FILTER_SETTLING) begin
            expected_i = $rtoi(16384 * $cos(phase)); // Half amplitude due to mixing
            expected_q = $rtoi(16384 * $sin(phase)); // 90-degree phase shift
            
            if ($abs(i - expected_i) > 16'h0800 || $abs(q - expected_q) > 16'h0800) begin
                $display("Error in Test Case 2 (Sinusoidal Input) at time %0t:", $time);
                $display("Input: %h", x);
                $display("Output: i=%h, q=%h", i, q);
                $display("Expected: i=%h, q=%h", expected_i, expected_q);
                error_count = error_count + 1;
            end
        end
    end

    // Test case 3: Zero input
    x = 16'd0;
    #(CLK_PERIOD*FILTER_SETTLING);
    
    expected_i = 16'd0;
    expected_q = 16'd0;
    
    if (i !== expected_i || q !== expected_q) begin
        $display("Error in Test Case 3 (Zero Input):");
        $display("Input: %h", x);
        $display("Output: i=%h, q=%h", i, q);
        $display("Expected: i=%h, q=%h", expected_i, expected_q);
        error_count = error_count + 1;
    end

    // Test case 4: Asynchronous reset during operation
    x = $rtoi(32767 * $sin(2.0 * PI * 0.26 * test_count));
    #(CLK_PERIOD*10);
    rst = 1;
    #(CLK_PERIOD*0.3); // Partial cycle reset
    rst = 0;
    #(CLK_PERIOD*FILTER_SETTLING);
    
    if (i !== 16'd0 || q !== 16'd0) begin
        $display("Error in Test Case 4 (Asynchronous Reset):");
        $display("Input: %h", x);
        $display("Output: i=%h, q=%h", i, q);
        $display("Expected: i=0, q=0");
        error_count = error_count + 1;
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