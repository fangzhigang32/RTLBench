`timescale 1ns/1ps

module tb_gpio_8bit;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] dir;
    reg [7:0] din;
    
    // Outputs
    wire [7:0] dout;
    
    // Bidirectional
    wire [7:0] io;
    reg [7:0] io_drive;

    reg error_flag;
    
    // Instantiate the Unit Under Test (UUT)
    gpio_8bit uut (
        .clk(clk),
        .rst(rst),
        .dir(dir),
        .din(din),
        .dout(dout),
        .io(io)
    );
    
    // Assign external drive to io pins
    assign io = io_drive;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize Inputs
        rst = 1;
        dir = 8'h00;
        din = 8'h00;
        io_drive = 8'h00;
        
        // Reset
        #20;
        rst = 0;
        
        // Error flag
        error_flag = 0;
        
        // Test 1: All inputs
        dir = 8'h00; // All inputs
        io_drive = 8'hAA;
        #20;
        if (dout !== 8'hAA) begin
            $display("Error: Test 1");
            $display("Input: dir=%h, io_drive=%h", dir, io_drive);
            $display("Output: dout=%h", dout);
            $display("Expected: dout=8'hAA");
            error_flag = 1;
        end
        
        // Test 2: All outputs
        dir = 8'hFF; // All outputs
        din = 8'h55;
        io_drive = 8'hZZ; // High-Z
        #20;
        if (io !== 8'h55) begin
            $display("Error: Test 2");
            $display("Input: dir=%h, din=%h, io_drive=%h", dir, din, io_drive);
            $display("Output: io=%h", io);
            $display("Expected: io=8'h55");
            error_flag = 1;
        end
        
        // Test 3: Mixed directions
        dir = 8'h0F; // Lower 4 bits output, upper 4 bits input
        din = 8'hF0;
        io_drive = 8'h0F;
        #20;
        if (dout[7:4] !== 4'h0 || io[3:0] !== 4'h0) begin
            $display("Error: Test 3");
            $display("Input: dir=%h, din=%h, io_drive=%h", dir, din, io_drive);
            $display("Output: dout[7:4]=%h, io[3:0]=%h", dout[7:4], io[3:0]);
            $display("Expected: dout[7:4]=4'h0, io[3:0]=4'h0");
            error_flag = 1;
        end
        
        // Test 4: Change direction and data
        dir = 8'hF0; // Upper 4 bits output, lower 4 bits input
        din = 8'h0F;
        io_drive = 8'hF0;
        #20;
        if (dout[3:0] !== 4'hF || io[7:4] !== 4'hF) begin
            $display("Error: Test 4");
            $display("Input: dir=%h, din=%h, io_drive=%h", dir, din, io_drive);
            $display("Output: dout[3:0]=%h, io[7:4]=%h", dout[3:0], io[7:4]);
            $display("Expected: dout[3:0]=4'hF, io[7:4]=4'hF");
            error_flag = 1;
        end
        
        // Test 5: Reset test
        rst = 1;
        #10;
        if (dout !== 8'h00 || io !== 8'hZZ) begin
            $display("Error: Test 5");
            $display("Input: rst=%h", rst);
            $display("Output: dout=%h, io=%h", dout, io);
            $display("Expected: dout=8'h00, io=8'hZZ");
            error_flag = 1;
        end
        
        // Final result
        if (error_flag) begin
            $display("Exist Function Error");
        end
        else begin
            $display("No Function Error");
        end
        
        $finish;
    end
    
endmodule