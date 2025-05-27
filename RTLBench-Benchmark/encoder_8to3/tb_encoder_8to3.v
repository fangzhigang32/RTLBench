`timescale 1ns/1ps

module tb_encoder_8to3;
    reg [7:0] d;
    wire [2:0] y;
    wire v;

    // Instantiate the DUT
    encoder_8to3 dut (
        .d(d),
        .y(y),
        .v(v)
    );

    integer i;
    reg [2:0] expected_y;
    reg expected_v;
    integer error_count; // Track errors

    initial begin
        error_count = 0; // Initialize error counter

        // Test specific priority cases
        d = 8'b10000000; #10; // Test highest priority (d[7])
        expected_y = 3'b111; expected_v = 1'b1;
        check_output();

        d = 8'b01000000; #10; // Test d[6]
        expected_y = 3'b110; expected_v = 1'b1;
        check_output();

        d = 8'b00100000; #10; // Test d[5]
        expected_y = 3'b101; expected_v = 1'b1;
        check_output();

        d = 8'b00010000; #10; // Test d[4]
        expected_y = 3'b100; expected_v = 1'b1;
        check_output();

        d = 8'b00001000; #10; // Test d[3]
        expected_y = 3'b011; expected_v = 1'b1;
        check_output();

        d = 8'b00000100; #10; // Test d[2]
        expected_y = 3'b010; expected_v = 1'b1;
        check_output();

        d = 8'b00000010; #10; // Test d[1]
        expected_y = 3'b001; expected_v = 1'b1;
        check_output();

        d = 8'b00000001; #10; // Test d[0]
        expected_y = 3'b000; expected_v = 1'b1;
        check_output();

        d = 8'b00000000; #10; // Test all zeros
        expected_y = 3'b000; expected_v = 1'b0;
        check_output();

        // Test random cases for coverage
        for (i = 0; i < 50; i = i + 1) begin
            d = $random; #10; // Random input
            // Determine expected outputs
            casez (d)
                8'b1???????: begin expected_y = 3'b111; expected_v = 1'b1; end
                8'b01??????: begin expected_y = 3'b110; expected_v = 1'b1; end
                8'b001?????: begin expected_y = 3'b101; expected_v = 1'b1; end
                8'b0001????: begin expected_y = 3'b100; expected_v = 1'b1; end
                8'b00001???: begin expected_y = 3'b011; expected_v = 1'b1; end
                8'b000001??: begin expected_y = 3'b010; expected_v = 1'b1; end
                8'b0000001?: begin expected_y = 3'b001; expected_v = 1'b1; end
                8'b00000001: begin expected_y = 3'b000; expected_v = 1'b1; end
                default:     begin expected_y = 3'b000; expected_v = 1'b0; end
            endcase
            check_output();
        end

        // Print test summary
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end

    // Task to check outputs and log errors
    task check_output;
        if (y !== expected_y || v !== expected_v) begin
            $display("Error: d=%b, y=%b (expected %b), v=%b (expected %b)",
                     d, y, expected_y, v, expected_v);
            error_count = error_count + 1;
        end
    endtask
endmodule