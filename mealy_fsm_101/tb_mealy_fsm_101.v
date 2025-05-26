`timescale 1ns/1ps

module tb_mealy_fsm_101;

// Inputs
reg clk;
reg rst;
reg in;

// Outputs
wire out;

// Instantiate the Unit Under Test (UUT)
mealy_fsm_101 uut (
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(out)
);

integer error_count;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus and checking
initial begin
    error_count = 0;
    
    // Initialize Inputs
    rst = 1;
    in = 0;
    
    // Reset the system
    #10;
    rst = 0;
    
    // Test case 1: No sequence
    in = 0;
    #10;
    if (out !== 0) begin
        $display("Error: Test case 1 failed - Input=%b, Output=%b, Expected=0", in, out);
        error_count = error_count + 1;
    end
    
    // Test case 2: Complete sequence 101
    in = 1; // S0->S1
    #10;
    if (out !== 0) begin
        $display("Error: Test case 2 failed - Input=%b, Output=%b, Expected=0", in, out);
        error_count = error_count + 1;
    end
    
    in = 0; // S1->S2
    #10;
    if (out !== 0) begin
        $display("Error: Test case 2 failed - Input=%b, Output=%b, Expected=0", in, out);
        error_count = error_count + 1;
    end
    
    in = 1; // S2->S0 with out=1
    #10;
    if (out !== 1) begin
        $display("Error: Test case 2 failed - Input=%b, Output=%b, Expected=1", in, out);
        error_count = error_count + 1;
    end
    
    // Test case 3: Incomplete sequence 10
    in = 1; // S0->S1
    #10;
    in = 0; // S1->S2
    #10;
    in = 0; // S2->S0 with out=0
    #10;
    if (out !== 0) begin
        $display("Error: Test case 3 failed - Input=%b, Output=%b, Expected=0", in, out);
        error_count = error_count + 1;
    end
    
    // Test case 4: Reset during sequence
    in = 1; // S0->S1
    #10;
    rst = 1;
    #10;
    if (out !== 0) begin
        $display("Error: Test case 4 failed - Input=%b, Output=%b, Expected=0", in, out);
        error_count = error_count + 1;
    end
    
    rst = 0;
    #10;
    
    // Test case 5: Overlapping sequence 10101
    in = 1; // S0->S1
    #10;
    in = 0; // S1->S2
    #10;
    in = 1; // S2->S0 with out=1
    #10;
    if (out !== 1) begin
        $display("Error: Test case 5 failed - Input=%b, Output=%b, Expected=1", in, out);
        error_count = error_count + 1;
    end
    
    in = 0; // S0->S0
    #10;
    in = 1; // S0->S1
    #10;
    if (out !== 0) begin
        $display("Error: Test case 5 failed - Input=%b, Output=%b, Expected=0", in, out);
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

endmodule