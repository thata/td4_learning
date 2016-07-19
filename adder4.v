// 4bit Adder
module adder4(
  input [3:0] a,
  input [3:0] b,
  output [3:0] s,
  output c);

  wire c0, c1, c2;

  full_adder a0 (a[0], b[0], 1'b0, s[0], c0);
  full_adder a1 (a[1], b[1], c0, s[1], c1);
  full_adder a2 (a[2], b[2], c1, s[2], c2);
  full_adder a3 (a[3], b[3], c2, s[3], c);
endmodule
