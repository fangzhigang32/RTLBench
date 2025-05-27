`timescale 1ns/1ps

module tb_subway_ticket_controller;

    // Inputs
    reg clk;
    reg rst;
    reg [1:0] ticket;
    reg [1:0] coin;

    // Outputs
    wire gate;
    wire change;

    // Instantiate the Unit Under Test (UUT)
    subway_ticket_controller uut (
        .clk(clk),
        .rst(rst),
        .ticket(ticket),
        .coin(coin),
        .gate(gate),
        .change(change)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    reg error_flag = 0;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        ticket = 0;
        coin = 0;

        // Reset the system
        #10;
        rst = 0;
        #10;

        // Test Case 1: Ticket 1 (value 1) with exact coin
        ticket = 2'b00; // Ticket value = 1
        coin = 2'b01;   // Coin value = 1
        #10;
        if (gate !== 1'b1 || change !== 1'b0) begin
            $display("Error Case 1: Input(ticket=%b, coin=%b), Output(gate=%b, change=%b), Expected(gate=1, change=0)", 
                    ticket, coin, gate, change);
            error_flag = 1;
        end

        // Test Case 2: Ticket 2 (value 2) with insufficient coins
        ticket = 2'b01; // Ticket value = 2
        coin = 2'b01;   // Coin value = 1
        #10;
        if (gate !== 1'b0 || change !== 1'b0) begin
            $display("Error Case 2: Input(ticket=%b, coin=%b), Output(gate=%b, change=%b), Expected(gate=0, change=0)", 
                    ticket, coin, gate, change);
            error_flag = 1;
        end
        coin = 2'b01;   // Second coin value = 1 (total = 2)
        #10;
        if (gate !== 1'b1 || change !== 1'b0) begin
            $display("Error Case 2: Input(ticket=%b, coin=%b), Output(gate=%b, change=%b), Expected(gate=1, change=0)", 
                    ticket, coin, gate, change);
            error_flag = 1;
        end

        // Test Case 3: Ticket 3 (value 3) with overpayment
        ticket = 2'b10; // Ticket value = 3
        coin = 2'b10;   // Coin value = 2
        #10;
        coin = 2'b10;   // Second coin value = 2 (total = 4)
        #10;
        if (gate !== 1'b1 || change !== 1'b1) begin
            $display("Error Case 3: Input(ticket=%b, coin=%b), Output(gate=%b, change=%b), Expected(gate=1, change=1)", 
                    ticket, coin, gate, change);
            error_flag = 1;
        end

        // Test Case 4: Reset test
        rst = 1;
        #10;
        if (gate !== 1'b0 || change !== 1'b0) begin
            $display("Error Case 4: Input(rst=1), Output(gate=%b, change=%b), Expected(gate=0, change=0)", 
                    gate, change);
            error_flag = 1;
        end

        // Test Case 5: Invalid coin input
        rst = 0;
        ticket = 2'b00; // Ticket value = 1
        coin = 2'b11;   // Invalid coin
        #10;
        if (gate !== 1'b0 || change !== 1'b0) begin
            $display("Error Case 5: Input(ticket=%b, coin=%b), Output(gate=%b, change=%b), Expected(gate=0, change=0)", 
                    ticket, coin, gate, change);
            error_flag = 1;
        end

        if (error_flag) begin
            $display("Exist Function Error");
        end else begin
            $display("No Function Error");
        end

        $finish;
    end

endmodule