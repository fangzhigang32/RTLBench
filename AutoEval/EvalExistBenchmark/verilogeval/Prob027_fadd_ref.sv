
module Prob027_fadd_ref (
  input a,
  input b,
  input cin,
  output cout,
  output sum
);

  assign {cout, sum} = a+b+cin;

endmodule

