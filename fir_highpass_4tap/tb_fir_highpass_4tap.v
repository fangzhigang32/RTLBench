`timescale 1ns/1ps

module tb_fir_highpass_4tap();

// Testbench parameters
localparam CLK_PERIOD = 10;
localparam TEST_SAMPLES = 20;

// DUT signals
reg clk;
reg rst;
reg signed [7:0] x;
wire signed [7:0] y;

// Test variables
integer i;
integer error_count;
reg signed [7:0] expected_y;

// Instantiate DUT
fir_highpass_4tap dut (
    .clk(clk),
    .rst(rst),
    .x(x),
    .y(y)
);

// Clock generation
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

// Reset generation
initial begin
    rst = 1;
    #(CLK_PERIOD*2) rst = 0;
end

// Stimulus and checking
initial begin
    error_count = 0;
    x = 0;
    #(CLK_PERIOD*3); // Wait for reset to complete

    // Test 1: Impulse response
    x = 8'sd100;
    #CLK_PERIOD;
    x = 0;
    #(CLK_PERIOD*5); // Allow pipeline to fill
    
    check_output(-8'sd12, "Impulse response h0");
    #CLK_PERIOD;
    check_output(-8'sd25, "Impulse response h1");
    #CLK_PERIOD;
    check_output(8'sd25, "Impulse response h2");
    #CLK_PERIOD;
    check_output(8'sd12, "Impulse response h3");
    #CLK_PERIOD;
    check_output(8'sd0, "Impulse response end");

    // Test 2: DC input (should be rejected by highpass)
    x = 8'sd50;
    for (i = 0; i < 10; i = i + 1) begin
        #CLK_PERIOD;
        if (i > 3) begin
            check_output(8'sd0, "DC rejection");
        end
    end

    // Test 3: High frequency input (should pass)
    for (i = 0; i < 10; i = i + 1) begin
        x = (i % 2) ? 8'sd64 : -8'sd64;
        #CLK_PERIOD;
        if (i > 3) begin
            case (i % 4)
                0: expected_y = 8'sd48;
                1: expected_y = 8'sd0;
                2: expected_y = -8'sd48;
                3: expected_y = -8'sd16;
            endcase
            check_output(expected_y, "High frequency response");
        end
    end

    // Summary
    if (error_count == 0)
        $display("No Function Error");
    else
        $display("Exist Function Error");
    $finish;
end

// Task to check output against expected value
task check_output;
    input signed [7:0] expected;
    input [80:0] test_name;
    begin
        if (y !== expected) begin
            $display("Error: input=%0d, output=%0d, expected=%0d", 
                    x, y, expected);
            error_count = error_count + 1;
        end
    end
endtask

endmodule