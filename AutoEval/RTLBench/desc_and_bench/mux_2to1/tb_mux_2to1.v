`timescale 1ns/1ps

module tb_mux_2to1;
    // Inputs
    reg d0;
    reg d1;
    reg sel;
    
    // Output
    wire y;
    
    // Instantiate the Unit Under Test (UUT)
    mux_2to1 uut (
        .d0(d0),
        .d1(d1),
        .sel(sel),
        .y(y)
    );
    
    reg error_flag = 0;
    
    initial begin
        // Initialize Inputs
        d0 = 0;
        d1 = 0;
        sel = 0;
        
        // Wait 100 ns for global reset
        #100;
        
        // Test case 1: sel=0, d0=0, d1=0
        d0 = 0; d1 = 0; sel = 0;
        #10;
        if (y !== 0) begin
            $display("Error: Test case 1 - Input: d0=%b, d1=%b, sel=%b | Output: y=%b | Expected: y=0", d0, d1, sel, y);
            error_flag = 1;
        end
        
        // Test case 2: sel=0, d0=1, d1=0
        d0 = 1; d1 = 0; sel = 0;
        #10;
        if (y !== 1) begin
            $display("Error: Test case 2 - Input: d0=%b, d1=%b, sel=%b | Output: y=%b | Expected: y=1", d0, d1, sel, y);
            error_flag = 1;
        end
        
        // Test case 3: sel=1, d0=0, d1=0
        d0 = 0; d1 = 0; sel = 1;
        #10;
        if (y !== 0) begin
            $display("Error: Test case 3 - Input: d0=%b, d1=%b, sel=%b | Output: y=%b | Expected: y=0", d0, d1, sel, y);
            error_flag = 1;
        end
        
        // Test case 4: sel=1, d0=0, d1=1
        d0 = 0; d1 = 1; sel = 1;
        #10;
        if (y !== 1) begin
            $display("Error: Test case 4 - Input: d0=%b, d1=%b, sel=%b | Output: y=%b | Expected: y=1", d0, d1, sel, y);
            error_flag = 1;
        end
        
        // Test case 5: sel=1, d0=1, d1=1
        d0 = 1; d1 = 1; sel = 1;
        #10;
        if (y !== 1) begin
            $display("Error: Test case 5 - Input: d0=%b, d1=%b, sel=%b | Output: y=%b | Expected: y=1", d0, d1, sel, y);
            error_flag = 1;
        end
        
        // Test case 6: sel=0, d0=1, d1=1
        d0 = 1; d1 = 1; sel = 0;
        #10;
        if (y !== 1) begin
            $display("Error: Test case 6 - Input: d0=%b, d1=%b, sel=%b | Output: y=%b | Expected: y=1", d0, d1, sel, y);
            error_flag = 1;
        end
        
        if (error_flag == 0) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end
        
        $finish;
    end
endmodule