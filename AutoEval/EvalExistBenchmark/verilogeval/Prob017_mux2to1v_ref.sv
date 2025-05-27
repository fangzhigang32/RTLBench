
module Prob017_mux2to1v_ref (
  input [99:0] a,
  input [99:0] b,
  input sel,
  output [99:0] out
);

  assign out = sel ? b : a;

endmodule

