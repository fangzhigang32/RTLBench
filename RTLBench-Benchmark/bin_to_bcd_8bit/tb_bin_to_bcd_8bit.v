`timescale 1ns/1ps

module tb_bin_to_bcd_8bit;

    // Inputs
    reg [7:0] b;
    
    // Outputs
    wire [11:0] d;
    
    // Instantiate the Unit Under Test (UUT)
    bin_to_bcd_8bit uut (
        .b(b),
        .d(d)
    );
    
    integer i;
    reg [11:0] expected;
    integer error_count;
    
    // Task to display BCD value (replaces the string function)
    task display_bcd;
        input [11:0] bcd;
        begin
            $write("%0d%0d%0d", bcd[11:8], bcd[7:4], bcd[3:0]);
        end
    endtask
    
    initial begin
        // Initialize Inputs and variables
        b = 0;
        expected = 0;
        error_count = 0;
        
        // Wait for global reset
        #100;
        
        // Test all possible 8-bit inputs (0 to 255)
        for (i = 0; i <= 255; i = i + 1) begin
            b = i;
            #10;
            
            // Calculate expected value
            expected[11:8] = i / 100;           // Hundreds
            expected[7:4] = (i % 100) / 10;     // Tens
            expected[3:0] = i % 10;             // Units
            
            // Check output
            if (d !== expected) begin
                $display("Error: Input=%d, Output=", b);
                display_bcd(d);
                $write(", Expected=");
                display_bcd(expected);
                $display("");
                error_count = error_count + 1;
            end
        end
        
        // Test boundary cases
        b = 8'd255; // Maximum valid input
        #10;
        b = 8'bxxxx_xxxx; // Test with undefined value
        #10;
        
        // Final status
        if (error_count == 0)
            $display("No Function Error");
        else
            $display("Exist Function Error");
        
        $finish;
    end

endmodule