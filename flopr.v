// Resettable Register
module flopr(
  input clk,
  input reset,
  input [3:0] d,
  output reg [3:0] q);

  always @ (posedge clk, posedge reset)
    if (reset)
      q <= 4'b0000;
    else
      q <= d;
endmodule
