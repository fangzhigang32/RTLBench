`timescale 1ns/1ps

module tb_mcd_8bit();

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] a;
    reg [7:0] b;

    // Output
    wire [15:0] mcd_out;

    // Instantiate the Unit Under Test (UUT)
    mcd_8bit uut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .mcd_out(mcd_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    reg error_flag = 0;

    // Test cases
    task test_case;
        input [7:0] in_a;
        input [7:0] in_b;
        input [15:0] expected;
        begin
            a = in_a;
            b = in_b;
            rst = 1;
            @(posedge clk);
            rst = 0;
            
            // Wait for computation to complete (fixed number of cycles)
            // Adjust the number of cycles based on your design's requirements
            repeat(20) @(posedge clk);
            
            // Check result
            if (mcd_out !== expected) begin
                $display("Error: a=%d, b=%d, Got=%d, Expected=%d", 
                         a, b, mcd_out, expected);
                error_flag = 1;
            end
            @(posedge clk);
        end
    endtask

    // Initialize inputs
    initial begin
        clk = 0;
        rst = 0;
        a = 0;
        b = 0;

        // Reset the design
        rst = 1;
        #20;
        rst = 0;
        #10;

        // Run test cases
        test_case(8'd15, 8'd20, 16'd5);    // GCD(15,20) = 5
        test_case(8'd21, 8'd14, 16'd7);    // GCD(21,14) = 7
        test_case(8'd48, 8'd18, 16'd6);    // GCD(48,18) = 6
        test_case(8'd17, 8'd23, 16'd1);    // GCD(17,23) = 1 (coprimes)
        test_case(8'd0, 8'd15, 16'd15);    // GCD(0,15) = 15
        test_case(8'd15, 8'd0, 16'd15);    // GCD(15,0) = 15
        test_case(8'd255, 8'd255, 16'd255); // GCD(255,255) = 255

        // Final result
        if (error_flag) begin
            $display("Exist Function Error");
        end
        else begin
            $display("No Function Error");
        end

        // Finish simulation
        $finish;
    end

endmodule