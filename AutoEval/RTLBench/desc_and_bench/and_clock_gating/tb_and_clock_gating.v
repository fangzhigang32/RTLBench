`timescale 1ns/1ps

module tb_and_clock_gating;

    // Inputs
    reg clk;
    reg en;

    // Output
    wire gclk;

    // Instantiate the Unit Under Test (UUT)
    and_clock_gating uut (
        .clk(clk),
        .en(en),
        .gclk(gclk)
    );

    // Clock generation: 100MHz clock (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus and checking
    integer error_count = 0;
    initial begin
        // Initialize inputs
        en = 0;
        #10;

        // Test case 1: Enable low (en = 0)
        en = 0;
        #10;
        if (gclk !== 0) begin
            $display("Error: Test case 1 failed - gclk should be 0 when en=0");
            $display("Input: en=%b", en);
            $display("Output: gclk=%b", gclk);
            $display("Expected: 0");
            error_count = error_count + 1;
        end

        // Test case 2: Enable high (en = 1)
        en = 1;
        #10;
        if (gclk !== clk) begin
            $display("Error: Test case 2 failed - gclk should follow clk when en=1");
            $display("Input: en=%b, clk=%b", en, clk);
            $display("Output: gclk=%b", gclk);
            $display("Expected: %b", clk);
            error_count = error_count + 1;
        end

        // Test case 3: Toggle enable (en: 0 -> 1)
        en = 0;
        #10;
        en = 1;
        #10;
        if (gclk !== clk) begin
            $display("Error: Test case 3 failed - gclk should follow clk when en=1");
            $display("Input: en=%b, clk=%b", en, clk);
            $display("Output: gclk=%b", gclk);
            $display("Expected: %b", clk);
            error_count = error_count + 1;
        end

        // Test case 4: Toggle enable (en: 1 -> 0)
        en = 1;
        #10;
        en = 0;
        #10;
        if (gclk !== 0) begin
            $display("Error: Test case 4 failed - gclk should be 0 when en=0");
            $display("Input: en=%b", en);
            $display("Output: gclk=%b", gclk);
            $display("Expected: 0");
            error_count = error_count + 1;
        end

        // Test case 5: Timing check (en changes near clk edge)
        en = 1;
        #4.9; // Change en 0.1ns before clk rising edge
        en = 0;
        #0.2; // Check for glitches
        if (gclk !== 0) begin
            $display("Error: Test case 5 failed - glitch detected in gclk");
            $display("Input: en=%b", en);
            $display("Output: gclk=%b", gclk);
            $display("Expected: 0");
            error_count = error_count + 1;
        end

        // Final report
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end

    // Continuous monitoring: Ensure gclk = clk & en at all times
    always @(clk or en or gclk) begin
        #1; // Small delay to avoid race conditions
        if (gclk !== (clk & en)) begin
            $display("Error: gclk != clk & en at time %t", $time);
            $display("Input: en=%b, clk=%b", en, clk);
            $display("Output: gclk=%b", gclk);
            $display("Expected: %b", (clk & en));
            error_count = error_count + 1;
        end
    end

endmodule