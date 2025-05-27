
module Prob022_mux2to1_ref (
  input a,
  input b,
  input sel,
  output out
);

  assign out = sel ? b : a;

endmodule

