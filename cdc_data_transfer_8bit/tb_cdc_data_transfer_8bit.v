`timescale 1ns/1ps

module tb_cdc_data_transfer_8bit();

    // Clock and reset signals
    reg wclk;
    reg rclk;
    reg rst;
    
    // Inputs
    reg [7:0] din;
    reg wr;
    
    // Outputs
    wire [7:0] dout;
    wire rd_valid;
    
    // Instantiate the DUT
    cdc_data_transfer_8bit dut (
        .wclk(wclk),
        .rclk(rclk),
        .rst(rst),
        .din(din),
        .wr(wr),
        .dout(dout),
        .rd_valid(rd_valid)
    );
    
    // Clock generation
    initial begin
        wclk = 0;
        forever #5 wclk = ~wclk; // 100MHz write clock
    end
    
    initial begin
        rclk = 0;
        forever #10 rclk = ~rclk; // 50MHz read clock
    end
    
    // Task to apply reset
    task apply_reset;
        begin
            rst = 1;
            #20; // Hold reset for 20ns
            @(posedge wclk); // Align with wclk
            rst = 0;
            #10; // Wait for stabilization
        end
    endtask
    
    // Task to perform write operation
    task write_data(input [7:0] data);
        begin
            @(posedge wclk);
            din = data;
            wr = 1;
            @(posedge wclk);
            wr = 0;
        end
    endtask
    
    // Variable to track test results
    integer error_count = 0;
    
    // Task to check output
    task check_output(input [7:0] expected_data);
        integer start_time;
        begin
            start_time = $time;
            wait(rd_valid); // Wait for valid data
            @(posedge rclk);
            if (dout !== expected_data) begin
                $display("Error: Input=%h, Output=%h, Expected=%h", din, dout, expected_data);
                error_count = error_count + 1;
            end
            // Verify rd_valid pulse width (1 rclk cycle)
            @(posedge rclk);
            if (rd_valid) begin
                $display("Error: rd_valid should be low after 1 rclk cycle");
                error_count = error_count + 1;
            end
            // Check timing (2-3 rclk cycles)
            if (($time - start_time) > 60 || ($time - start_time) < 40) begin
                $display("Error: Output timing violation, time=%0d ns", $time - start_time);
                error_count = error_count + 1;
            end
        end
    endtask
    
    // Test stimulus
    initial begin
        // Initialize inputs
        rst = 1;
        din = 8'h00;
        wr = 0;
        
        // Test case 0: Reset behavior
        apply_reset();
        @(posedge rclk);
        if (rd_valid !== 0 || dout !== 8'h00) begin
            $display("Error: Reset failed. rd_valid=%b, dout=%h", rd_valid, dout);
            error_count = error_count + 1;
        end
        
        // Test case 1: Simple data transfer
        write_data(8'hA5);
        check_output(8'hA5);
        
        // Test case 2: Back-to-back transfers
        write_data(8'h5A);
        check_output(8'h5A);
        write_data(8'hC3);
        check_output(8'hC3);
        
        // Test case 3: Write during transfer
        @(posedge wclk);
        din = 8'hF0;
        wr = 1;
        #10;
        din = 8'h0F; // Change data during transfer
        @(posedge wclk);
        wr = 0;
        check_output(8'hF0);
        
        // Test case 4: Reset during transfer
        write_data(8'h77);
        #15; // Interrupt with reset
        apply_reset();
        @(posedge rclk);
        if (rd_valid !== 0 || dout !== 8'h00) begin
            $display("Error: Reset during transfer failed. rd_valid=%b, dout=%h", rd_valid, dout);
            error_count = error_count + 1;
        end
        
        // Test case 5: Slow write clock (simulate wclk slower than rclk)
        // Stop the original wclk and start a slower one
        #200;
        wclk = 0;
        forever #20 wclk = ~wclk; // 25MHz write clock
        
        #220;
        write_data(8'hAA);
        check_output(8'hAA);
        
        // End simulation
        #100;
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end
    
endmodule