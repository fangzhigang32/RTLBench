`timescale 1ns/1ps

module tb_cla_adder_16bit;

    // Inputs
    reg [15:0] a;
    reg [15:0] b;
    reg cin;
    
    // Outputs
    wire [15:0] s;
    wire cout;
    
    // Expected outputs
    reg [15:0] expected_s;
    reg expected_cout;
    
    // Test statistics
    integer test_count = 0;
    integer pass_count = 0;
    integer error_flag = 0;
    
    // Instantiate the Unit Under Test (UUT)
    cla_adder_16bit uut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );
    
    integer i;
    
    // Check function for each test case
    task check_output;
        input [15:0] test_a, test_b;
        input test_cin;
        input [15:0] exp_s;
        input exp_cout;
        input [31:0] test_num;
        begin
            test_count = test_count + 1;
            if (s === exp_s && cout === exp_cout) begin
                pass_count = pass_count + 1;
            end else begin
                $display("Error in Test Case %0d:", test_num);
                $display("Input: a=%h, b=%h, cin=%b", test_a, test_b, test_cin);
                $display("Output: s=%h, cout=%b", s, cout);
                $display("Expected: s=%h, cout=%b", exp_s, exp_cout);
                error_flag = 1;
            end
        end
    endtask
    
    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        cin = 0;
        test_count = 0;
        pass_count = 0;
        error_flag = 0;
        
        // Test case 0: Zero inputs
        a = 16'h0000;
        b = 16'h0000;
        cin = 0;
        expected_s = 16'h0000;
        expected_cout = 0;
        #10;
        check_output(a, b, cin, expected_s, expected_cout, 0);
        
        // Test case 1: Simple addition without carry
        a = 16'h0001;
        b = 16'h0002;
        cin = 0;
        expected_s = 16'h0003;
        expected_cout = 0;
        #10;
        check_output(a, b, cin, expected_s, expected_cout, 1);
        
        // Test case 2: Addition with carry in
        a = 16'h0001;
        b = 16'h0002;
        cin = 1;
        expected_s = 16'h0004;
        expected_cout = 0;
        #10;
        check_output(a, b, cin, expected_s, expected_cout, 2);
        
        // Test case 3: Addition with carry out
        a = 16'hFFFF;
        b = 16'h0001;
        cin = 0;
        expected_s = 16'h0000;
        expected_cout = 1;
        #10;
        check_output(a, b, cin, expected_s, expected_cout, 3);
        
        // Test case 4: Additional boundary case (both inputs zero, carry in)
        a = 16'h0000;
        b = 16'h0000;
        cin = 1;
        expected_s = 16'h0001;
        expected_cout = 0;
        #10;
        check_output(a, b, cin, expected_s, expected_cout, 4);
        
        // Test case 5: Random addition (increased to 100 iterations)
        for (i = 0; i < 100; i = i + 1) begin
            a = $random;
            b = $random;
            cin = $random % 2;
            {expected_cout, expected_s} = a + b + cin;
            #10;
            check_output(a, b, cin, expected_s, expected_cout, 5 + i);
        end
        
        // Test case 6: Maximum addition
        a = 16'hFFFF;
        b = 16'hFFFF;
        cin = 1;
        expected_s = 16'hFFFF;
        expected_cout = 1;
        #10;
        check_output(a, b, cin, expected_s, expected_cout, 105);
        
        // Final result
        if (error_flag == 0) begin
            $display("No Function Error");
        end else begin
            $display("Exist Function Error");
        end
        
        $finish;
    end

endmodule