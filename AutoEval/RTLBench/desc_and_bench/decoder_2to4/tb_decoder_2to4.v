`timescale 1ns/1ps

module tb_decoder_2to4;
    reg [1:0] d;
    wire [3:0] y;
    reg error_flag;

    // Instantiate the Unit Under Test (UUT)
    decoder_2to4 uut (
        .d(d),
        .y(y)
    );

    // Task to check output
    task check_output;
        input [1:0] d_in;
        input [3:0] y_expected;
        begin
            #10; // Wait for combinational logic to stabilize
            if (y !== y_expected) begin
                $display("Error: d=%2b, y=%4b, expected y=%4b", d_in, y, y_expected);
                error_flag = 1;
            end
        end
    endtask

    initial begin
        // Initialize
        error_flag = 0;
        d = 2'b00;

        // Test case 1: d = 00
        d = 2'b00;
        check_output(2'b00, 4'b0001);

        // Test case 2: d = 01
        d = 2'b01;
        check_output(2'b01, 4'b0010);

        // Test case 3: d = 10
        d = 2'b10;
        check_output(2'b10, 4'b0100);

        // Test case 4: d = 11
        d = 2'b11;
        check_output(2'b11, 4'b1000);

        // Final result
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        $finish;
    end
endmodule