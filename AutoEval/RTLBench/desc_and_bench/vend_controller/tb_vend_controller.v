`timescale 1ns/1ps

module tb_vend_controller;

// Inputs
reg clk;
reg rst;
reg [1:0] coin;
reg [1:0] item_sel;

// Outputs
wire dispense;
wire [1:0] change;

// Instantiate the Unit Under Test (UUT)
vend_controller uut (
    .clk(clk),
    .rst(rst),
    .coin(coin),
    .item_sel(item_sel),
    .dispense(dispense),
    .change(change)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize Inputs
    rst = 1;
    coin = 2'b00;
    item_sel = 2'b00;
    
    // Reset the system
    #10;
    rst = 0;
    
    // Test Case 1: Simple purchase of item 0 (price 3)
    // Insert 2 coins of value 1 and 2
    #10;
    coin = 2'b01; // Insert 1
    #10;
    coin = 2'b00;
    #10;
    coin = 2'b10; // Insert 2
    #10;
    coin = 2'b00;
    item_sel = 2'b00; // Select item 0
    #20;
    if (dispense !== 1'b1 || change !== 2'b00) begin
        $display("Test Case 1 Failed: Inputs: coin=%b, item_sel=%b | Output: dispense=%b, change=%b | Expected: dispense=1, change=0", 
                coin, item_sel, dispense, change);
    end
    
    // Test Case 2: Purchase with change
    #10;
    coin = 2'b10; // Insert 2
    #10;
    coin = 2'b10; // Insert 2
    #10;
    coin = 2'b00;
    item_sel = 2'b00; // Select item 0 (price 3)
    #20;
    if (dispense !== 1'b1 || change !== 2'b01) begin
        $display("Test Case 2 Failed: Inputs: coin=%b, item_sel=%b | Output: dispense=%b, change=%b | Expected: dispense=1, change=1", 
                coin, item_sel, dispense, change);
    end
    
    // Test Case 3: Insufficient funds
    #10;
    coin = 2'b01; // Insert 1
    #10;
    coin = 2'b00;
    item_sel = 2'b01; // Select item 1 (price 5)
    #20;
    if (dispense !== 1'b0) begin
        $display("Test Case 3 Failed: Inputs: coin=%b, item_sel=%b | Output: dispense=%b | Expected: dispense=0", 
                coin, item_sel, dispense);
    end
    
    // Test Case 4: Reset during operation
    #10;
    coin = 2'b10; // Insert 2
    #5;
    rst = 1;
    #5;
    if (dispense !== 1'b0 || change !== 2'b00) begin
        $display("Test Case 4 Failed: After reset | Output: dispense=%b, change=%b | Expected: dispense=0, change=0", 
                dispense, change);
    end
    
    // Test Case 5: No item selected
    #10;
    rst = 0;
    coin = 2'b10; // Insert 2
    #10;
    coin = 2'b10; // Insert 2
    #10;
    coin = 2'b00;
    item_sel = 2'b11; // Invalid selection
    #20;
    if (dispense !== 1'b0) begin
        $display("Test Case 5 Failed: Inputs: coin=%b, item_sel=%b | Output: dispense=%b | Expected: dispense=0", 
                coin, item_sel, dispense);
    end
    
    // Final status check
    if ($countones({dispense, change}) == 0) begin
        $display("No Function Error");
    end
    else begin
        $display("Exist Function Error");
    end
    
    $finish;
end

endmodule