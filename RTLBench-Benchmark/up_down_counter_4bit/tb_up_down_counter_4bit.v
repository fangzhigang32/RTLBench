`timescale 1ns/1ps

module tb_up_down_counter_4bit;
    reg clk;
    reg rst;
    reg en;
    reg up_down;
    wire [3:0] q;

    // Instantiate the DUT
    up_down_counter_4bit dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .up_down(up_down),
        .q(q)
    );

    integer error_count;

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test stimulus and checking
    initial begin
        error_count = 0;
        
        // Initialize signals
        clk = 0;
        rst = 1;
        en = 0;
        up_down = 0;
        
        // Reset test
        #10;
        if (q !== 4'b0000) begin
            $display("Error: Reset test failed. Input: rst=1, en=0, up_down=0 | Output: %b | Expected: 4'b0000", q);
            error_count = error_count + 1;
        end
        
        // Release reset and test counting
        rst = 0;
        en = 1;
        
        // Test up count
        up_down = 1;
        #10;
        if (q !== 4'b0001) begin
            $display("Error: Up count 1 failed. Input: rst=0, en=1, up_down=1 | Output: %b | Expected: 4'b0001", q);
            error_count = error_count + 1;
        end
        #10;
        if (q !== 4'b0010) begin
            $display("Error: Up count 2 failed. Input: rst=0, en=1, up_down=1 | Output: %b | Expected: 4'b0010", q);
            error_count = error_count + 1;
        end
        
        // Test down count
        up_down = 0;
        #10;
        if (q !== 4'b0001) begin
            $display("Error: Down count 1 failed. Input: rst=0, en=1, up_down=0 | Output: %b | Expected: 4'b0001", q);
            error_count = error_count + 1;
        end
        #10;
        if (q !== 4'b0000) begin
            $display("Error: Down count 2 failed. Input: rst=0, en=1, up_down=0 | Output: %b | Expected: 4'b0000", q);
            error_count = error_count + 1;
        end
        
        // Test enable
        en = 0;
        #10;
        if (q !== 4'b0000) begin
            $display("Error: Enable test failed. Input: rst=0, en=0, up_down=0 | Output: %b | Expected: 4'b0000", q);
            error_count = error_count + 1;
        end
        
        // Test wrap-around (up)
        en = 1;
        up_down = 1;
        repeat(15) #10;
        if (q !== 4'b1111) begin
            $display("Error: Up count to max failed. Input: rst=0, en=1, up_down=1 | Output: %b | Expected: 4'b1111", q);
            error_count = error_count + 1;
        end
        #10;
        if (q !== 4'b0000) begin
            $display("Error: Up count wrap failed. Input: rst=0, en=1, up_down=1 | Output: %b | Expected: 4'b0000", q);
            error_count = error_count + 1;
        end
        
        // Test wrap-around (down)
        up_down = 0;
        #10;
        if (q !== 4'b1111) begin
            $display("Error: Down count to min failed. Input: rst=0, en=1, up_down=0 | Output: %b | Expected: 4'b1111", q);
            error_count = error_count + 1;
        end
        
        // Final check
        if ($time != 360) begin
            $display("Error: Test duration mismatch");
            error_count = error_count + 1;
        end
        
        // Final result
        if (error_count == 0) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end
        
        $finish;
    end
endmodule