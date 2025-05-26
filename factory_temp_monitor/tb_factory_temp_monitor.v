`timescale 1ns/1ps

module tb_factory_temp_monitor;

// Inputs
reg clk;
reg rst;
reg [7:0] temp;

// Outputs
wire alarm;
wire [7:0] temp_out;

// Instantiate the Unit Under Test (UUT)
factory_temp_monitor uut (
    .clk(clk),
    .rst(rst),
    .temp(temp),
    .alarm(alarm),
    .temp_out(temp_out)
);

reg test_failed;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize Inputs
    test_failed = 0;
    rst = 1;
    temp = 8'd0;
    
    // Apply reset
    #10 rst = 0;
    
    // Test case 1: Normal temperature (below threshold)
    temp = 8'd75;
    #10;
    if (alarm !== 1'b0 || temp_out !== 8'd75) begin
        $display("Error case 1: temp=75, alarm=%b (expected 0), temp_out=%d (expected 75)", alarm, temp_out);
        test_failed = 1;
    end
    
    // Test case 2: Threshold temperature
    temp = 8'd80;
    #10;
    if (alarm !== 1'b0 || temp_out !== 8'd80) begin
        $display("Error case 2: temp=80, alarm=%b (expected 0), temp_out=%d (expected 80)", alarm, temp_out);
        test_failed = 1;
    end
    
    // Test case 3: High temperature (above threshold)
    temp = 8'd85;
    #10;
    if (alarm !== 1'b1 || temp_out !== 8'd85) begin
        $display("Error case 3: temp=85, alarm=%b (expected 1), temp_out=%d (expected 85)", alarm, temp_out);
        test_failed = 1;
    end
    
    // Test case 4: Reset functionality
    rst = 1;
    #10;
    if (alarm !== 1'b0 || temp_out !== 8'd0) begin
        $display("Error case 4: after reset, alarm=%b (expected 0), temp_out=%d (expected 0)", alarm, temp_out);
        test_failed = 1;
    end
    
    // Test case 5: Edge case (maximum temperature)
    rst = 0;
    temp = 8'd255;
    #10;
    if (alarm !== 1'b1 || temp_out !== 8'd255) begin
        $display("Error case 5: temp=255, alarm=%b (expected 1), temp_out=%d (expected 255)", alarm, temp_out);
        test_failed = 1;
    end
    
    // Test case 6: Temperature change below threshold
    temp = 8'd70;
    #10;
    if (alarm !== 1'b0 || temp_out !== 8'd70) begin
        $display("Error case 6: temp=70, alarm=%b (expected 0), temp_out=%d (expected 70)", alarm, temp_out);
        test_failed = 1;
    end
    
    if (test_failed) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    
    $finish;
end

endmodule