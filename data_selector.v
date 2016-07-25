module data_selector(
  input [3:0] c0, c1, c2, c3,
  input select_a, select_b,
  output reg [3:0] y
);

  always @(*)
    if (select_a == 1'b1 && select_b == 1'b1) y = c3;
    else if (select_a == 1'b0 && select_b == 1'b1) y = c2;
    else if (select_a == 1'b1 && select_b == 1'b0) y = c1;
    else y <= c0;
endmodule
