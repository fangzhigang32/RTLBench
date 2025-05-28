`timescale 1ns/1ps

module tb_cnn_accelerator();

// Clock and reset signals
reg clk;
reg rst;
reg start;
wire done;

// Input feature map and weights
reg [7:0] ifm [0:3][0:3];
reg [7:0] w [0:1][0:1];

// Output feature map
wire [7:0] ofm [0:2][0:2];

// Instantiate the DUT
cnn_accelerator dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(done),
    .ifm(ifm),
    .w(w),
    .ofm(ofm)
);

// Clock generation
always #5 clk = ~clk;

// Expected output for verification
reg [7:0] expected_ofm [0:2][0:2];

// Declare loop variables and error counter here (outside initial block)
integer i, j;
integer error_count;

initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    start = 0;
    error_count = 0;
    
    // Initialize input arrays
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            ifm[i][j] = 0;
        end
    end
    
    for (i = 0; i < 2; i = i + 1) begin
        for (j = 0; j < 2; j = j + 1) begin
            w[i][j] = 0;
        end
    end
    
    // Release reset after one clock cycle
    #10 rst = 0;
    #10;
    
    // Test case 1: Simple identity test
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            ifm[i][j] = i * 4 + j;
        end
    end
    
    w[0][0] = 1; w[0][1] = 0;
    w[1][0] = 0; w[1][1] = 1;
    
    for (i = 0; i < 3; i = i + 1) begin
        for (j = 0; j < 3; j = j + 1) begin
            reg [15:0] temp;
            temp = (ifm[i][j] * w[0][0]) + 
                   (ifm[i][j+1] * w[0][1]) + 
                   (ifm[i+1][j] * w[1][0]) + 
                   (ifm[i+1][j+1] * w[1][1]);
            expected_ofm[i][j] = (temp > 255) ? 8'hFF : (temp < 0) ? 8'h00 : temp[7:0];
        end
    end
    
    start = 1;
    #10 start = 0;
    
    wait (done == 1);
    
    for (i = 0; i < 3; i = i + 1) begin
        for (j = 0; j < 3; j = j + 1) begin
            if (ofm[i][j] !== expected_ofm[i][j]) begin
                $display("Test Case 1 Error at [%0d][%0d]: Input=%0d, Expected=%0d, Got=%0d", 
                         i, j, ifm[i][j], expected_ofm[i][j], ofm[i][j]);
                error_count = error_count + 1;
            end
        end
    end
    
    // Test case 2: Edge detection test
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            ifm[i][j] = (i == j) ? 8'hFF : 8'h00;
        end
    end
    
    w[0][0] = -1; w[0][1] = -1;
    w[1][0] = -1; w[1][1] = 8;
    
    for (i = 0; i < 3; i = i + 1) begin
        for (j = 0; j < 3; j = j + 1) begin
            reg [15:0] temp;
            temp = (ifm[i][j] * w[0][0]) + 
                   (ifm[i][j+1] * w[0][1]) + 
                   (ifm[i+1][j] * w[1][0]) + 
                   (ifm[i+1][j+1] * w[1][1]);
            expected_ofm[i][j] = (temp > 255) ? 8'hFF : (temp < 0) ? 8'h00 : temp[7:0];
        end
    end
    
    start = 1;
    #10 start = 0;
    
    wait (done == 1);
    
    for (i = 0; i < 3; i = i + 1) begin
        for (j = 0; j < 3; j = j + 1) begin
            if (ofm[i][j] !== expected_ofm[i][j]) begin
                $display("Test Case 2 Error at [%0d][%0d]: Input=%0d, Expected=%0d, Got=%0d", 
                         i, j, ifm[i][j], expected_ofm[i][j], ofm[i][j]);
                error_count = error_count + 1;
            end
        end
    end
    
    // Test case 3: Boundary value test
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            ifm[i][j] = 8'hFF;
        end
    end
    
    w[0][0] = 1; w[0][1] = 1;
    w[1][0] = 1; w[1][1] = 1;
    
    for (i = 0; i < 3; i = i + 1) begin
        for (j = 0; j < 3; j = j + 1) begin
            reg [15:0] temp;
            temp = (ifm[i][j] * w[0][0]) + 
                   (ifm[i][j+1] * w[0][1]) + 
                   (ifm[i+1][j] * w[1][0]) + 
                   (ifm[i+1][j+1] * w[1][1]);
            expected_ofm[i][j] = (temp > 255) ? 8'hFF : (temp < 0) ? 8'h00 : temp[7:0];
        end
    end
    
    start = 1;
    #10 start = 0;
    
    wait (done == 1);
    
    for (i = 0; i < 3; i = i + 1) begin
        for (j = 0; j < 3; j = j + 1) begin
            if (ofm[i][j] !== expected_ofm[i][j]) begin
                $display("Test Case 3 Error at [%0d][%0d]: Input=%0d, Expected=%0d, Got=%0d", 
                         i, j, ifm[i][j], expected_ofm[i][j], ofm[i][j]);
                error_count = error_count + 1;
            end
        end
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