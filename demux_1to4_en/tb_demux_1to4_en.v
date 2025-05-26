`timescale 1ns/1ps

module tb_demux_1to4_en;

    // Inputs
    reg d;
    reg [1:0] sel;
    reg en;
    
    // Outputs
    wire [3:0] y;
    
    // Instantiate the Unit Under Test (UUT)
    demux_1to4_en uut (
        .d(d),
        .sel(sel),
        .en(en),
        .y(y)
    );
    
    integer i;
    reg [3:0] expected;
    integer error_count = 0;
    integer test_count = 0;
    
    initial begin
        // Initialize Inputs
        d = 0;
        sel = 0;
        en = 0;
        
        // Wait for global reset
        #100;
        
        // Test case 1: Disabled case
        en = 0;
        d = 1;
        sel = 2'b00;
        expected = 4'b0000;
        #10;
        test_count = test_count + 1;
        if (y !== expected) begin
            $display("Error: Disabled case failed. Input: en=%b, sel=%b, d=%b | Output: %b | Expected: %b", en, sel, d, y, expected);
            error_count = error_count + 1;
        end
        
        // Test case 2: Enable and all selection cases
        en = 1;
        for (i = 0; i < 4; i = i + 1) begin
            sel = i;
            d = 1;
            case (sel)
                2'b00: expected = 4'b0001;
                2'b01: expected = 4'b0010;
                2'b10: expected = 4'b0100;
                2'b11: expected = 4'b1000;
            endcase
            #10;
            test_count = test_count + 1;
            if (y !== expected) begin
                $display("Error: Sel=%b case failed. Input: en=%b, sel=%b, d=%b | Output: %b | Expected: %b", sel, en, sel, d, y, expected);
                error_count = error_count + 1;
            end
            
            d = 0;
            expected = 4'b0000;
            #10;
            test_count = test_count + 1;
            if (y !== expected) begin
                $display("Error: Sel=%b with d=0 failed. Input: en=%b, sel=%b, d=%b | Output: %b | Expected: %b", sel, en, sel, d, y, expected);
                error_count = error_count + 1;
            end
        end
        
        // Test case 3: Random cases with constrained sel
        en = 1;
        repeat (10) begin
            d = $random;
            sel = $urandom % 4;
            case (sel)
                2'b00: expected = {3'b000, d};
                2'b01: expected = {2'b00, d, 1'b0};
                2'b10: expected = {1'b0, d, 2'b00};
                2'b11: expected = {d, 3'b000};
            endcase
            #10;
            test_count = test_count + 1;
            if (y !== expected) begin
                $display("Error: Random case failed. Input: en=%b, sel=%b, d=%b | Output: %b | Expected: %b", en, sel, d, y, expected);
                error_count = error_count + 1;
            end
        end
        
        // Test case 4: Dynamic switching of en
        d = 1;
        sel = 2'b01;
        en = 0;
        expected = 4'b0000;
        #10;
        test_count = test_count + 1;
        if (y !== expected) begin
            $display("Error: Dynamic en=0 case failed. Input: en=%b, sel=%b, d=%b | Output: %b | Expected: %b", en, sel, d, y, expected);
            error_count = error_count + 1;
        end
        
        en = 1;
        expected = 4'b0010;
        #10;
        test_count = test_count + 1;
        if (y !== expected) begin
            $display("Error: Dynamic en=1 case failed. Input: en=%b, sel=%b, d=%b | Output: %b | Expected: %b", en, sel, d, y, expected);
            error_count = error_count + 1;
        end
        
        // Test case 5: Invalid sel input
        en = 1;
        d = 1;
        sel = 2'bxx;
        expected = 4'b0000;
        #10;
        test_count = test_count + 1;
        if (y !== expected) begin
            $display("Error: Invalid sel case failed. Input: en=%b, sel=%b, d=%b | Output: %b | Expected: %b", en, sel, d, y, expected);
            error_count = error_count + 1;
        end
        
        // Final summary
        if (error_count == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        $finish;
    end
    
endmodule