`timescale 1ns/1ps

module tb_async_fifo_8x8;

    // Inputs
    reg wclk;
    reg rclk;
    reg rst;
    reg wr;
    reg rd;
    reg [7:0] din;
    
    // Outputs
    wire [7:0] dout;
    wire empty;
    wire full;
    
    // Instantiate the Unit Under Test (UUT)
    async_fifo_8x8 uut (
        .wclk(wclk),
        .rclk(rclk),
        .rst(rst),
        .wr(wr),
        .rd(rd),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full)
    );
    
    // Clock generation
    initial begin
        wclk = 0;
        forever #5 wclk = ~wclk;
    end
    
    initial begin
        rclk = 0;
        forever #7 rclk = ~rclk;
    end
    
    // Test procedure
    integer error_count = 0;
    
    initial begin
        // Initialize Inputs
        rst = 1;
        wr = 0;
        rd = 0;
        din = 0;
        
        // Wait 100 ns for global reset to finish
        #100;
        rst = 0;
        
        // Test 1: Write until full
        for (integer i = 0; i < 8; i = i + 1) begin
            @(posedge wclk);
            wr = 1;
            din = $random;
            #1;
            if (full && i < 7) begin
                $display("Error: Test 1 - Full flag asserted too early at iteration %0d", i);
                $display("Input: din=%h, wr=%b", din, wr);
                $display("Output: full=%b", full);
                $display("Expected: full should be 0");
                error_count = error_count + 1;
            end
        end
        @(posedge wclk);
        wr = 0;
        if (!full) begin
            $display("Error: Test 1 - Full flag not asserted after 8 writes");
            $display("Input: din=%h, wr=%b", din, wr);
            $display("Output: full=%b", full);
            $display("Expected: full should be 1");
            error_count = error_count + 1;
        end
        
        // Test 2: Read until empty
        for (integer i = 0; i < 8; i = i + 1) begin
            @(posedge rclk);
            rd = 1;
            #1;
            if (empty && i < 7) begin
                $display("Error: Test 2 - Empty flag asserted too early at iteration %0d", i);
                $display("Input: rd=%b", rd);
                $display("Output: empty=%b", empty);
                $display("Expected: empty should be 0");
                error_count = error_count + 1;
            end
        end
        @(posedge rclk);
        rd = 0;
        if (!empty) begin
            $display("Error: Test 2 - Empty flag not asserted after 8 reads");
            $display("Input: rd=%b", rd);
            $display("Output: empty=%b", empty);
            $display("Expected: empty should be 1");
            error_count = error_count + 1;
        end
        
        // Test 3: Simultaneous read and write
        rst = 1;
        #100;
        rst = 0;
        
        fork
            begin // Writer
                for (integer i = 0; i < 16; i = i + 1) begin
                    @(posedge wclk);
                    wr = 1;
                    din = i;
                    #1;
                    if (full) begin
                        $display("Error: Test 3 - Unexpected full during simultaneous R/W");
                        $display("Input: din=%h, wr=%b", din, wr);
                        $display("Output: full=%b", full);
                        $display("Expected: full should be 0");
                        error_count = error_count + 1;
                    end
                end
                @(posedge wclk);
                wr = 0;
            end
            
            begin // Reader
                for (integer i = 0; i < 16; i = i + 1) begin
                    @(posedge rclk);
                    rd = 1;
                    #1;
                    if (empty) begin
                        $display("Error: Test 3 - Unexpected empty during simultaneous R/W");
                        $display("Input: rd=%b", rd);
                        $display("Output: empty=%b", empty);
                        $display("Expected: empty should be 0");
                        error_count = error_count + 1;
                    end
                end
                @(posedge rclk);
                rd = 0;
            end
        join
        
        // Test 4: Reset test
        @(posedge wclk);
        rst = 1;
        #1;
        if (!empty || full) begin
            $display("Error: Test 4 - Reset not working properly");
            $display("Input: rst=%b", rst);
            $display("Output: empty=%b, full=%b", empty, full);
            $display("Expected: empty=1, full=0");
            error_count = error_count + 1;
        end
        rst = 0;
        
        // Final result
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end
    
    // Monitor
    initial begin
        $monitor("Time = %0t: wr=%b rd=%b din=%h dout=%h empty=%b full=%b",
                 $time, wr, rd, din, dout, empty, full);
    end

endmodule