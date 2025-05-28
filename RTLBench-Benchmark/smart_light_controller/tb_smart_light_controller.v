`timescale 1ns/1ps

module tb_smart_light_controller;
    // Inputs
    reg clk;
    reg rst;
    reg switch;
    reg light_sensor;
    
    // Outputs
    wire light_on;
    wire [2:0] level;
    
    // Instantiate the Unit Under Test (UUT)
    smart_light_controller uut (
        .clk(clk),
        .rst(rst),
        .switch(switch),
        .light_sensor(light_sensor),
        .light_on(light_on),
        .level(level)
    );
    
    integer error_count;

    // Clock generation
    always begin
        #5 clk = ~clk;
    end
    
    // Test procedure
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        switch = 0;
        light_sensor = 0;
        
        // Track test results
        error_count = 0;
        
        // Apply reset
        #10 rst = 0;
        
        // Test case 1: Reset condition
        #1; // Add small delay to ensure sampling after clock edge
        if (light_on !== 1'b0 || level !== 3'b000) begin
            $display("Error: Test case 1 failed");
            $display("Inputs: rst=%b, switch=%b, light_sensor=%b", rst, switch, light_sensor);
            $display("Output: light_on=%b, level=%b", light_on, level);
            $display("Expected: light_on=0, level=000");
            error_count = error_count + 1;
        end
        
        // Test case 2: Manual mode (switch on)
        #10 switch = 1;
        #10;
        if (light_on !== 1'b1 || level !== 3'b111) begin
            $display("Error: Test case 2 failed");
            $display("Inputs: rst=%b, switch=%b, light_sensor=%b", rst, switch, light_sensor);
            $display("Output: light_on=%b, level=%b", light_on, level);
            $display("Expected: light_on=1, level=111");
            error_count = error_count + 1;
        end
        
        // Test case 3: Auto mode (light sensor on)
        #10 switch = 0;
        light_sensor = 1;
        #10;
        if (light_on !== 1'b1 || level !== 3'b001) begin
            $display("Error: Test case 3 failed");
            $display("Inputs: rst=%b, switch=%b, light_sensor=%b", rst, switch, light_sensor);
            $display("Output: light_on=%b, level=%b", light_on, level);
            $display("Expected: light_on=1, level=001");
            error_count = error_count + 1;
        end
        
        // Test case 4: Auto mode level increment
        #10;
        if (light_on !== 1'b1 || level !== 3'b010) begin
            $display("Error: Test case 4 failed");
            $display("Inputs: rst=%b, switch=%b, light_sensor=%b", rst, switch, light_sensor);
            $display("Output: light_on=%b, level=%b", light_on, level);
            $display("Expected: light_on=1, level=010");
            error_count = error_count + 1;
        end
        
        // Test case 5: Auto mode priority over manual
        #10 switch = 1;
        #10;
        if (light_on !== 1'b1 || level !== 3'b011) begin
            $display("Error: Test case 5 failed");
            $display("Inputs: rst=%b, switch=%b, light_sensor=%b", rst, switch, light_sensor);
            $display("Output: light_on=%b, level=%b", light_on, level);
            $display("Expected: light_on=1, level=011");
            error_count = error_count + 1;
        end
        
        // Test case 6: Return to off state
        #10 switch = 0;
        light_sensor = 0;
        #10;
        if (light_on !== 1'b0 || level !== 3'b000) begin
            $display("Error: Test case 6 failed");
            $display("Inputs: rst=%b, switch=%b, light_sensor=%b", rst, switch, light_sensor);
            $display("Output: light_on=%b, level=%b", light_on, level);
            $display("Expected: light_on=0, level=000");
            error_count = error_count + 1;
        end
        
        // Test case 7: Auto mode wrap-around
        light_sensor = 1;
        repeat(7) #10;
        if (light_on !== 1'b1 || level !== 3'b000) begin
            $display("Error: Test case 7 failed");
            $display("Inputs: rst=%b, switch=%b, light_sensor=%b", rst, switch, light_sensor);
            $display("Output: light_on=%b, level=%b", light_on, level);
            $display("Expected: light_on=1, level=000");
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