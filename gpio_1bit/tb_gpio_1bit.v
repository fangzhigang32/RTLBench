`timescale 1ns/1ps

module tb_gpio_1bit();

    // Inputs
    reg clk;
    reg rst;
    reg dir;
    reg din;
    wire io;

    // Outputs
    wire dout;

    // Bidirectional
    reg io_drive;
    assign io = io_drive;

    // Instantiate the Unit Under Test (UUT)
    gpio_1bit uut (
        .clk(clk),
        .rst(rst),
        .dir(dir),
        .din(din),
        .dout(dout),
        .io(io)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test stimulus
    integer error_count = 0;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        dir = 0;
        din = 0;
        io_drive = 1'bz;

        // Wait for global reset
        #20;
        rst = 0;

        // Test case 1: Output mode (dir=1)
        dir = 1;
        din = 1;
        #10;
        if (io !== 1) begin
            $display("Error case 1: dir=%b, din=%b, io=%b, expected io=1", dir, din, io);
            error_count = error_count + 1;
        end

        // Test case 2: Input mode (dir=0)
        dir = 0;
        din = 0; // Should not affect output
        io_drive = 1;
        #10;
        if (dout !== 1) begin
            $display("Error case 2: dir=%b, io_drive=%b, dout=%b, expected dout=1", dir, io_drive, dout);
            error_count = error_count + 1;
        end

        // Test case 3: Reset test
        rst = 1;
        #10;
        if (io !== 1'bz || dout !== 0) begin
            $display("Error case 3: rst=%b, io=%b, dout=%b, expected io=z and dout=0", rst, io, dout);
            error_count = error_count + 1;
        end

        // Test case 4: Output mode change with reset release
        rst = 0;
        dir = 1;
        din = 0;
        #10;
        if (io !== 0) begin
            $display("Error case 4: dir=%b, din=%b, io=%b, expected io=0", dir, din, io);
            error_count = error_count + 1;
        end

        // Final check
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end

        $finish;
    end

endmodule