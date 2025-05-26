// Water Pump Controller Testbench
`timescale 1ns/1ps

module tb_water_pump_controller();

// Inputs
reg clk;
reg rst;
reg water_level;
reg manual;

// Output
wire pump;

// Instantiate the Unit Under Test (UUT)
water_pump_controller uut (
    .clk(clk),
    .rst(rst),
    .water_level(water_level),
    .manual(manual),
    .pump(pump)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test procedure
integer error_count = 0;

initial begin
    // Initialize Inputs
    rst = 1;
    water_level = 0;
    manual = 0;
    
    // Reset the system
    #10;
    rst = 0;
    
    // Test case 1: Normal operation - water level low
    water_level = 0;
    manual = 0;
    #10;
    if (pump !== 1'b1) begin
        $display("Error: Test case 1 failed");
        $display("Input: water_level=%b, manual=%b", water_level, manual);
        $display("Output: pump=%b", pump);
        $display("Expected: pump=1");
        error_count = error_count + 1;
    end
    
    // Test case 2: Normal operation - water level high
    water_level = 1;
    manual = 0;
    #10;
    if (pump !== 1'b0) begin
        $display("Error: Test case 2 failed");
        $display("Input: water_level=%b, manual=%b", water_level, manual);
        $display("Output: pump=%b", pump);
        $display("Expected: pump=0");
        error_count = error_count + 1;
    end
    
    // Test case 3: Manual override - water level high
    water_level = 1;
    manual = 1;
    #10;
    if (pump !== 1'b1) begin
        $display("Error: Test case 3 failed");
        $display("Input: water_level=%b, manual=%b", water_level, manual);
        $display("Output: pump=%b", pump);
        $display("Expected: pump=1");
        error_count = error_count + 1;
    end
    
    // Test case 4: Manual override - water level low
    water_level = 0;
    manual = 1;
    #10;
    if (pump !== 1'b1) begin
        $display("Error: Test case 4 failed");
        $display("Input: water_level=%b, manual=%b", water_level, manual);
        $display("Output: pump=%b", pump);
        $display("Expected: pump=1");
        error_count = error_count + 1;
    end
    
    // Test case 5: Reset condition
    rst = 1;
    #10;
    if (pump !== 1'b0) begin
        $display("Error: Test case 5 failed");
        $display("Input: rst=%b", rst);
        $display("Output: pump=%b", pump);
        $display("Expected: pump=0");
        error_count = error_count + 1;
    end
    
    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end
    else begin
        $display("Exist Function Error");
    end
    
    $finish;
end

endmodule