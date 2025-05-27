`timescale 1ns/1ps

module tb_edge_detect;

// Inputs
reg clk;
reg rst;
reg a;

// Outputs
wire rise;
wire down;

// Instantiate the Unit Under Test (UUT)
edge_detect uut (
    .clk(clk),
    .rst(rst),
    .a(a),
    .rise(rise),
    .down(down)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
integer error_count = 0;

initial begin
    // Initialize Inputs
    rst = 1;
    a = 0;
    
    // Wait for global reset
    #20;
    rst = 0;
    
    // Test case 1: No edge
    a = 0;
    #10;
    if (rise !== 0 || down !== 0) begin
        $display("Error at time %0t: input a=%b, output rise=%b, down=%b, expected rise=0, down=0", $time, a, rise, down);
        error_count = error_count + 1;
    end
    
    // Test case 2: Rising edge
    a = 1;
    #10;
    if (rise !== 1 || down !== 0) begin
        $display("Error at time %0t: input a=%b, output rise=%b, down=%b, expected rise=1, down=0", $time, a, rise, down);
        error_count = error_count + 1;
    end
    
    // Test case 3: No edge
    a = 1;
    #10;
    if (rise !== 0 || down !== 0) begin
        $display("Error at time %0t: input a=%b, output rise=%b, down=%b, expected rise=0, down=0", $time, a, rise, down);
        error_count = error_count + 1;
    end
    
    // Test case 4: Falling edge
    a = 0;
    #10;
    if (rise !== 0 || down !== 1) begin
        $display("Error at time %0t: input a=%b, output rise=%b, down=%b, expected rise=0, down=1", $time, a, rise, down);
        error_count = error_count + 1;
    end
    
    // Test case 5: No edge
    a = 0;
    #10;
    if (rise !== 0 || down !== 0) begin
        $display("Error at time %0t: input a=%b, output rise=%b, down=%b, expected rise=0, down=0", $time, a, rise, down);
        error_count = error_count + 1;
    end
    
    // Test case 6: Rising edge followed by falling edge
    a = 1;
    #10;
    if (rise !== 1 || down !== 0) begin
        $display("Error at time %0t: input a=%b, output rise=%b, down=%b, expected rise=1, down=0", $time, a, rise, down);
        error_count = error_count + 1;
    end
    a = 0;
    #10;
    if (rise !== 0 || down !== 1) begin
        $display("Error at time %0t: input a=%b, output rise=%b, down=%b, expected rise=0, down=1", $time, a, rise, down);
        error_count = error_count + 1;
    end
    
    // Test case 7: Reset test
    rst = 1;
    #10;
    if (rise !== 0 || down !== 0) begin
        $display("Error at time %0t: input rst=%b, output rise=%b, down=%b, expected rise=0, down=0", $time, rst, rise, down);
        error_count = error_count + 1;
    end
    
    // Final result
    if (error_count == 0) begin
        $display("No Function Error");
    end else begin
        $display("Exist Function Error");
    end
    $finish;
end

endmodule