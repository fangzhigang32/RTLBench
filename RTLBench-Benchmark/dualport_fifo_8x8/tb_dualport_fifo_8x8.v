`timescale 1ns/1ps

module tb_dualport_fifo_8x8;
    // Inputs
    reg clk;
    reg rst;
    reg wr;
    reg rd;
    reg [7:0] din;
    
    // Outputs
    wire [7:0] dout;
    wire empty;
    wire full;
    
    // Instantiate the Unit Under Test (UUT)
    dualport_fifo_8x8 uut (
        .clk(clk),
        .rst(rst),
        .wr(wr),
        .rd(rd),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Test variables
    integer i;
    reg [7:0] expected_data;
    integer error_count = 0;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        wr = 0;
        rd = 0;
        din = 0;
        
        // Wait for global reset
        #20;
        rst = 0;
        
        // Test Case 1: Check reset state
        if (!empty || full || dout !== 8'b0) begin
            $display("Error: Reset state failed. empty=%b, full=%b, dout=%h", empty, full, dout);
            error_count = error_count + 1;
        end
        
        // Test Case 2: Write until full
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            wr = 1;
            din = i + 8'h10;
            @(posedge clk);
            wr = 0;
        end
        
        if (!full || empty) begin
            $display("Error: FIFO should be full. empty=%b, full=%b", empty, full);
            error_count = error_count + 1;
        end
        
        // Test Case 3: Read until empty
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            rd = 1;
            expected_data = i + 8'h10;
            @(posedge clk);
            rd = 0;
            if (dout !== expected_data) begin
                $display("Error: Read data mismatch. Expected=%h, Got=%h", expected_data, dout);
                error_count = error_count + 1;
            end
        end
        
        if (!empty || full) begin
            $display("Error: FIFO should be empty. empty=%b, full=%b", empty, full);
            error_count = error_count + 1;
        end
        
        // Test Case 4: Simultaneous read and write
        @(posedge clk);
        wr = 1;
        rd = 1;
        din = 8'hAA;
        @(posedge clk);
        wr = 0;
        rd = 0;
        
        if (empty || full) begin
            $display("Error: FIFO should have 1 item. empty=%b, full=%b", empty, full);
            error_count = error_count + 1;
        end
        
        @(posedge clk);
        rd = 1;
        expected_data = 8'hAA;
        @(posedge clk);
        rd = 0;
        if (dout !== expected_data) begin
            $display("Error: Read data mismatch. Expected=%h, Got=%h", expected_data, dout);
            error_count = error_count + 1;
        end
        
        // Test Case 5: Write when full and read when empty
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            wr = 1;
            din = i + 8'h20;
            @(posedge clk);
            wr = 0;
        end
        
        @(posedge clk);
        wr = 1;
        din = 8'hFF;
        @(posedge clk);
        wr = 0;
        
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            rd = 1;
            expected_data = i + 8'h20;
            @(posedge clk);
            rd = 0;
            if (dout !== expected_data) begin
                $display("Error: Read data mismatch after write when full. Expected=%h, Got=%h", expected_data, dout);
                error_count = error_count + 1;
            end
        end
        
        @(posedge clk);
        rd = 1;
        @(posedge clk);
        rd = 0;
        
        // Test Case 6: Boundary simultaneous read/write
        for (i = 0; i < 7; i = i + 1) begin
            @(posedge clk);
            wr = 1;
            din = i + 8'h30;
            @(posedge clk);
            wr = 0;
        end
        
        @(posedge clk);
        wr = 1;
        rd = 1;
        din = 8'hBB;
        @(posedge clk);
        wr = 0;
        rd = 0;
        
        if (full) begin
            $display("Error: FIFO should not be full after simultaneous read/write. empty=%b, full=%b", empty, full);
            error_count = error_count + 1;
        end
        
        // Final summary
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end
endmodule