
module Prob029_m2014_q4g_ref (
  input in1,
  input in2,
  input in3,
  output logic out
);

  assign out = (~(in1 ^ in2)) ^ in3;

endmodule

