`timescale 1ns/1ps

module tb_async_fsm_11();

reg in;
wire out;

// Instantiate the DUT
async_fsm_11 dut (
    .in(in),
    .out(out)
);

integer i;
integer pass_count = 0;
integer fail_count = 0;

// Extended test pattern and expected output
reg [15:0] test_pattern = 16'b1101101100110011; // Longer sequence with varied patterns
reg [15:0] expected_out = 16'b0010001000110011; // Expected output for "11" detection

initial begin
    // Initialize inputs
    in = 0;
    
    // Monitor changes
    $monitor("Time = %t, in = %b, out = %b", $time, in, out);
    
    // Apply test pattern
    for (i = 0; i < 16; i = i + 1) begin
        #10 in = test_pattern[i];
        #5; // Increased delay for state stabilization
        
        // Check output
        if (out !== expected_out[i]) begin
            $display("Error at time %t: in = %b, out = %b (expected %b)", 
                    $time, in, out, expected_out[i]);
            fail_count = fail_count + 1;
        end else begin
            pass_count = pass_count + 1;
        end
    end
    
    // Additional test cases
    // Test reset behavior
    #10 in = 0;
    #5;
    if (out !== 0) begin
        $display("Error: Reset test failed - out = %b (expected 0)", out);
        fail_count = fail_count + 1;
    end else begin
        pass_count = pass_count + 1;
    end
    
    // Test continuous 1's
    #10 in = 1;
    #10 in = 1;
    #10 in = 1;
    #5;
    if (out !== 1) begin
        $display("Error: Continuous 1's test failed - out = %b (expected 1)", out);
        fail_count = fail_count + 1;
    end else begin
        pass_count = pass_count + 1;
    end
    
    // Test rapid input switching
    #10 in = 1;
    #2 in = 0;
    #2 in = 1;
    #5;
    if (out !== 0) begin
        $display("Error: Rapid switching test failed - out = %b (expected 0)", out);
        fail_count = fail_count + 1;
    end else begin
        pass_count = pass_count + 1;
    end
    
    // Final status output
    if (fail_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end
    $finish;
end

endmodule