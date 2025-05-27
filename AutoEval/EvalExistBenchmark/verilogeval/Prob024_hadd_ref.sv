
module Prob024_hadd_ref (
  input a,
  input b,
  output sum,
  output cout
);

  assign {cout, sum} = a+b;

endmodule

