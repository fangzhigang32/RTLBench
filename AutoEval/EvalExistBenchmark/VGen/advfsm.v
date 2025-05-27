module advfsm(
input clk,
input reset,
input x,
output z ); 
reg [1:0] present_state, next_state;
parameter IDLE=0, S1=1, S10=2, S101=3;

    assign z = present_state == S101 ? 1 : 0;

    always @ (posedge clk) begin
        if (reset)
        present_state <= IDLE;
        else
        present_state <= next_state;
    end

    always @ (present_state or x) begin
        case (present_state)
        IDLE : begin
        if (x) next_state = S1;
        else next_state = IDLE;
        end
        S1: begin
        if (x) next_state = IDLE;
        else next_state = S10;
        end
        S10 : begin
        if (x) next_state = S101;
        else next_state = IDLE;
        end
        S101: begin
        next_state = IDLE;
        end
        endcase
    end

endmodule