module priority_encoder( 
    input [2:0] in,
    output reg [1:0] pos  );
    
    always @(*) begin
        if (in[0]==1'b1)
            pos = 0;
        else if (in[1]==1'b1)
            pos = 1;
        else if (in[2]==1'b1)
            pos = 2;
        else
            pos = 0;
    end

endmodule