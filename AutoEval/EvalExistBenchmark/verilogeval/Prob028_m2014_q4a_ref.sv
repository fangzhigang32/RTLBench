
module Prob028_m2014_q4a_ref (
  input d,
  input ena,
  output logic q
);

  always@(*) begin
    if (ena)
      q = d;
  end

endmodule

