`timescale 1ns/1ps

module tb_clock_gating;

    // Inputs
    reg clk;
    reg en;
    reg async_en;

    // Outputs
    wire gclk;

    // Test status
    integer test_passed = 0;
    integer test_failed = 0;

    // Instantiate the Unit Under Test (UUT)
    clock_gating uut (
        .clk(clk),
        .en(en),
        .gclk(gclk)
    );

    // Clock generation (100MHz, 10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Asynchronous enable signal generation
    initial begin
        async_en = 0;
        forever #7 async_en = $random;
    end

    // Glitch detection
    reg prev_gclk;
    always @(gclk) begin
        prev_gclk <= gclk;
        if (clk === 1'b1 && prev_gclk !== gclk && en === 1'b1) begin
            $display("Error: Glitch detected on gclk at time %t", $time);
            test_failed = test_failed + 1;
        end
    end

    // Stimulus and checking
    initial begin
        // Initialize inputs
        en = 0;
        #10;

        // Test case 1: Enable low - gclk should stay low
        en = 0;
        repeat (4) begin
            @(negedge clk);
            if (gclk !== 1'b0) begin
                $display("Error: Test case 1 failed at time %t - gclk=%b, expected=0", $time, gclk);
                test_failed = test_failed + 1;
            end
        end
        if (test_failed == 0) test_passed = test_passed + 1;

        // Test case 2: Enable high - gclk should follow clk
        en = 1;
        @(negedge clk);
        repeat (4) begin
            @(posedge clk);
            if (gclk !== 1'b1) begin
                $display("Error: Test case 2 failed at time %t - gclk=%b, clk=%b, expected gclk=1", $time, gclk, clk);
                test_failed = test_failed + 1;
            end
            @(negedge clk);
            if (gclk !== 1'b0) begin
                $display("Error: Test case 2 failed at time %t - gclk=%b, clk=%b, expected gclk=0", $time, gclk, clk);
                test_failed = test_failed + 1;
            end
        end
        if (test_failed == 0) test_passed = test_passed + 1;

        // Test case 3: Enable toggling during high clock
        @(posedge clk);
        en = 0;
        #1;
        en = 1;
        @(negedge clk);
        if (gclk !== 1'b0) begin
            $display("Error: Test case 3 failed at time %t - gclk=%b, expected=0 (enable change during high clock)", $time, gclk);
            test_failed = test_failed + 1;
        end
        @(posedge clk);
        if (gclk !== 1'b1) begin
            $display("Error: Test case 3 follow-up failed at time %t - gclk=%b, clk=%b, expected gclk=clk", $time, gclk, clk);
            test_failed = test_failed + 1;
        end
        if (test_failed == 0) test_passed = test_passed + 1;

        // Test case 4: Enable toggling during low clock
        @(negedge clk);
        en = 0;
        #1;
        en = 1;
        @(posedge clk);
        if (gclk !== 1'b1) begin
            $display("Error: Test case 4 failed at time %t - gclk=%b, clk=%b, expected gclk=clk", $time, gclk, clk);
            test_failed = test_failed + 1;
        end
        if (test_failed == 0) test_passed = test_passed + 1;

        // Test case 5: Setup/hold time violation test
        @(negedge clk);
        #4.9;
        en = 0;
        @(negedge clk);
        if (gclk !== 1'b0) begin
            $display("Error: Test case 5 failed at time %t - gclk=%b, expected=0 (setup violation)", $time, gclk);
            test_failed = test_failed + 1;
        end
        if (test_failed == 0) test_passed = test_passed + 1;

        // Test case 6: Asynchronous enable
        en = async_en;
        repeat (10) begin
            @(negedge clk);
            if (gclk !== (clk & en)) begin
                $display("Error: Test case 6 failed at time %t - gclk=%b, clk=%b, en=%b, expected gclk=clk&en", $time, gclk, clk, en);
                test_failed = test_failed + 1;
            end
        end
        if (test_failed == 0) test_passed = test_passed + 1;

        // Test case 7: Different clock frequency (50MHz)
        force clk = 0;
        #10;
        release clk;
        
        // Create a new clock with 50MHz frequency in a separate process
        begin
            clk = 0;
            forever #10 clk = ~clk;
        end
        
        en = 1;
        @(negedge clk);
        repeat (4) begin
            @(posedge clk);
            if (gclk !== 1'b1) begin
                $display("Error: Test case 7 failed at time %t - gclk=%b, clk=%b, expected gclk=1", $time, gclk, clk);
                test_failed = test_failed + 1;
            end
        end
        if (test_failed == 0) test_passed = test_passed + 1;

        // Final output
        if (test_failed == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end

    // Simulation timeout
    initial begin
        #1000;
        $display("Simulation timeout");
        $finish;
    end

endmodule