
module Prob012_xnorgate_ref (
  input a,
  input b,
  output out
);

  assign out = ~(a^b);

endmodule

