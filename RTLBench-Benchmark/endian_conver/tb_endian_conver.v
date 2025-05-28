`timescale 1ns/1ps

module tb_endian_conver;

    // Inputs
    reg clk;
    reg rst;
    reg [3:0] a;
    reg [3:0] b;

    // Outputs
    wire [3:0] c;
    wire [3:0] d;

    // Instantiate the Unit Under Test (UUT)
    endian_conver uut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .c(c),
        .d(d)
    );

    // Clock generation (10ns period)
    always begin
        #5 clk = ~clk;
    end

    reg error_flag = 0;

    // Task to check outputs
    task check_output;
        input [3:0] expected_c, expected_d;
        begin
            #1; // Small delay to ensure output is stable after clock edge
            if (c !== expected_c || d !== expected_d) begin
                $display("Error: Input a=%b, b=%b | Expected c=%b, d=%b | Got c=%b, d=%b", 
                         a, b, expected_c, expected_d, c, d);
                error_flag = 1;
            end
        end
    endtask

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        a = 0;
        b = 0;

        // Test case 0: Check initial state before clock
        check_output(4'b0000, 4'b0000); // Assuming outputs are 0 initially

        // Apply reset
        #2 rst = 1; // Asynchronous reset (not aligned to clock edge)
        #3 rst = 0;
        check_output(4'b0000, 4'b0000);

        // Wait for a clock edge
        @(posedge clk);

        // Test case 2: a=4'b1010, b=4'b0101
        a = 4'b1010;
        b = 4'b0101;
        @(posedge clk); // Wait for positive clock edge
        check_output(4'b0101, 4'b1010);

        // Test case 3: a=4'b1100, b=4'b0011
        a = 4'b1100;
        b = 4'b0011;
        @(posedge clk);
        check_output(4'b0011, 4'b1100);

        // Test case 4: a=4'b0001, b=4'b1000
        a = 4'b0001;
        b = 4'b1000;
        @(posedge clk);
        check_output(4'b1000, 4'b0001);

        // Test case 5: Boundary case - all zeros
        a = 4'b0000;
        b = 4'b0000;
        @(posedge clk);
        check_output(4'b0000, 4'b0000);

        // Test case 6: Boundary case - all ones
        a = 4'b1111;
        b = 4'b1111;
        @(posedge clk);
        check_output(4'b1111, 4'b1111);

        // Test case 7: Continuous input change over multiple clock cycles
        a = 4'b1011;
        b = 4'b1101;
        @(posedge clk);
        check_output(4'b1101, 4'b1011);
        a = 4'b0110;
        b = 4'b1001;
        @(posedge clk);
        check_output(4'b0110, 4'b1001);

        // Test case 8: Asynchronous reset in middle of clock cycle
        #2 rst = 1;
        #3 rst = 0;
        check_output(4'b0000, 4'b0000);

        // Final result
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end

        // Finish simulation
        #10 $finish;
    end

endmodule