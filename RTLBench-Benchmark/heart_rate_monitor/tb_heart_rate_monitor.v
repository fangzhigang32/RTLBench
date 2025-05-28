`timescale 1ns/1ps

module tb_heart_rate_monitor;

// Inputs
reg clk;
reg rst;
reg pulse;

// Outputs
wire [7:0] bpm;
wire alert;

// Instantiate the Unit Under Test (UUT)
heart_rate_monitor uut (
    .clk(clk),
    .rst(rst),
    .pulse(pulse),
    .bpm(bpm),
    .alert(alert)
);

// Clock generation
initial begin
    clk = 0;
    forever #500 clk = ~clk; // 1Hz clock (1s period)
end

// Test stimulus
reg [3:0] error_count = 0;

initial begin
    // Initialize inputs
    rst = 1;
    pulse = 0;
    
    // Reset the system
    #1000;
    rst = 0;
    
    // Test case 1: Normal heart rate (60 BPM)
    repeat(60) begin
        #1000 pulse = 1;
        #100 pulse = 0;
    end
    
    #1000; // Wait for calculation
    
    // Check results
    if (bpm !== 60 || alert !== 0) begin
        $display("Error: Test case 1 failed - Input: 60 pulses/min");
        $display("       Expected: bpm=60, alert=0");
        $display("       Got:      bpm=%d, alert=%d", bpm, alert);
        error_count = error_count + 1;
    end
    
    // Test case 2: Low heart rate (30 BPM)
    repeat(30) begin
        #1000 pulse = 1;
        #100 pulse = 0;
    end
    
    #1000; // Wait for calculation
    
    // Check results
    if (bpm !== 30 || alert !== 1) begin
        $display("Error: Test case 2 failed - Input: 30 pulses/min");
        $display("       Expected: bpm=30, alert=1");
        $display("       Got:      bpm=%d, alert=%d", bpm, alert);
        error_count = error_count + 1;
    end
    
    // Test case 3: High heart rate (130 BPM)
    repeat(130) begin
        #461 pulse = 1;  // 130 pulses in 60 seconds (approx every 461ms)
        #100 pulse = 0;
    end
    
    #1000; // Wait for calculation
    
    // Check results
    if (bpm !== 130 || alert !== 1) begin
        $display("Error: Test case 3 failed - Input: 130 pulses/min");
        $display("       Expected: bpm=130, alert=1");
        $display("       Got:      bpm=%d, alert=%d", bpm, alert);
        error_count = error_count + 1;
    end
    
    // Test case 4: No pulse (0 BPM)
    // Just wait 60 seconds without pulses
    #60000;
    
    // Check results
    if (bpm !== 0 || alert !== 1) begin
        $display("Error: Test case 4 failed - Input: 0 pulses/min");
        $display("       Expected: bpm=0, alert=1");
        $display("       Got:      bpm=%d, alert=%d", bpm, alert);
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