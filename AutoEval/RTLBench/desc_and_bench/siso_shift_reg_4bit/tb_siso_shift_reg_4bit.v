`timescale 1ns/1ps

module tb_siso_shift_reg_4bit;

    // Inputs
    reg clk;
    reg rst;
    reg si;
    
    // Outputs
    wire so;
    
    // Instantiate the Unit Under Test (UUT)
    siso_shift_reg_4bit uut (
        .clk(clk),
        .rst(rst),
        .si(si),
        .so(so)
    );
    
    // Clock generation
    always begin
        #5 clk = ~clk;
    end
    
    // Test variables
    reg [3:0] expected;
    integer i;
    integer error_count;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        si = 0;
        expected = 4'b0000;
        error_count = 0;
        
        // Apply reset
        #10 rst = 1;
        #10 rst = 0;
        
        // Test case 1: Shift in 4 bits (1010)
        expected = 4'b1010;
        for (i = 0; i < 4; i = i + 1) begin
            si = expected[3 - i];
            #10;
        end
        
        // Check output after 4 clocks
        #5;
        if (so !== expected[0]) begin
            $display("Error Test case 1: Input=%b, Output=%b, Expected=%b", expected, so, expected[0]);
            error_count = error_count + 1;
        end
        
        // Test case 2: Shift in 4 bits (1100) with reset in middle
        expected = 4'b1100;
        for (i = 0; i < 2; i = i + 1) begin
            si = expected[3 - i];
            #10;
        end
        
        // Apply reset
        #10 rst = 1;
        #10 rst = 0;
        
        // Continue shifting
        for (i = 2; i < 4; i = i + 1) begin
            si = expected[3 - i];
            #10;
        end
        
        // Check output (should be 0 due to reset)
        #5;
        if (so !== 1'b0) begin
            $display("Error Test case 2: Output=%b, Expected=0", so);
            error_count = error_count + 1;
        end
        
        // Test case 3: Continuous shifting
        for (i = 0; i < 8; i = i + 1) begin
            si = $random % 2;
            #10;
            if (i >= 3) begin
                // After 4 clocks, we can check output
                if (so !== expected[0]) begin
                    $display("Error Test case 3 at cycle %d: Input=%b, Output=%b, Expected=%b", i, {si, expected[3:1]}, so, expected[0]);
                    error_count = error_count + 1;
                end
            end
            expected = {si, expected[3:1]};
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