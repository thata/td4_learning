# 1bit flip flop
module flipflop(
  input clk, reset, d,
  output reg q);

  always @ (posedge clk, posedge reset)
    if (reset)
      q <= 1'b0;
    else
      q <= d;
endmodule

# 1bit CPU
module cpu0(
  input clk, reset,
  output q);

  wire in, out;

  flipflop ff (clk, reset, in, out);
  assign in = ! out;
  assign q = out;

endmodule
