
module Prob011_norgate_ref (
  input a,
  input b,
  output out
);

  assign out = ~(a | b);

endmodule

