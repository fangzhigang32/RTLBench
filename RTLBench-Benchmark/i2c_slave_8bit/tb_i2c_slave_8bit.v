`timescale 1ns/1ps

module tb_i2c_slave_8bit();

// Testbench signals
reg clk;
reg rst;
wire sda;
reg sda_drv;
reg scl;
wire [7:0] dout;

// Parameters
parameter CLK_PERIOD = 10;  // 100 MHz
parameter I2C_PERIOD = 100; // 100 kHz
parameter SLAVE_ADDR = 7'h50;

// Instantiate the DUT
i2c_slave_8bit dut (
    .clk(clk),
    .rst(rst),
    .sda(sda),
    .scl(scl),
    .dout(dout)
);

// SDA line control
assign sda = sda_drv ? 1'b0 : 1'bz;

// Clock generation
initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

// Test stimulus
integer error_count = 0;
initial begin
    // Initialize
    rst = 1'b1;
    scl = 1'b1;
    sda_drv = 1'b1;
    #100;
    
    // Release reset
    rst = 1'b0;
    #100;
    
    // Test 1: Send correct address + write + data
    i2c_start();
    i2c_send_byte({SLAVE_ADDR, 1'b0}); // Write operation
    i2c_send_byte(8'hA5);
    i2c_stop();
    
    #100;
    if (dout !== 8'hA5) begin
        $display("Test 1 failed: Input=8'hA5, Output=%h, Expected=8'hA5", dout);
        error_count = error_count + 1;
    end
    
    // Test 2: Send wrong address
    i2c_start();
    i2c_send_byte({7'h51, 1'b0}); // Wrong address
    i2c_stop();
    
    #100;
    if (dout !== 8'hA5) begin
        $display("Test 2 failed: Expected no change (8'hA5), Output=%h", dout);
        error_count = error_count + 1;
    end
    
    // Test 3: Send correct address + write + multiple data
    i2c_start();
    i2c_send_byte({SLAVE_ADDR, 1'b0}); // Write operation
    i2c_send_byte(8'h5A);
    i2c_send_byte(8'hC3);
    i2c_stop();
    
    #100;
    if (dout !== 8'hC3) begin
        $display("Test 3 failed: Input=8'hC3, Output=%h, Expected=8'hC3", dout);
        error_count = error_count + 1;
    end
    
    // Test 4: Start-stop without data
    i2c_start();
    i2c_stop();
    
    #100;
    if (dout !== 8'hC3) begin
        $display("Test 4 failed: Expected no change (8'hC3), Output=%h", dout);
        error_count = error_count + 1;
    end
    
    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end
    
    $finish;
end

// I2C task: Generate start condition
task i2c_start;
    begin
        sda_drv = 1'b1;
        scl = 1'b1;
        #(I2C_PERIOD/2);
        sda_drv = 1'b0;
        #(I2C_PERIOD/2);
        scl = 1'b0;
    end
endtask

// I2C task: Generate stop condition
task i2c_stop;
    begin
        sda_drv = 1'b0;
        scl = 1'b0;
        #(I2C_PERIOD/2);
        scl = 1'b1;
        #(I2C_PERIOD/2);
        sda_drv = 1'b1;
        #(I2C_PERIOD/2);
    end
endtask

// I2C task: Send one byte
task i2c_send_byte;
    input [7:0] data;
    integer i;
    begin
        for (i = 7; i >= 0; i = i - 1) begin
            sda_drv = data[i];
            #(I2C_PERIOD/2);
            scl = 1'b1;
            #(I2C_PERIOD);
            scl = 1'b0;
            #(I2C_PERIOD/2);
        end
        
        // Release SDA for ACK
        sda_drv = 1'b1;
        #(I2C_PERIOD/2);
        scl = 1'b1;
        #(I2C_PERIOD);
        scl = 1'b0;
        #(I2C_PERIOD/2);
    end
endtask

endmodule