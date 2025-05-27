
module Prob025_reduction_ref (
  input [7:0] in,
  output parity
);

  assign parity = ^in;

endmodule

