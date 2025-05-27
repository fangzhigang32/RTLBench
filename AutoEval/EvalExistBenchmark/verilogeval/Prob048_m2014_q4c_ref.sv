
module Prob048_m2014_q4c_ref (
  input clk,
  input d,
  input r,
  output logic q
);

  always@(posedge clk) begin
    if (r)
      q <= 0;
    else
      q <= d;
  end

endmodule

