module simple-fsm(input clk, input reset, input in, output out);
reg present_state, next_state;
    always @(posedge clk) begin
        if (reset) begin  
            present_state <= 0;
        end 
        else begin
            // State flip-flops
            present_state <= next_state;  
        end

    end

    always @(present_state,in) begin
        case (present_state)
        // next state logic
        0: begin
            if(in) next_state <= 0;
            else next_state <= 1;
        end
        1: begin
            if(in) next_state <= 1;
            else next_state <= 0;
        end
        endcase 

    end

    // output logic
    assign out = present_state?0:1;

endmodule