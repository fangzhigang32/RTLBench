`timescale 1ns/1ps

module tb_washing_machine_controller();

// Inputs
reg clk;
reg rst;
reg start;
reg [1:0] mode;

// Outputs
wire wash;
wire rinse;
wire spin;

// Instantiate the Unit Under Test (UUT)
washing_machine_controller uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .mode(mode),
    .wash(wash),
    .rinse(rinse),
    .spin(spin)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test procedure
reg test_failed;
initial begin
    test_failed = 0;
    
    // Initialize Inputs
    rst = 1;
    start = 0;
    mode = 2'b00;
    
    // Reset the system
    #20;
    rst = 0;
    
    // Test case 1: Quick mode (00)
    #10;
    mode = 2'b00;
    start = 1;
    #10;
    start = 0;
    
    // Wait for full cycle
    #2000;
    
    // Check if returned to IDLE
    if (wash !== 0 || rinse !== 0 || spin !== 0) begin
        $display("Test 1 failed: Input(mode=%b), Output(wash=%b, rinse=%b, spin=%b), Expected(all 0)", 
                 mode, wash, rinse, spin);
        test_failed = 1;
    end
    
    // Test case 2: Standard mode (01)
    #20;
    mode = 2'b01;
    start = 1;
    #10;
    start = 0;
    
    // Wait for full cycle
    #4000;
    
    // Check if returned to IDLE
    if (wash !== 0 || rinse !== 0 || spin !== 0) begin
        $display("Test 2 failed: Input(mode=%b), Output(wash=%b, rinse=%b, spin=%b), Expected(all 0)", 
                 mode, wash, rinse, spin);
        test_failed = 1;
    end
    
    // Test case 3: Strong mode (10)
    #20;
    mode = 2'b10;
    start = 1;
    #10;
    start = 0;
    
    // Wait for full cycle
    #6000;
    
    // Check if returned to IDLE
    if (wash !== 0 || rinse !== 0 || spin !== 0) begin
        $display("Test 3 failed: Input(mode=%b), Output(wash=%b, rinse=%b, spin=%b), Expected(all 0)", 
                 mode, wash, rinse, spin);
        test_failed = 1;
    end
    
    // Test case 4: Invalid mode (11) - should default to standard
    #20;
    mode = 2'b11;
    start = 1;
    #10;
    start = 0;
    
    // Wait for full cycle
    #4000;
    
    // Check if returned to IDLE
    if (wash !== 0 || rinse !== 0 || spin !== 0) begin
        $display("Test 4 failed: Input(mode=%b), Output(wash=%b, rinse=%b, spin=%b), Expected(all 0)", 
                 mode, wash, rinse, spin);
        test_failed = 1;
    end
    
    // Test case 5: Reset during operation
    #20;
    mode = 2'b01;
    start = 1;
    #10;
    start = 0;
    
    // Wait a bit then reset
    #500;
    rst = 1;
    #10;
    rst = 0;
    
    // Check if reset properly
    if (wash !== 0 || rinse !== 0 || spin !== 0) begin
        $display("Test 5 failed: Input(mode=%b, rst pulsed), Output(wash=%b, rinse=%b, spin=%b), Expected(all 0)", 
                 mode, wash, rinse, spin);
        test_failed = 1;
    end
    
    if (test_failed) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    
    $finish;
end

// Monitor outputs
initial begin
    $monitor("Time = %0t: state = %b, wash = %b, rinse = %b, spin = %b", 
             $time, uut.current_state, wash, rinse, spin);
end

endmodule