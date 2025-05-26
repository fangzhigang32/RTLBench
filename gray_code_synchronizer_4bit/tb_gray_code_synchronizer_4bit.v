`timescale 1ns/1ps

module tb_gray_code_synchronizer_4bit();

    // Clock and reset signals
    reg sclk;
    reg dclk;
    reg rst;
    
    // Input stimulus
    reg [3:0] gin;
    
    // Output monitoring
    wire [3:0] gout;
    
    // Expected output
    reg [3:0] expected_gout;
    
    // Error tracking
    integer error_count = 0;
    
    // Clock generation
    always #5 sclk = ~sclk;  // 100 MHz source clock
    always #7 dclk = ~dclk;  // ~71.4 MHz destination clock
    
    // Instantiate DUT
    gray_code_synchronizer_4bit dut (
        .sclk(sclk),
        .dclk(dclk),
        .rst(rst),
        .gin(gin),
        .gout(gout)
    );
    
    // Test sequence
    initial begin
        // Initialize signals
        sclk = 0;
        dclk = 0;
        rst = 1;
        gin = 4'b0000;
        expected_gout = 4'b0000;
        
        // Reset release
        #20 rst = 0;
        
        // Test case 1: Simple gray code transition
        @(posedge sclk) gin = 4'b0001;
        expected_gout = 4'b0001;
        #50; // Allow time for synchronization
        if (gout !== expected_gout) begin
            $display("Error: Case 1 - Input: %b, Output: %b, Expected: %b", gin, gout, expected_gout);
            error_count = error_count + 1;
        end
        
        // Test case 2: Full gray code sequence
        @(posedge sclk) gin = 4'b0011;
        expected_gout = 4'b0011;
        #50;
        if (gout !== expected_gout) begin
            $display("Error: Case 2 - Input: %b, Output: %b, Expected: %b", gin, gout, expected_gout);
            error_count = error_count + 1;
        end
        
        @(posedge sclk) gin = 4'b0010;
        expected_gout = 4'b0010;
        #50;
        if (gout !== expected_gout) begin
            $display("Error: Case 3 - Input: %b, Output: %b, Expected: %b", gin, gout, expected_gout);
            error_count = error_count + 1;
        end
        
        @(posedge sclk) gin = 4'b0110;
        expected_gout = 4'b0110;
        #50;
        if (gout !== expected_gout) begin
            $display("Error: Case 4 - Input: %b, Output: %b, Expected: %b", gin, gout, expected_gout);
            error_count = error_count + 1;
        end
        
        // Test case 5: Reset test
        @(posedge sclk) rst = 1;
        expected_gout = 4'b0000;
        #20;
        if (gout !== expected_gout) begin
            $display("Error: Case 5 (Reset) - Input: %b, Output: %b, Expected: %b", gin, gout, expected_gout);
            error_count = error_count + 1;
        end
        
        // Final result
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        
        // End simulation
        $finish;
    end
    
    // Monitor output changes
    always @(gout) begin
        $display("Time %t: Output changed to %b", $time, gout);
    end

endmodule