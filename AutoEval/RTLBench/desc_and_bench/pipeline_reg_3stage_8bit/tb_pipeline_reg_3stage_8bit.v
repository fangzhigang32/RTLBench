`timescale 1ns/1ps

module tb_pipeline_reg_3stage_8bit;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] din;

    // Output
    wire [7:0] dout;

    // Instantiate the Unit Under Test (UUT)
    pipeline_reg_3stage_8bit uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus and checking
    reg error_flag = 0;
    initial begin
        // Initialize inputs
        rst = 1;
        din = 8'h00;
        
        // Apply reset
        #10;
        rst = 0;
        
        // Test case 1: Single data input
        din = 8'hAA;
        #10;
        din = 8'h00;
        #30; // Wait for 3 clock cycles (3-stage pipeline)
        if (dout !== 8'hAA) begin
            $display("Error: Test case 1 failed - Input: 8'hAA, Output: %h, Expected: 8'hAA", dout);
            error_flag = 1;
        end
        
        // Test case 2: Multiple data inputs
        din = 8'h55;
        #10;
        din = 8'hF0;
        #10;
        din = 8'h0F;
        #10;
        din = 8'h00;
        #30;
        if (dout !== 8'h0F) begin
            $display("Error: Test case 2 failed - Last Input: 8'h0F, Output: %h, Expected: 8'h0F", dout);
            error_flag = 1;
        end
        
        // Test case 3: Reset during operation
        din = 8'hFF;
        #10;
        din = 8'h11;
        #10;
        rst = 1;
        #10;
        rst = 0;
        #10; // Added delay to allow reset to propagate
        if (dout !== 8'h00) begin
            $display("Error: Test case 3 failed - After Reset, Output: %h, Expected: 8'h00", dout);
            error_flag = 1;
        end
        
        // Final check
        #20;
        if (error_flag == 0) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end
        
        $finish;
    end

endmodule