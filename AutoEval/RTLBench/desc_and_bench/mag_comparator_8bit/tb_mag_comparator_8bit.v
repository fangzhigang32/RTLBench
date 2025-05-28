`timescale 1ns/1ps

module tb_mag_comparator_8bit;

    // Inputs
    reg [7:0] a;
    reg [7:0] b;

    // Outputs
    wire gt;
    wire eq;
    wire lt;

    // Instantiate the Unit Under Test (UUT)
    mag_comparator_8bit uut (
        .a(a),
        .b(b),
        .gt(gt),
        .eq(eq),
        .lt(lt)
    );

    reg error_flag = 0;

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;

        // Wait for global reset
        #100;

        // Test case 1: a == b
        a = 8'h55;
        b = 8'h55;
        #10;
        if (!(eq === 1'b1 && gt === 1'b0 && lt === 1'b0)) begin
            $display("Error case 1: a=%h, b=%h, gt=%b, eq=%b, lt=%b (expected gt=0, eq=1, lt=0)", a, b, gt, eq, lt);
            error_flag = 1;
        end

        // Test case 2: a > b
        a = 8'hAA;
        b = 8'h55;
        #10;
        if (!(gt === 1'b1 && eq === 1'b0 && lt === 1'b0)) begin
            $display("Error case 2: a=%h, b=%h, gt=%b, eq=%b, lt=%b (expected gt=1, eq=0, lt=0)", a, b, gt, eq, lt);
            error_flag = 1;
        end

        // Test case 3: a < b
        a = 8'h33;
        b = 8'h77;
        #10;
        if (!(lt === 1'b1 && eq === 1'b0 && gt === 1'b0)) begin
            $display("Error case 3: a=%h, b=%h, gt=%b, eq=%b, lt=%b (expected gt=0, eq=0, lt=1)", a, b, gt, eq, lt);
            error_flag = 1;
        end

        // Test case 4: edge case (max vs min)
        a = 8'hFF;
        b = 8'h00;
        #10;
        if (!(gt === 1'b1 && eq === 1'b0 && lt === 1'b0)) begin
            $display("Error case 4: a=%h, b=%h, gt=%b, eq=%b, lt=%b (expected gt=1, eq=0, lt=0)", a, b, gt, eq, lt);
            error_flag = 1;
        end

        // Test case 5: edge case (min vs max)
        a = 8'h00;
        b = 8'hFF;
        #10;
        if (!(lt === 1'b1 && eq === 1'b0 && gt === 1'b0)) begin
            $display("Error case 5: a=%h, b=%h, gt=%b, eq=%b, lt=%b (expected gt=0, eq=0, lt=1)", a, b, gt, eq, lt);
            error_flag = 1;
        end

        // Test case 6: random values
        a = $random;
        b = $random;
        #10;
        if (a > b) begin
            if (!(gt === 1'b1 && eq === 1'b0 && lt === 1'b0)) begin
                $display("Error case 6: a=%h, b=%h, gt=%b, eq=%b, lt=%b (expected gt=1, eq=0, lt=0)", a, b, gt, eq, lt);
                error_flag = 1;
            end
        end else if (a < b) begin
            if (!(lt === 1'b1 && eq === 1'b0 && gt === 1'b0)) begin
                $display("Error case 6: a=%h, b=%h, gt=%b, eq=%b, lt=%b (expected gt=0, eq=0, lt=1)", a, b, gt, eq, lt);
                error_flag = 1;
            end
        end else begin
            if (!(eq === 1'b1 && gt === 1'b0 && lt === 1'b0)) begin
                $display("Error case 6: a=%h, b=%h, gt=%b, eq=%b, lt=%b (expected gt=0, eq=1, lt=0)", a, b, gt, eq, lt);
                error_flag = 1;
            end
        end

        // Final result
        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end

        // Finish simulation
        $finish;
    end

endmodule