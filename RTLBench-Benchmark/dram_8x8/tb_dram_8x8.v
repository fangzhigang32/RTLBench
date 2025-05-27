`timescale 1ns/1ps

module tb_dram_8x8;

    // Parameters
    parameter CLK_PERIOD = 10;
    parameter HALF_CLK_PERIOD = CLK_PERIOD / 2;

    // Inputs
    reg clk;
    reg we;
    reg re;
    reg [2:0] addr;
    reg [7:0] din;

    // Outputs
    wire [7:0] dout;

    // Instantiate the Unit Under Test (UUT)
    dram_8x8 uut (
        .clk(clk),
        .we(we),
        .re(re),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    initial clk = 0;
    always #(HALF_CLK_PERIOD) clk = ~clk;

    // Test variables
    reg [7:0] expected_data;
    integer error_count;

    initial begin
        // Initialize inputs
        clk = 0;
        we = 0;
        re = 0;
        addr = 0;
        din = 0;
        error_count = 0;

        // Wait for initial stabilization
        #(CLK_PERIOD);

        // Test 0: Verify memory initialized to zero
        for (integer i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            we = 0;
            re = 1;
            addr = i;
            expected_data = 8'h00;
            #(HALF_CLK_PERIOD);
            if (dout !== expected_data) begin
                $display("Error at addr %d: Expected %h, Got %h (initialization check)", i, expected_data, dout);
                error_count = error_count + 1;
            end
        end
        re = 0;

        // Test 1: Write data to all addresses
        for (integer i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            we = 1;
            re = 0;
            addr = i;
            din = 8'hA0 + i;
            #(CLK_PERIOD);
        end
        we = 0;

        // Test 2: Read back and verify data
        for (integer i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            we = 0;
            re = 1;
            addr = i;
            expected_data = 8'hA0 + i;
            #(HALF_CLK_PERIOD);
            if (dout !== expected_data) begin
                $display("Error at addr %d: Expected %h, Got %h", i, expected_data, dout);
                error_count = error_count + 1;
            end
        end
        re = 0;

        // Test 3: Verify tri-state when not reading
        @(posedge clk);
        #(HALF_CLK_PERIOD);
        if (dout !== 8'bz) begin
            $display("Error: Output not in tri-state when re=0");
            error_count = error_count + 1;
        end

        // Test 4: Simultaneous read/write (read should get old data)
        @(posedge clk);
        we = 1;
        re = 1;
        addr = 0;
        din = 8'hFF;
        expected_data = 8'hA0;
        #(HALF_CLK_PERIOD);
        if (dout !== expected_data) begin
            $display("Error during simultaneous R/W: Expected %h, Got %h", expected_data, dout);
            error_count = error_count + 1;
        end

        // Test 5: Verify write took effect
        @(posedge clk);
        we = 0;
        re = 1;
        addr = 0;
        expected_data = 8'hFF;
        #(HALF_CLK_PERIOD);
        if (dout !== expected_data) begin
            $display("Error verifying write: Expected %h, Got %h", expected_data, dout);
            error_count = error_count + 1;
        end

        // Test 6: Continuous write to same address
        @(posedge clk);
        we = 1;
        re = 0;
        addr = 1;
        din = 8'h55;
        #(CLK_PERIOD);
        we = 1;
        din = 8'hAA;
        #(CLK_PERIOD);
        we = 0;
        re = 1;
        expected_data = 8'hAA;
        #(HALF_CLK_PERIOD);
        if (dout !== expected_data) begin
            $display("Error in continuous write: Expected %h, Got %h", expected_data, dout);
            error_count = error_count + 1;
        end

        // Test 7: Rapid read/write switching
        @(posedge clk);
        we = 1;
        re = 0;
        addr = 2;
        din = 8'h33;
        #(CLK_PERIOD);
        we = 0;
        re = 1;
        expected_data = 8'h33;
        #(HALF_CLK_PERIOD);
        if (dout !== expected_data) begin
            $display("Error in rapid R/W switching: Expected %h, Got %h", expected_data, dout);
            error_count = error_count + 1;
        end

        // Summary
        #(CLK_PERIOD);
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end

        $finish;
    end

endmodule