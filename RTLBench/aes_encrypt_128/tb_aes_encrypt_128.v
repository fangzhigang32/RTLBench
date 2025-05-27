`timescale 1ns/1ps

module tb_aes_encrypt_128();
    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [127:0] p;
    reg [127:0] k;

    // Outputs
    wire [127:0] c;
    wire done;

    // Instantiate the Unit Under Test (UUT)
    aes_encrypt_128 uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .p(p),
        .k(k),
        .c(c),
        .done(done)
    );

    // Clock generation
    parameter CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) clk = ~clk;

    // Test vectors
    reg [127:0] test_plaintext [0:2];
    reg [127:0] test_key [0:2];
    reg [127:0] expected_ciphertext [0:2];

    integer i, cycle_count, timeout;
    integer error_count = 0;

    initial begin
        // Initialize test vectors
        // Test case 1: NIST FIPS-197 example
        test_plaintext[0] = 128'h00112233445566778899aabbccddeeff;
        test_key[0] = 128'h000102030405060708090a0b0c0d0e0f;
        expected_ciphertext[0] = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
        
        // Test case 2: Another test vector
        test_plaintext[1] = 128'h3243f6a8885a308d313198a2e0370734;
        test_key[1] = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        expected_ciphertext[1] = 128'h3925841d02dc09fbdc118597196a0b32;
        
        // Test case 3: Zero inputs
        test_plaintext[2] = 128'h0;
        test_key[2] = 128'h0;
        expected_ciphertext[2] = 128'h66e94bd4ef8a2c3b884cfa59ca342b2e; // Correct ciphertext for zero inputs

        // Initialize inputs
        clk = 0;
        rst = 1;
        start = 0;
        p = 0;
        k = 0;
        cycle_count = 0;
        timeout = 0;

        // Reset the system
        #(2*CLK_PERIOD);
        rst = 0;
        #(CLK_PERIOD);
        if (c !== 128'b0 || done !== 1'b0) begin
            $display("Reset failed: c = %h, done = %b", c, done);
            error_count = error_count + 1;
        end

        // Run tests
        for (i = 0; i < 3; i = i + 1) begin
            // Load inputs
            p = test_plaintext[i];
            k = test_key[i];
            start = 1;
            cycle_count = 0;
            timeout = 0;

            #(CLK_PERIOD);
            start = 0;

            // Wait for completion or timeout
            while (!done && timeout < 20) begin
                @(posedge clk);
                timeout = timeout + 1;
                cycle_count = cycle_count + 1;
            end

            if (timeout >= 20) begin
                $display("Test %0d failed: Timeout waiting for done", i+1);
                $display("Input plaintext: %h", p);
                $display("Input key: %h", k);
                error_count = error_count + 1;
            end
            else begin
                @(posedge clk); // Check outputs on next clock edge
                if (c !== expected_ciphertext[i]) begin
                    $display("Test %0d failed", i+1);
                    $display("Input plaintext: %h", p);
                    $display("Input key: %h", k);
                    $display("Output ciphertext: %h", c);
                    $display("Expected ciphertext: %h", expected_ciphertext[i]);
                    error_count = error_count + 1;
                end
                if (cycle_count > 10)
                    $display("Test %0d warning: Encryption took %0d cycles, expected <= 10", i+1, cycle_count);
            end

            // Check done persistence
            repeat(5) @(posedge clk) begin
                if (done && !start && !rst)
                    if (!done) begin
                        $display("Test %0d failed: done deasserted prematurely", i+1);
                        error_count = error_count + 1;
                    end
            end

            // Reset for next test
            rst = 1;
            #(CLK_PERIOD);
            rst = 0;
            #(CLK_PERIOD);
        end

        // Final status
        if (error_count == 0)
            $display("No Function Error");
        else
            $display("Exist Function Error");

        $finish;
    end
endmodule