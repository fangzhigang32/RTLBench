`timescale 1ns/1ps

module tb_sequence_generator;

// Inputs
reg clk;
reg rst;

// Outputs
wire [5:0] data;

// Instantiate the Unit Under Test (UUT)
sequence_generator uut (
    .clk(clk),
    .rst(rst),
    .data(data)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Expected sequence values
reg [5:0] expected_data [0:5];
initial begin
    expected_data[0] = 6'b010110;
    expected_data[1] = 6'b101100;
    expected_data[2] = 6'b011001;
    expected_data[3] = 6'b110010;
    expected_data[4] = 6'b100101;
    expected_data[5] = 6'b001011;
end

integer i;
integer error_count;

initial begin
    // Initialize Inputs
    rst = 1;
    error_count = 0;

    // Wait for global reset
    #20;
    rst = 0;

    // Verify sequence
    for (i = 0; i < 6; i = i + 1) begin
        @(posedge clk);
        #1; // Small delay for signal stabilization
        if (data !== expected_data[i]) begin
            $display("Error at state %0d: Input: rst=%b, Output: %b, Expected: %b", 
                    i, rst, data, expected_data[i]);
            error_count = error_count + 1;
        end
    end

    // Check for reset functionality
    @(posedge clk);
    rst = 1;
    @(posedge clk);
    #1;
    if (data !== 6'b001011) begin
        $display("Reset error: Input: rst=%b, Output: %b, Expected: 001011", 
                rst, data);
        error_count = error_count + 1;
    end

    // Test summary
    if (error_count == 0) begin
        $display("No Function Error");
    end
    else begin
        $display("Exist Function Error");
    end

    $finish;
end

endmodule