`timescale 1ns/1ps

module tb_async_reset_sync_release;

    // Inputs
    reg clk;
    reg async_rst;

    // Outputs
    wire sync_rst;

    // Instantiate the Unit Under Test (UUT)
    async_reset_sync_release uut (
        .clk(clk),
        .async_rst(async_rst),
        .sync_rst(sync_rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    reg test_failed = 0;

    // Task to check sync_rst at rising edge of clk
    task check_sync_rst;
        input expected_value;
        begin
            @(posedge clk); // Wait for rising edge
            #1; // Small delay to ensure signal stability
            if (sync_rst !== expected_value) begin
                $display("Error: sync_rst should be %b, got %b (Time=%0t, async_rst=%b)", 
                         expected_value, sync_rst, $time, async_rst);
                test_failed = 1;
            end
        end
    endtask

    // Test stimulus and checking
    initial begin
        // Initialize inputs
        async_rst = 0;

        // Test case 1: Assert async reset and check immediate sync_rst
        #10 async_rst = 1;
        #1 if (sync_rst !== 1'b1) begin
            $display("Error: sync_rst should be 1 after async reset assertion (Time=%0t)", $time);
            test_failed = 1;
        end

        // Test case 2: Deassert async reset and check synchronization
        #10 async_rst = 0;
        check_sync_rst(1'b1); // Should remain 1 for first clock
        check_sync_rst(1'b1); // Should remain 1 for second clock
        check_sync_rst(1'b0); // Should be 0 after two clocks

        // Test case 3: Short pulse async reset
        #20 async_rst = 1;
        #3 async_rst = 0; // Short pulse (less than one clock cycle)
        check_sync_rst(1'b1); // Should remain 1
        check_sync_rst(1'b1); // Should remain 1
        check_sync_rst(1'b0); // Should be 0 after two clocks

        // Test case 4: Async reset near clock edge
        #20;
        @(negedge clk); // Align with falling edge
        #1 async_rst = 1; // Assert just after falling edge
        #1 if (sync_rst !== 1'b1) begin
            $display("Error: sync_rst should be 1 after async reset near clock edge (Time=%0t)", $time);
            test_failed = 1;
        end
        #5 async_rst = 0;
        check_sync_rst(1'b1); // Should remain 1
        check_sync_rst(1'b1); // Should remain 1
        check_sync_rst(1'b0); // Should be 0 after two clocks

        // Test case 5: Random async reset assertion
        #100 async_rst = 1;
        #10 if (sync_rst !== 1'b1) begin
            $display("Error: sync_rst should be 1 after random async reset assertion (Time=%0t)", $time);
            test_failed = 1;
        end
        #10 async_rst = 0;
        check_sync_rst(1'b1); // Should remain 1
        check_sync_rst(1'b1); // Should remain 1
        check_sync_rst(1'b0); // Should be 0 after two clocks

        // Final result
        if (test_failed) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        $finish;
    end

    // Simulation time limit
    initial begin
        #1000 $finish;
    end

endmodule