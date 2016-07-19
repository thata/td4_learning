module counter(
  input clk,
  input reset,
  input load,
  input [3:0] d,
  output [3:0] q);

  wire [3:0] in0;
  wire [3:0] out0, out1;
  wire co;

  flopr f0 (clk, reset, in0, out0);
  adder4 a0 (out0, 4'b0001, out1, co);

  assign in0 = (load == 1) ? d : out1;
  assign q = out0;
endmodule
