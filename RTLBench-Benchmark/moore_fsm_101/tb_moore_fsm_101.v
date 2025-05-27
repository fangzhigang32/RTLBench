`timescale 1ns/1ps

module tb_moore_fsm_101();

// Inputs
reg clk;
reg rst;
reg in;

// Output
wire out;

// Instantiate the Unit Under Test (UUT)
moore_fsm_101 uut (
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
integer error_count = 0;

initial begin
    // Initialize Inputs
    rst = 1;
    in = 0;
    
    // Reset the system
    #10;
    rst = 0;
    
    // Test case 1: No sequence (should not detect)
    in = 0; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    in = 1; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    in = 0; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    // Test case 2: Complete "101" sequence (should detect at 3rd clock)
    in = 1; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    in = 0; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    in = 1; #10;
    if (out !== 1) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=1", $time, in, out);
        error_count = error_count + 1;
    end
    
    // Test case 3: Overlapping "101" sequence
    in = 0; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    in = 1; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    in = 1; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    in = 0; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    in = 1; #10;
    if (out !== 1) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=1", $time, in, out);
        error_count = error_count + 1;
    end
    
    // Test case 4: Reset during sequence
    rst = 1; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    rst = 0;
    in = 1; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    in = 0; #10;
    if (out !== 0) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=0", $time, in, out);
        error_count = error_count + 1;
    end
    
    in = 1; #10;
    if (out !== 1) begin
        $display("Error at t=%0t: in=%b, out=%b, expected=1", $time, in, out);
        error_count = error_count + 1;
    end
    
    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end
    else begin
        $display("Exist Function Error");
    end
    
    $finish;
end

endmodule