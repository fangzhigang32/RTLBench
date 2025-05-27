
module Prob018_mux256to1_ref (
  input [255:0] in,
  input [7:0] sel,
  output  out
);

  assign out = in[sel];

endmodule

