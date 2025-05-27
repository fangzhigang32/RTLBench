`timescale 1ns/1ps

module tb_full_adder;

    // Inputs
    reg a;
    reg b;
    reg cin;

    // Outputs
    wire s;
    wire cout;

    // Instantiate the Unit Under Test (UUT)
    full_adder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );

    reg error_flag;

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        cin = 0;
        error_flag = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Test case 1: 0 + 0 + 0
        a = 0; b = 0; cin = 0;
        #10;
        if (s !== 0 || cout !== 0) begin
            $display("Error: Case 1 - Input: a=%b, b=%b, cin=%b | Output: s=%b, cout=%b | Expected: s=0, cout=0", a, b, cin, s, cout);
            error_flag = 1;
        end

        // Test case 2: 0 + 0 + 1
        a = 0; b = 0; cin = 1;
        #10;
        if (s !== 1 || cout !== 0) begin
            $display("Error: Case 2 - Input: a=%b, b=%b, cin=%b | Output: s=%b, cout=%b | Expected: s=1, cout=0", a, b, cin, s, cout);
            error_flag = 1;
        end

        // Test case 3: 0 + 1 + 0
        a = 0; b = 1; cin = 0;
        #10;
        if (s !== 1 || cout !== 0) begin
            $display("Error: Case 3 - Input: a=%b, b=%b, cin=%b | Output: s=%b, cout=%b | Expected: s=1, cout=0", a, b, cin, s, cout);
            error_flag = 1;
        end

        // Test case 4: 0 + 1 + 1
        a = 0; b = 1; cin = 1;
        #10;
        if (s !== 0 || cout !== 1) begin
            $display("Error: Case 4 - Input: a=%b, b=%b, cin=%b | Output: s=%b, cout=%b | Expected: s=0, cout=1", a, b, cin, s, cout);
            error_flag = 1;
        end

        // Test case 5: 1 + 0 + 0
        a = 1; b = 0; cin = 0;
        #10;
        if (s !== 1 || cout !== 0) begin
            $display("Error: Case 5 - Input: a=%b, b=%b, cin=%b | Output: s=%b, cout=%b | Expected: s=1, cout=0", a, b, cin, s, cout);
            error_flag = 1;
        end

        // Test case 6: 1 + 0 + 1
        a = 1; b = 0; cin = 1;
        #10;
        if (s !== 0 || cout !== 1) begin
            $display("Error: Case 6 - Input: a=%b, b=%b, cin=%b | Output: s=%b, cout=%b | Expected: s=0, cout=1", a, b, cin, s, cout);
            error_flag = 1;
        end

        // Test case 7: 1 + 1 + 0
        a = 1; b = 1; cin = 0;
        #10;
        if (s !== 0 || cout !== 1) begin
            $display("Error: Case 7 - Input: a=%b, b=%b, cin=%b | Output: s=%b, cout=%b | Expected: s=0, cout=1", a, b, cin, s, cout);
            error_flag = 1;
        end

        // Test case 8: 1 + 1 + 1
        a = 1; b = 1; cin = 1;
        #10;
        if (s !== 1 || cout !== 1) begin
            $display("Error: Case 8 - Input: a=%b, b=%b, cin=%b | Output: s=%b, cout=%b | Expected: s=1, cout=1", a, b, cin, s, cout);
            error_flag = 1;
        end

        // Final result
        if (error_flag == 0) begin
            $display("No Function Error");
        end
        else begin
            $display("Exist Function Error");
        end

        $finish;
    end

endmodule