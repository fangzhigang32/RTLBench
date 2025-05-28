`timescale 1ns/1ps

module tb_irrigation_controller;

// Inputs
reg clk;
reg rst;
reg moisture;
reg manual;

// Outputs
wire irrigate;

// Instantiate the Unit Under Test (UUT)
irrigation_controller uut (
    .clk(clk),
    .rst(rst),
    .moisture(moisture),
    .manual(manual),
    .irrigate(irrigate)
);

reg error_flag;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock (10ns period)
end

// Test stimulus and checking
initial begin
    error_flag = 0;
    
    // Initialize Inputs
    rst = 1;
    moisture = 1;
    manual = 0;
    
    // Reset the system
    #20;
    rst = 0;
    #10;
    
    // Test Case 1: Normal operation - low moisture triggers irrigation
    moisture = 0;
    #20;
    if (irrigate !== 1'b1) begin
        $display("Error Case 1: Input - moisture=%b, manual=%b | Output - irrigate=%b | Expected - irrigate=1", 
                moisture, manual, irrigate);
        error_flag = 1;
    end
    
    // Wait for irrigation to complete (simplified for testbench)
    #100;
    moisture = 1;
    #20;
    if (irrigate !== 1'b0) begin
        $display("Error Case 1: Input - moisture=%b, manual=%b | Output - irrigate=%b | Expected - irrigate=0", 
                moisture, manual, irrigate);
        error_flag = 1;
    end
    
    // Test Case 2: Manual override
    manual = 1;
    #20;
    if (irrigate !== 1'b1) begin
        $display("Error Case 2: Input - moisture=%b, manual=%b | Output - irrigate=%b | Expected - irrigate=1", 
                moisture, manual, irrigate);
        error_flag = 1;
    end
    
    // Test Case 3: Reset functionality
    rst = 1;
    #20;
    if (irrigate !== 1'b0) begin
        $display("Error Case 3: Input - rst=%b | Output - irrigate=%b | Expected - irrigate=0", 
                rst, irrigate);
        error_flag = 1;
    end
    
    // Test Case 4: No trigger when moisture is high and no manual
    rst = 0;
    moisture = 1;
    manual = 0;
    #100;
    if (irrigate !== 1'b0) begin
        $display("Error Case 4: Input - moisture=%b, manual=%b | Output - irrigate=%b | Expected - irrigate=0", 
                moisture, manual, irrigate);
        error_flag = 1;
    end
    
    // Final result
    if (error_flag) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    
    $finish;
end

endmodule