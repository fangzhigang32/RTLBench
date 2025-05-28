`timescale 1ns/1ps

module tb_mux_4to1;
    // Inputs
    reg d0, d1, d2, d3;
    reg [1:0] sel;
    
    // Output
    wire y;
    
    // Error flag
    reg error_flag = 0;
    
    // Instantiate the Unit Under Test (UUT)
    mux_4to1 uut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );
    
    initial begin
        // Initialize Inputs
        d0 = 0;
        d1 = 0;
        d2 = 0;
        d3 = 0;
        sel = 2'b00;
        
        // Wait for global reset
        #10;
        
        // Test case 1: sel=00, d0=1
        d0 = 1; d1 = 0; d2 = 0; d3 = 0; sel = 2'b00;
        #10;
        if (y !== d0) begin
            $display("Error: sel=%b, d0=%b, d1=%b, d2=%b, d3=%b, y=%b (expected %b)", sel, d0, d1, d2, d3, y, d0);
            error_flag = 1;
        end
        
        // Test case 2: sel=01, d1=1
        d0 = 0; d1 = 1; d2 = 0; d3 = 0; sel = 2'b01;
        #10;
        if (y !== d1) begin
            $display("Error: sel=%b, d0=%b, d1=%b, d2=%b, d3=%b, y=%b (expected %b)", sel, d0, d1, d2, d3, y, d1);
            error_flag = 1;
        end
        
        // Test case 3: sel=10, d2=1
        d0 = 0; d1 = 0; d2 = 1; d3 = 0; sel = 2'b10;
        #10;
        if (y !== d2) begin
            $display("Error: sel=%b, d0=%b, d1=%b, d2=%b, d3=%b, y=%b (expected %b)", sel, d0, d1, d2, d3, y, d2);
            error_flag = 1;
        end
        
        // Test case 4: sel=11, d3=1
        d0 = 0; d1 = 0; d2 = 0; d3 = 1; sel = 2'b11;
        #10;
        if (y !== d3) begin
            $display("Error: sel=%b, d0=%b, d1=%b, d2=%b, d3=%b, y=%b (expected %b)", sel, d0, d1, d2, d3, y, d3);
            error_flag = 1;
        end
        
        // Test case 5: sel=00, all inputs high
        d0 = 1; d1 = 1; d2 = 1; d3 = 1; sel = 2'b00;
        #10;
        if (y !== d0) begin
            $display("Error: sel=%b, d0=%b, d1=%b, d2=%b, d3=%b, y=%b (expected %b)", sel, d0, d1, d2, d3, y, d0);
            error_flag = 1;
        end
        
        // Test case 6: sel=01, mixed inputs
        d0 = 0; d1 = 1; d2 = 0; d3 = 1; sel = 2'b01;
        #10;
        if (y !== d1) begin
            $display("Error: sel=%b, d0=%b, d1=%b, d2=%b, d3=%b, y=%b (expected %b)", sel, d0, d1, d2, d3, y, d1);
            error_flag = 1;
        end
        
        // Test case 7: sel=10, mixed inputs
        d0 = 1; d1 = 0; d2 = 1; d3 = 0; sel = 2'b10;
        #10;
        if (y !== d2) begin
            $display("Error: sel=%b, d0=%b, d1=%b, d2=%b, d3=%b, y=%b (expected %b)", sel, d0, d1, d2, d3, y, d2);
            error_flag = 1;
        end
        
        // Test case 8: sel=11, mixed inputs
        d0 = 0; d1 = 1; d2 = 0; d3 = 1; sel = 2'b11;
        #10;
        if (y !== d3) begin
            $display("Error: sel=%b, d0=%b, d1=%b, d2=%b, d3=%b, y=%b (expected %b)", sel, d0, d1, d2, d3, y, d3);
            error_flag = 1;
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