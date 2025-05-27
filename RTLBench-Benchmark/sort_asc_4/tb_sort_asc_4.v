`timescale 1ns/1ps

module tb_sort_asc_4;

// Inputs
reg [3:0] a, b, c, d;

// Outputs
wire [3:0] ra, rb, rc, rd;

// Instantiate the Unit Under Test (UUT)
sort_asc_4 uut (
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .ra(ra),
    .rb(rb),
    .rc(rc),
    .rd(rd)
);

integer i;
reg [3:0] expected [0:3];
reg error_flag;
reg [3:0] temp;  // Moved temp declaration to module level

initial begin
    error_flag = 0;
    
    // Test case 1: Random values
    a = 4'd5; b = 4'd2; c = 4'd7; d = 4'd3;
    expected[0] = 4'd2; expected[1] = 4'd3; expected[2] = 4'd5; expected[3] = 4'd7;
    #10;
    if (ra !== expected[0] || rb !== expected[1] || rc !== expected[2] || rd !== expected[3]) begin
        $display("Error Case 1: Inputs %0d,%0d,%0d,%0d", a, b, c, d);
        $display("Expected: %0d,%0d,%0d,%0d", expected[0], expected[1], expected[2], expected[3]);
        $display("Got: %0d,%0d,%0d,%0d", ra, rb, rc, rd);
        error_flag = 1;
    end

    // Test case 2: Already sorted
    a = 4'd1; b = 4'd2; c = 4'd3; d = 4'd4;
    expected[0] = 4'd1; expected[1] = 4'd2; expected[2] = 4'd3; expected[3] = 4'd4;
    #10;
    if (ra !== expected[0] || rb !== expected[1] || rc !== expected[2] || rd !== expected[3]) begin
        $display("Error Case 2: Inputs %0d,%0d,%0d,%0d", a, b, c, d);
        $display("Expected: %0d,%0d,%0d,%0d", expected[0], expected[1], expected[2], expected[3]);
        $display("Got: %0d,%0d,%0d,%0d", ra, rb, rc, rd);
        error_flag = 1;
    end

    // Test case 3: Reverse order
    a = 4'd9; b = 4'd6; c = 4'd4; d = 4'd1;
    expected[0] = 4'd1; expected[1] = 4'd4; expected[2] = 4'd6; expected[3] = 4'd9;
    #10;
    if (ra !== expected[0] || rb !== expected[1] || rc !== expected[2] || rd !== expected[3]) begin
        $display("Error Case 3: Inputs %0d,%0d,%0d,%0d", a, b, c, d);
        $display("Expected: %0d,%0d,%0d,%0d", expected[0], expected[1], expected[2], expected[3]);
        $display("Got: %0d,%0d,%0d,%0d", ra, rb, rc, rd);
        error_flag = 1;
    end

    // Test case 4: All equal values
    a = 4'd5; b = 4'd5; c = 4'd5; d = 4'd5;
    expected[0] = 4'd5; expected[1] = 4'd5; expected[2] = 4'd5; expected[3] = 4'd5;
    #10;
    if (ra !== expected[0] || rb !== expected[1] || rc !== expected[2] || rd !== expected[3]) begin
        $display("Error Case 4: Inputs %0d,%0d,%0d,%0d", a, b, c, d);
        $display("Expected: %0d,%0d,%0d,%0d", expected[0], expected[1], expected[2], expected[3]);
        $display("Got: %0d,%0d,%0d,%0d", ra, rb, rc, rd);
        error_flag = 1;
    end

    // Test case 5: Random test with 10 iterations
    for (i = 0; i < 10; i = i + 1) begin
        a = $random % 16;
        b = $random % 16;
        c = $random % 16;
        d = $random % 16;
        
        // Calculate expected output using simple sorting algorithm
        expected[0] = (a <= b && a <= c && a <= d) ? a :
                     (b <= a && b <= c && b <= d) ? b :
                     (c <= a && c <= b && c <= d) ? c : d;
        expected[3] = (a >= b && a >= c && a >= d) ? a :
                     (b >= a && b >= c && b >= d) ? b :
                     (c >= a && c >= b && c >= d) ? c : d;
        
        // Calculate middle values
        if (a != expected[0] && a != expected[3]) begin
            expected[1] = a;
            if (b != expected[0] && b != expected[3]) expected[2] = b;
            else if (c != expected[0] && c != expected[3]) expected[2] = c;
            else expected[2] = d;
        end
        else if (b != expected[0] && b != expected[3]) begin
            expected[1] = b;
            if (a != expected[0] && a != expected[3]) expected[2] = a;
            else if (c != expected[0] && c != expected[3]) expected[2] = c;
            else expected[2] = d;
        end
        else begin
            expected[1] = c;
            expected[2] = d;
        end
        
        // Ensure proper ordering of middle values
        if (expected[1] > expected[2]) begin
            temp = expected[1];
            expected[1] = expected[2];
            expected[2] = temp;
        end
        
        #10;
        if (ra !== expected[0] || rb !== expected[1] || rc !== expected[2] || rd !== expected[3]) begin
            $display("Error Case 5.%0d: Inputs %0d,%0d,%0d,%0d", i, a, b, c, d);
            $display("Expected: %0d,%0d,%0d,%0d", expected[0], expected[1], expected[2], expected[3]);
            $display("Got: %0d,%0d,%0d,%0d", ra, rb, rc, rd);
            error_flag = 1;
        end
    end
    
    if (error_flag) begin
        $display("Exist Function Error");
    end else begin
        $display("No Function Error");
    end
    
    $finish;
end

endmodule