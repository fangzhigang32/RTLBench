`timescale 1ns/1ps

module tb_temp_sensor_interface;

// Inputs
reg clk;
reg rst;
reg sensor_data;

// Outputs
wire [7:0] temp;

// Instantiate the Unit Under Test (UUT)
temp_sensor_interface uut (
    .clk(clk),
    .rst(rst),
    .sensor_data(sensor_data),
    .temp(temp)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
integer error_count = 0;

initial begin
    // Initialize Inputs
    rst = 1;
    sensor_data = 0;
    
    // Apply reset
    #20;
    rst = 0;
    
    // Test case 1: Send 8'b10101010
    #10;
    sensor_data = 1; // bit 7
    #10;
    sensor_data = 0; // bit 6
    #10;
    sensor_data = 1; // bit 5
    #10;
    sensor_data = 0; // bit 4
    #10;
    sensor_data = 1; // bit 3
    #10;
    sensor_data = 0; // bit 2
    #10;
    sensor_data = 1; // bit 1
    #10;
    sensor_data = 0; // bit 0
    
    // Check output
    #15;
    if (temp !== 8'b10101010) begin
        $display("Error: Test case 1 - Input: 8'b10101010, Output: %b, Expected: 8'b10101010", temp);
        error_count = error_count + 1;
    end
    
    // Test case 2: Send 8'b11001100
    #10;
    sensor_data = 1; // bit 7
    #10;
    sensor_data = 1; // bit 6
    #10;
    sensor_data = 0; // bit 5
    #10;
    sensor_data = 0; // bit 4
    #10;
    sensor_data = 1; // bit 3
    #10;
    sensor_data = 1; // bit 2
    #10;
    sensor_data = 0; // bit 1
    #10;
    sensor_data = 0; // bit 0
    
    // Check output
    #15;
    if (temp !== 8'b11001100) begin
        $display("Error: Test case 2 - Input: 8'b11001100, Output: %b, Expected: 8'b11001100", temp);
        error_count = error_count + 1;
    end
    
    // Test case 3: Reset during operation
    #10;
    sensor_data = 1; // bit 7
    #10;
    sensor_data = 0; // bit 6
    #10;
    sensor_data = 1; // bit 5
    #10;
    rst = 1; // Assert reset
    #10;
    rst = 0;
    
    // Check if reset cleared the output
    #15;
    if (temp !== 8'b0) begin
        $display("Error: Test case 3 - After reset, Output: %b, Expected: 8'b0", temp);
        error_count = error_count + 1;
    end
    
    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end
    
    $finish;
end

endmodule