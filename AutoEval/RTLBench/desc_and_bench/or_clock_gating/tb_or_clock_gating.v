`timescale 1ns/1ps

module tb_or_clock_gating;

    // Inputs
    reg clk;
    reg en;

    // Outputs
    wire gclk;

    // Instantiate the Unit Under Test (UUT)
    or_clock_gating uut (
        .clk(clk),
        .en(en),
        .gclk(gclk)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Stimulus and checking
    reg error_flag = 0;
    initial begin
        // Initialize inputs
        en = 0;
        #10;

        // Test case 1: en=0
        if (gclk !== clk) begin
            $display("Error: Case en=0 - Input: en=%b, Output: gclk=%b, Expected: gclk=%b", en, gclk, clk);
            error_flag = 1;
        end

        // Test case 2: en=1
        en = 1;
        #10;
        if (gclk !== 1'b1) begin
            $display("Error: Case en=1 - Input: en=%b, Output: gclk=%b, Expected: gclk=1", en, gclk);
            error_flag = 1;
        end

        // Test case 3: en toggling
        en = 0;
        #10;
        en = 1;
        #5;
        if (gclk !== 1'b1) begin
            $display("Error: Case en toggling - Input: en=%b, Output: gclk=%b, Expected: gclk=1", en, gclk);
            error_flag = 1;
        end

        // Final result
        if (error_flag) begin
            $display("Exist Function Error");
        end
        else begin
            $display("No Function Error");
        end

        // Finish simulation
        #10;
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t: clk=%b, en=%b, gclk=%b", $time, clk, en, gclk);
    end

endmodule