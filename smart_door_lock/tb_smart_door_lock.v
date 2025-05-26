`timescale 1ns/1ps

module tb_smart_door_lock;
    // Inputs
    reg clk;
    reg rst;
    reg [3:0] pass;
    reg unlock;
    
    // Outputs
    wire open;
    wire error;
    
    // Test variables
    integer error_count;
    
    // Instantiate the Unit Under Test (UUT)
    smart_door_lock uut (
        .clk(clk),
        .rst(rst),
        .pass(pass),
        .unlock(unlock),
        .open(open),
        .error(error)
    );
    
    // Clock generation
    always begin
        #5 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        pass = 4'b0000;
        unlock = 0;
        error_count = 0;
        
        // Apply reset
        #10 rst = 1;
        #10 rst = 0;
        
        // Test case 1: Correct password on first attempt
        #10 pass = 4'b1010; unlock = 1;
        #10 unlock = 0;
        #10 if (open !== 1'b1 || error !== 1'b0) begin
            $display("Error: Test case 1 failed. Input pass=%b, unlock=%b. Output open=%b, error=%b. Expected open=1, error=0", 
                    4'b1010, 1'b1, open, error);
            error_count = error_count + 1;
        end
        
        // Test case 2: Incorrect password once then correct
        #10 pass = 4'b1111; unlock = 1;
        #10 unlock = 0;
        #10 if (open !== 1'b0 || error !== 1'b0) begin
            $display("Error: Test case 2a failed. Input pass=%b, unlock=%b. Output open=%b, error=%b. Expected open=0, error=0", 
                    4'b1111, 1'b1, open, error);
            error_count = error_count + 1;
        end
        
        #10 pass = 4'b1010; unlock = 1;
        #10 unlock = 0;
        #10 if (open !== 1'b1 || error !== 1'b0) begin
            $display("Error: Test case 2b failed. Input pass=%b, unlock=%b. Output open=%b, error=%b. Expected open=1, error=0", 
                    4'b1010, 1'b1, open, error);
            error_count = error_count + 1;
        end
        
        // Test case 3: Three incorrect attempts
        #10 pass = 4'b0001; unlock = 1;
        #10 unlock = 0;
        #10 if (open !== 1'b0 || error !== 1'b0) begin
            $display("Error: Test case 3a failed. Input pass=%b, unlock=%b. Output open=%b, error=%b. Expected open=0, error=0", 
                    4'b0001, 1'b1, open, error);
            error_count = error_count + 1;
        end
        
        #10 pass = 4'b0010; unlock = 1;
        #10 unlock = 0;
        #10 if (open !== 1'b0 || error !== 1'b0) begin
            $display("Error: Test case 3b failed. Input pass=%b, unlock=%b. Output open=%b, error=%b. Expected open=0, error=0", 
                    4'b0010, 1'b1, open, error);
            error_count = error_count + 1;
        end
        
        #10 pass = 4'b0100; unlock = 1;
        #10 unlock = 0;
        #10 if (open !== 1'b0 || error !== 1'b1) begin
            $display("Error: Test case 3c failed. Input pass=%b, unlock=%b. Output open=%b, error=%b. Expected open=0, error=1", 
                    4'b0100, 1'b1, open, error);
            error_count = error_count + 1;
        end
        
        // Test case 4: Correct password after reset
        #10 rst = 1;
        #10 rst = 0;
        #10 pass = 4'b1010; unlock = 1;
        #10 unlock = 0;
        #10 if (open !== 1'b1 || error !== 1'b0) begin
            $display("Error: Test case 4 failed. Input pass=%b, unlock=%b. Output open=%b, error=%b. Expected open=1, error=0", 
                    4'b1010, 1'b1, open, error);
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