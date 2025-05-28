`timescale 1ns/1ps

module tb_decoder_2to4_en;

    // Inputs
    reg en;
    reg [1:0] d;

    // Outputs
    wire [3:0] y;

    // Instantiate the Unit Under Test (UUT)
    decoder_2to4_en uut (
        .en(en),
        .d(d),
        .y(y)
    );

    integer i;
    reg [3:0] expected;
    reg error_flag;

    // Random seed for reproducibility
    initial begin
        $urandom(1234); // Set a fixed seed for repeatable random tests
        error_flag = 0;

        // Initialize Inputs
        en = 0;
        d = 2'b00;

        // Test case 0: Check initial state
        #10;
        expected = 4'b0000;
        if (y !== expected) begin
            $display("Error: Initial state, en=%b, d=%b, y=%b, expected=%b", en, d, y, expected);
            error_flag = 1;
        end

        // Test case 1: Enable = 0 (decoder disabled)
        en = 0;
        for (i = 0; i < 4; i = i + 1) begin
            d = i;
            #10;
            expected = 4'b0000;
            if (y !== expected) begin
                $display("Error: en=%b, d=%b, y=%b, expected=%b", en, d, y, expected);
                error_flag = 1;
            end
        end

        // Test case 2: Enable = 1 (decoder enabled)
        en = 1;
        for (i = 0; i < 4; i = i + 1) begin
            d = i;
            #10;
            case (d)
                2'b00: expected = 4'b0001;
                2'b01: expected = 4'b0010;
                2'b10: expected = 4'b0100;
                2'b11: expected = 4'b1000;
                default: expected = 4'b0000;
            endcase
            if (y !== expected) begin
                $display("Error: en=%b, d=%b, y=%b, expected=%b", en, d, y, expected);
                error_flag = 1;
            end
        end

        // Test case 3: Random tests
        for (i = 0; i < 10; i = i + 1) begin
            en = $urandom % 2; // Random enable (0 or 1)
            d = $urandom % 4;  // Random input (0 to 3)
            #10;
            if (en) begin
                case (d)
                    2'b00: expected = 4'b0001;
                    2'b01: expected = 4'b0010;
                    2'b10: expected = 4'b0100;
                    2'b11: expected = 4'b1000;
                    default: expected = 4'b0000;
                endcase
            end else begin
                expected = 4'b0000;
            end
            if (y !== expected) begin
                $display("Error: en=%b, d=%b, y=%b, expected=%b", en, d, y, expected);
                error_flag = 1;
            end
        end

        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end
        $finish;
    end

endmodule