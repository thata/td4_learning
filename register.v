module register(
  input clk,
  input reset,
  input load,
  input [3:0] d,
  output [3:0] q);

  wire [3:0] in0, out0;

  flopr f0 (clk, reset, in0, out0);

  assign in0 = (load == 1) ? d : out0;
  assign q = out0;
endmodule
