`timescale 1ns/1ps

module tb_lcm_8bit();

// Inputs
reg clk;
reg rst;
reg [7:0] a;
reg [7:0] b;

// Outputs
wire [15:0] lcm_out;

// Instantiate the Unit Under Test (UUT)
lcm_8bit uut (
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .lcm_out(lcm_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

reg error_flag = 0;

// Test cases
task test_case;
    input [7:0] a_val;
    input [7:0] b_val;
    input [15:0] expected;
    begin
        a = a_val;
        b = b_val;
        rst = 1;
        #10;
        rst = 0;
        
        // Wait for calculation to complete (5 clock cycles)
        #60;
        
        if (lcm_out !== expected) begin
            $display("Error: a=%d, b=%d, LCM=%d, Expected=%d", 
                     a_val, b_val, lcm_out, expected);
            error_flag = 1;
        end
    end
endtask

// Test stimulus
initial begin
    // Initialize Inputs
    rst = 1;
    a = 0;
    b = 0;
    
    // Wait for global reset
    #20;
    
    // Test cases
    test_case(8'd12, 8'd18, 16'd36);  // Simple case
    test_case(8'd15, 8'd20, 16'd60);  // Another simple case
    test_case(8'd7, 8'd13, 16'd91);   // Co-prime numbers
    test_case(8'd0, 8'd5, 16'd0);     // Zero case
    test_case(8'd255, 8'd1, 16'd255); // Max value with 1
    test_case(8'd128, 8'd64, 16'd128); // Powers of 2
    
    // Finish simulation
    #20;
    if (error_flag) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    $finish;
end

endmodule