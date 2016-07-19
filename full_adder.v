module full_adder(
  input a, b, ci,
  output s, co);

  wire s0, c0, c1;

  half_adder h0 (a, b, s0, c0);
  half_adder h1 (s0, ci, s, c1);
  assign co = c0 | c1;
endmodule
