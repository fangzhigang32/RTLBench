`timescale 1ns/1ps

module tb_ddc_8bit();

// Inputs
reg         clk;
reg         rst;
reg  [7:0]  x;

// Outputs
wire [7:0]  i;
wire [7:0]  q;

// Error counter
integer     error_count;

// Instantiate the Unit Under Test (UUT)
ddc_8bit uut (
    .clk(clk),
    .rst(rst),
    .x(x),
    .i(i),
    .q(q)
);

// Clock generation (10ns period, 100MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize inputs and error counter
    rst = 1;
    x = 0;
    error_count = 0;
    
    // Wait for global reset
    #20;
    rst = 0;
    
    // Test case 1: Input = 127 (max positive)
    x = 8'd127;
    @(posedge clk);
    #1;
    if (i !== ((127 * 90) >>> 7) || q !== ((127 * 90) >>> 7)) begin
        $display("Error case 1: Input=127, Expected i=%0d, q=%0d, Got i=%0d, q=%0d", 
                ((127 * 90) >>> 7), ((127 * 90) >>> 7), i, q);
        error_count = error_count + 1;
    end
    
    // Test case 2: Input = -128 (max negative)
    x = -8'd128;
    @(posedge clk);
    #1;
    if (i !== ((-128 * 90) >>> 7) || q !== ((-128 * 90) >>> 7)) begin
        $display("Error case 2: Input=-128, Expected i=%0d, q=%0d, Got i=%0d, q=%0d", 
                ((-128 * 90) >>> 7), ((-128 * 90) >>> 7), i, q);
        error_count = error_count + 1;
    end
    
    // Test case 3: Input = 64 (mid-range positive)
    x = 8'd64;
    @(posedge clk);
    #1;
    if (i !== ((64 * 90) >>> 7) || q !== ((64 * 90) >>> 7)) begin
        $display("Error case 3: Input=64, Expected i=%0d, q=%0d, Got i=%0d, q=%0d", 
                ((64 * 90) >>> 7), ((64 * 90) >>> 7), i, q);
        error_count = error_count + 1;
    end
    
    // Test case 4: Input = 0
    x = 8'd0;
    @(posedge clk);
    #1;
    if (i !== 0 || q !== 0) begin
        $display("Error case 4: Input=0, Expected i=0, q=0, Got i=%0d, q=%0d", i, q);
        error_count = error_count + 1;
    end
    
    // Test case 5: Reset test
    rst = 1;
    @(posedge clk);
    #1;
    if (i !== 0 || q !== 0) begin
        $display("Error case 5: Reset, Expected i=0, q=0, Got i=%0d, q=%0d", i, q);
        error_count = error_count + 1;
    end
    rst = 0;
    
    // Test case 6: Dynamic input
    repeat (10) begin
        x = $rtoi(127 * $sin(2 * 3.14159 * $time / 100));
        @(posedge clk);
        #1;
        if (i !== ((x * 90) >>> 7) || q !== ((x * 90) >>> 7)) begin
            $display("Error case 6: Dynamic input=%0d, Expected i=%0d, q=%0d, Got i=%0d, q=%0d", 
                    x, ((x * 90) >>> 7), ((x * 90) >>> 7), i, q);
            error_count = error_count + 1;
        end
    end
    
    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end
    $finish;
end

endmodule