`timescale 1ns/1ps

module tb_rice_cooker_controller;

// Inputs
reg clk;
reg rst;
reg [1:0] mode;
reg start;

// Outputs
wire heater;
wire keep_warm;
wire done;

// Instantiate the Unit Under Test (UUT)
rice_cooker_controller uut (
    .clk(clk),
    .rst(rst),
    .mode(mode),
    .start(start),
    .heater(heater),
    .keep_warm(keep_warm),
    .done(done)
);

integer error_count;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize Inputs
    rst = 1;
    mode = 2'b00;
    start = 0;
    
    // Variables to track test results
    error_count = 0;
    
    // Reset the system
    #10;
    rst = 0;
    #10;
    
    // Test case 1: IDLE state
    if (heater !== 0 || keep_warm !== 0 || done !== 0) begin
        $display("Error: Test case 1 - IDLE state failed");
        $display("Input: mode=%b, start=%b", mode, start);
        $display("Expected: heater=0, keep_warm=0, done=0");
        $display("Got: heater=%b, keep_warm=%b, done=%b", heater, keep_warm, done);
        error_count = error_count + 1;
    end
    
    // Test case 2: COOK mode
    mode = 2'b00;
    start = 1;
    #10;
    start = 0;
    #10;
    if (heater !== 1 || keep_warm !== 0 || done !== 0) begin
        $display("Error: Test case 2 - COOK mode failed");
        $display("Input: mode=%b, start=%b", mode, start);
        $display("Expected: heater=1, keep_warm=0, done=0");
        $display("Got: heater=%b, keep_warm=%b, done=%b", heater, keep_warm, done);
        error_count = error_count + 1;
    end
    
    // Transition to WARMING state
    #20;
    if (heater !== 0 || keep_warm !== 1 || done !== 0) begin
        $display("Error: Transition to WARMING state failed");
        $display("Expected: heater=0, keep_warm=1, done=0");
        $display("Got: heater=%b, keep_warm=%b, done=%b", heater, keep_warm, done);
        error_count = error_count + 1;
    end
    
    // Transition to FINISHED state
    #20;
    if (heater !== 0 || keep_warm !== 0 || done !== 1) begin
        $display("Error: Transition to FINISHED state failed");
        $display("Expected: heater=0, keep_warm=0, done=1");
        $display("Got: heater=%b, keep_warm=%b, done=%b", heater, keep_warm, done);
        error_count = error_count + 1;
    end
    
    // Test case 3: PORRIDGE mode
    mode = 2'b10;
    start = 1;
    #10;
    start = 0;
    #10;
    if (heater !== 1 || keep_warm !== 0 || done !== 0) begin
        $display("Error: Test case 3 - PORRIDGE mode failed");
        $display("Input: mode=%b, start=%b", mode, start);
        $display("Expected: heater=1, keep_warm=0, done=0");
        $display("Got: heater=%b, keep_warm=%b, done=%b", heater, keep_warm, done);
        error_count = error_count + 1;
    end
    
    // Test case 4: WARMING mode
    mode = 2'b01;
    start = 1;
    #10;
    start = 0;
    #10;
    if (heater !== 0 || keep_warm !== 1 || done !== 0) begin
        $display("Error: Test case 4 - WARMING mode failed");
        $display("Input: mode=%b, start=%b", mode, start);
        $display("Expected: heater=0, keep_warm=1, done=0");
        $display("Got: heater=%b, keep_warm=%b, done=%b", heater, keep_warm, done);
        error_count = error_count + 1;
    end
    
    // Final check
    #50;
    if (heater !== 0 || keep_warm !== 0 || done !== 0) begin
        $display("Error: Final state check failed");
        $display("Expected: heater=0, keep_warm=0, done=0");
        $display("Got: heater=%b, keep_warm=%b, done=%b", heater, keep_warm, done);
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