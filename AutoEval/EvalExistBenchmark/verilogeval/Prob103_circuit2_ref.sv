
module Prob103_circuit2_ref (
  input a,
  input b,
  input c,
  input d,
  output q
);

  assign q = ~a^b^c^d;

endmodule

