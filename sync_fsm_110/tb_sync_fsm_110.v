`timescale 1ns/1ps

module tb_sync_fsm_110();

// Inputs
reg clk;
reg rst;
reg in;

// Outputs
wire out;

// Instantiate the Unit Under Test (UUT)
sync_fsm_110 uut (
    .clk(clk),
    .rst(rst),
    .in(in),
    .out(out)
);

reg error_flag;

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus and checking
initial begin
    error_flag = 0;
    
    // Initialize Inputs
    rst = 1;
    in = 0;
    
    // Reset the system
    #10;
    rst = 0;
    
    // Test case 1: 110 sequence
    in = 1; #10; // S0->S1
    in = 1; #10; // S1->S2
    in = 0; #10; // S2->S3 (should output 1)
    if (out !== 1'b1) begin
        $display("Error: Test case 1 failed");
        $display("Input: 110 sequence");
        $display("Output: %b", out);
        $display("Expected: 1");
        error_flag = 1;
    end
    
    // Test case 2: incomplete sequence 11
    in = 1; #10; // S3->S1
    in = 1; #10; // S1->S2
    if (out !== 1'b0) begin
        $display("Error: Test case 2 failed");
        $display("Input: incomplete sequence 11");
        $display("Output: %b", out);
        $display("Expected: 0");
        error_flag = 1;
    end
    
    // Test case 3: reset during sequence
    rst = 1; #10;
    rst = 0;
    in = 1; #10; // S0->S1
    in = 1; #10; // S1->S2
    rst = 1; #10; // Should reset to S0
    if (out !== 1'b0 || uut.current_state !== 2'b00) begin
        $display("Error: Test case 3 failed");
        $display("Input: reset during sequence");
        $display("Output: %b, state: %b", out, uut.current_state);
        $display("Expected: 0, state: 00");
        error_flag = 1;
    end
    
    // Test case 4: no sequence
    rst = 0;
    in = 0; #10; // S0->S0
    in = 0; #10; // S0->S0
    in = 1; #10; // S0->S1
    in = 0; #10; // S1->S0
    if (out !== 1'b0) begin
        $display("Error: Test case 4 failed");
        $display("Input: no sequence");
        $display("Output: %b", out);
        $display("Expected: 0");
        error_flag = 1;
    end
    
    // Test case 5: multiple sequences
    in = 1; #10; // S0->S1
    in = 1; #10; // S1->S2
    in = 0; #10; // S2->S3 (output 1)
    in = 1; #10; // S3->S1
    in = 1; #10; // S1->S2
    in = 0; #10; // S2->S3 (output 1)
    if (out !== 1'b1) begin
        $display("Error: Test case 5 failed");
        $display("Input: multiple sequences");
        $display("Output: %b", out);
        $display("Expected: 1");
        error_flag = 1;
    end
    
    // Finish simulation
    #10;
    if (error_flag) begin
        $display("Exist Function Error");
    end
    else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule