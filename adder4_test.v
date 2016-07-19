module adder4_test();
  reg [3:0] a;
  reg [3:0] b;
  wire [3:0] s;
  wire c;

  adder4 dut (a, b, s, c);

  initial begin
    $monitor("%t: a = %b, b = %b, s = %b, c = %b", $time, a, b, s, c);

    a = 4'b0000; b = 4'b0000; #10;
    if (s != 4'b0000) $display("failed.");
    if (c != 1'b0) $display("failed.");

    a = 4'b0001; b = 4'b0000; #10;
    if (s != 4'b0001) $display("failed.");
    if (c != 1'b0) $display("failed.");

    a = 4'b0000; b = 4'b0001; #10;
    if (s != 4'b0001) $display("failed.");
    if (c != 1'b0) $display("failed.");

    a = 4'b0001; b = 4'b0001; #10;
    if (s != 4'b0010) $display("failed.");
    if (c != 1'b0) $display("failed.");

    a = 4'b1111; b = 4'b0001; #10;
    if (s != 4'b0000) $display("failed.");
    if (c != 1'b1) $display("failed.");

    a = 4'b1111; b = 4'b0010; #10;
    if (s != 4'b0001) $display("failed.");
    if (c != 1'b1) $display("failed.");
  end
endmodule
