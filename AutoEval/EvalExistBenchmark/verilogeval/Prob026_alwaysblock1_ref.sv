
module Prob026_alwaysblock1_ref (
  input a,
  input b,
  output out_assign,
  output reg out_alwaysblock
);

  assign out_assign = a & b;
  always @(*) out_alwaysblock = a & b;

endmodule

