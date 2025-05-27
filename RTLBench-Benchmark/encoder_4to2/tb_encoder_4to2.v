`timescale 1ns/1ps

module tb_encoder_4to2;
    reg [3:0] d;
    wire [1:0] y;
    wire v;

    // Instantiate the DUT
    encoder_4to2 dut (
        .d(d),
        .y(y),
        .v(v)
    );

    integer i;
    reg [1:0] expected_y;
    reg expected_v;
    integer error_count = 0;

    initial begin
        // Initialize input to a known state
        d = 4'b0000;
        #20;

        // Test all possible input combinations
        for (i = 0; i < 16; i = i + 1) begin
            d = i;
            #20;

            // Determine expected outputs
            casex (d)
                4'b1xxx: begin expected_y = 2'b11; expected_v = 1'b1; end
                4'b01xx: begin expected_y = 2'b10; expected_v = 1'b1; end
                4'b001x: begin expected_y = 2'b01; expected_v = 1'b1; end
                4'b0001: begin expected_y = 2'b00; expected_v = 1'b1; end
                default: begin expected_y = 2'b00; expected_v = 1'b0; end
            endcase

            // Check outputs and count errors
            if (y != expected_y || v != expected_v) begin
                error_count = error_count + 1;
                $display("Error for input %b:", d);
                $display("  Output: y=%b, v=%b", y, v);
                $display("  Expected: y=%b, v=%b", expected_y, expected_v);
            end
        end

        // Quick transition test
        d = 4'b1000; #5;
        d = 4'b0100; #5;
        d = 4'b0010; #5;
        d = 4'b0001; #5;

        // Final result
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end

        $finish;
    end
endmodule