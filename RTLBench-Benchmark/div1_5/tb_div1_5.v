`timescale 1ns/1ps

module tb_div1_5();

// Inputs
reg clk;
reg rst;

// Outputs
wire clk_out;

// Instantiate the Unit Under Test (UUT)
div1_5 uut (
    .clk(clk),
    .rst(rst),
    .clk_out(clk_out)
);

integer error_count;

// Clock generation: 100MHz clock (10ns period)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    error_count = 0;
    
    // Initialize inputs
    rst = 1;
    #20;
    
    // Release reset
    rst = 0;
    
    // Wait for a few cycles to ensure reset takes effect
    @(posedge clk);
    
    // Test reset state
    if (clk_out !== 1'b0) begin
        $display("Error at time %0t: Expected clk_out=0 after reset, got %b", $time, clk_out);
        error_count = error_count + 1;
    end
    
    // Verify output pattern over multiple cycles (at least 2 full output cycles)
    repeat(6) begin
        @(posedge clk); // Check on rising edge
        #1; // Small delay to ensure signal stability
        case ( ($time - 21) / 10 % 3 ) // Adjust for reset time
            0: begin // S0: Expect clk_out = 1
                if (clk_out !== 1'b1) begin
                    $display("Error at time %0t: Expected clk_out=1, got %b", $time, clk_out);
                    error_count = error_count + 1;
                end
            end
            1: begin // S1: Expect clk_out = 1
                if (clk_out !== 1'b1) begin
                    $display("Error at time %0t: Expected clk_out=1, got %b", $time, clk_out);
                    error_count = error_count + 1;
                end
            end
            2: begin // S2: Expect clk_out = 0
                if (clk_out !== 1'b0) begin
                    $display("Error at time %0t: Expected clk_out=0, got %b", $time, clk_out);
                    error_count = error_count + 1;
                end
            end
        endcase
    end
    
    // Test reset functionality during operation
    @(posedge clk);
    rst = 1;
    @(posedge clk);
    #1;
    if (clk_out !== 1'b0) begin
        $display("Error at time %0t: Expected clk_out=0 after reset, got %b", $time, clk_out);
        error_count = error_count + 1;
    end
    
    // Release reset and continue testing
    rst = 0;
    repeat(3) @(posedge clk); // Test one more cycle after reset
    
    // Final status report
    if (error_count == 0) begin
        $display("No Function Error");
    end
    else begin
        $display("Exist Function Error");
    end
    
    $finish;
end

endmodule