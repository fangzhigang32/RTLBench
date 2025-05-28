`timescale 1ns/1ps

module tb_handshake;

// Inputs
reg clk;
reg rst;
reg req;
reg [7:0] din;

// Outputs
wire ack;
wire [7:0] dout;

// Instantiate the Unit Under Test (UUT)
handshake uut (
    .clk(clk),
    .rst(rst),
    .req(req),
    .din(din),
    .ack(ack),
    .dout(dout)
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
    req = 0;
    din = 8'h00;
    
    // Wait for global reset
    #20;
    rst = 0;
    
    // Test case 1: No request
    #10;
    if (ack !== 1'b0 || dout !== 8'h00) begin
        $display("Error case 1: Input(req=%b, din=%h), Output(ack=%b, dout=%h), Expected(ack=0, dout=00)", req, din, ack, dout);
        error_count = error_count + 1;
    end
    
    // Test case 2: Single request
    req = 1;
    din = 8'hAA;
    #10;
    if (ack !== 1'b1 || dout !== 8'hAA) begin
        $display("Error case 2: Input(req=%b, din=%h), Output(ack=%b, dout=%h), Expected(ack=1, dout=AA)", req, din, ack, dout);
        error_count = error_count + 1;
    end
    
    // Test case 3: Request released
    req = 0;
    #10;
    if (ack !== 1'b0 || dout !== 8'hAA) begin
        $display("Error case 3: Input(req=%b, din=%h), Output(ack=%b, dout=%h), Expected(ack=0, dout=AA)", req, din, ack, dout);
        error_count = error_count + 1;
    end
    
    // Test case 4: New request
    req = 1;
    din = 8'h55;
    #10;
    if (ack !== 1'b1 || dout !== 8'h55) begin
        $display("Error case 4: Input(req=%b, din=%h), Output(ack=%b, dout=%h), Expected(ack=1, dout=55)", req, din, ack, dout);
        error_count = error_count + 1;
    end
    
    // Test case 5: Reset during operation
    rst = 1;
    #10;
    if (ack !== 1'b0 || dout !== 8'h00) begin
        $display("Error case 5: Input(req=%b, din=%h), Output(ack=%b, dout=%h), Expected(ack=0, dout=00)", req, din, ack, dout);
        error_count = error_count + 1;
    end
    
    // Finish simulation
    #10;
    if (error_count == 0) begin
        $display("No Function Error");
    end
    else begin
        $display("Exist Function Error");
    end
    $finish;
end

endmodule