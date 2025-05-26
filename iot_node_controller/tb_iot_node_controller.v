`timescale 1ns/1ps

module tb_iot_node_controller();

// Inputs
reg clk;
reg rst;
reg sensor;
reg tx_en;

// Outputs
wire tx;
wire sleep;

// Instantiate the Unit Under Test (UUT)
iot_node_controller uut (
    .clk(clk),
    .rst(rst),
    .sensor(sensor),
    .tx_en(tx_en),
    .tx(tx),
    .sleep(sleep)
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
    sensor = 0;
    tx_en = 0;
    
    // Reset the system
    #10;
    rst = 0;
    
    // Test case 1: IDLE state
    #10;
    if (tx !== 0 || sleep !== 0) begin
        $display("Error: Test case 1 - Inputs: rst=%b, sensor=%b, tx_en=%b", rst, sensor, tx_en);
        $display("       Output: tx=%b, sleep=%b, Expected: tx=0, sleep=0", tx, sleep);
        error_count = error_count + 1;
    end
    
    // Test case 2: Transition to COLLECT state
    sensor = 1;
    #10;
    if (tx !== 0 || sleep !== 0) begin
        $display("Error: Test case 2 - Inputs: rst=%b, sensor=%b, tx_en=%b", rst, sensor, tx_en);
        $display("       Output: tx=%b, sleep=%b, Expected: tx=0, sleep=0", tx, sleep);
        error_count = error_count + 1;
    end
    
    // Test case 3: Transition to TRANSMIT state
    tx_en = 1;
    #10;
    if (tx !== 1 || sleep !== 0) begin
        $display("Error: Test case 3 - Inputs: rst=%b, sensor=%b, tx_en=%b", rst, sensor, tx_en);
        $display("       Output: tx=%b, sleep=%b, Expected: tx=1, sleep=0", tx, sleep);
        error_count = error_count + 1;
    end
    
    // Test case 4: Transition to SLEEP state
    tx_en = 0;
    #10;
    if (tx !== 0 || sleep !== 1) begin
        $display("Error: Test case 4 - Inputs: rst=%b, sensor=%b, tx_en=%b", rst, sensor, tx_en);
        $display("       Output: tx=%b, sleep=%b, Expected: tx=0, sleep=1", tx, sleep);
        error_count = error_count + 1;
    end
    
    // Test case 5: Stay in SLEEP state
    sensor = 0;
    #10;
    if (tx !== 0 || sleep !== 1) begin
        $display("Error: Test case 5 - Inputs: rst=%b, sensor=%b, tx_en=%b", rst, sensor, tx_en);
        $display("       Output: tx=%b, sleep=%b, Expected: tx=0, sleep=1", tx, sleep);
        error_count = error_count + 1;
    end
    
    // Test case 6: Wake up from SLEEP to COLLECT
    sensor = 1;
    #10;
    if (tx !== 0 || sleep !== 0) begin
        $display("Error: Test case 6 - Inputs: rst=%b, sensor=%b, tx_en=%b", rst, sensor, tx_en);
        $display("       Output: tx=%b, sleep=%b, Expected: tx=0, sleep=0", tx, sleep);
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