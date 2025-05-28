`timescale 1ns/1ps

module tb_multicycle_multiplier_16bit;

    // Inputs
    reg         clk;
    reg         rst;
    reg         start;
    reg  [15:0] a;
    reg  [15:0] b;
    reg         error_flag; // Moved declaration here

    // Outputs
    wire [31:0] p;
    wire        done;

    // Instantiate the Unit Under Test (UUT)
    multicycle_multiplier_16bit uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .p(p),
        .done(done)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        start = 0;
        a = 0;
        b = 0;
        error_flag = 0; // Initialize here

        // Apply reset
        #10 rst = 0;
        #10;

        // Test Case 1: 5 * 7 = 35
        a = 16'd5;
        b = 16'd7;
        start = 1;
        #10 start = 0;
        wait(done);
        #10;
        if (p !== 32'd35) begin
            $display("Error: Test Case 1 failed");
            $display("Input: a = %d, b = %d", a, b);
            $display("Output: p = %d", p);
            $display("Expected: p = 35");
            error_flag = 1;
        end

        // Test Case 2: 0 * 1234 = 0
        a = 16'd0;
        b = 16'd1234;
        start = 1;
        #10 start = 0;
        wait(done);
        #10;
        if (p !== 32'd0) begin
            $display("Error: Test Case 2 failed");
            $display("Input: a = %d, b = %d", a, b);
            $display("Output: p = %d", p);
            $display("Expected: p = 0");
            error_flag = 1;
        end

        // Test Case 3: 65535 * 1 = 65535
        a = 16'hFFFF;
        b = 16'd1;
        start = 1;
        #10 start = 0;
        wait(done);
        #10;
        if (p !== 32'd65535) begin
            $display("Error: Test Case 3 failed");
            $display("Input: a = %d, b = %d", a, b);
            $display("Output: p = %d", p);
            $display("Expected: p = 65535");
            error_flag = 1;
        end

        // Test Case 4: 123 * 456 = 56088
        a = 16'd123;
        b = 16'd456;
        start = 1;
        #10 start = 0;
        wait(done);
        #10;
        if (p !== 32'd56088) begin
            $display("Error: Test Case 4 failed");
            $display("Input: a = %d, b = %d", a, b);
            $display("Output: p = %d", p);
            $display("Expected: p = 56088");
            error_flag = 1;
        end

        // Test Case 5: 32767 * 2 = 65534
        a = 16'd32767;
        b = 16'd2;
        start = 1;
        #10 start = 0;
        wait(done);
        #10;
        if (p !== 32'd65534) begin
            $display("Error: Test Case 5 failed");
            $display("Input: a = %d, b = %d", a, b);
            $display("Output: p = %d", p);
            $display("Expected: p = 65534");
            error_flag = 1;
        end

        // Test Case 6: Max value multiplication 65535 * 65535 = 4294836225
        a = 16'hFFFF;
        b = 16'hFFFF;
        start = 1;
        #10 start = 0;
        wait(done);
        #10;
        if (p !== 32'd4294836225) begin
            $display("Error: Test Case 6 failed");
            $display("Input: a = %d, b = %d", a, b);
            $display("Output: p = %d", p);
            $display("Expected: p = 4294836225");
            error_flag = 1;
        end

        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end

        $finish;
    end

endmodule