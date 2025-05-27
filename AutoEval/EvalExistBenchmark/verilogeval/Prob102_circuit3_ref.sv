
module Prob102_circuit3_ref (
  input a,
  input b,
  input c,
  input d,
  output q
);

  assign q = (a|b) & (c|d);

endmodule

