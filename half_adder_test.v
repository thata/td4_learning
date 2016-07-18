module half_adder_test();
  reg a, b;
  wire s, c;

  half_adder dut (a, b, s, c);

  initial begin
    $monitor("%t: a = %b, b = %b, s = %b, c = %b", $time, a, b, s, c);

    a = 0; b = 0; #10;
    if (s != 0) $display("failed.");
    if (c != 0) $display("failed.");

    a = 1; b = 0; #10;
    if (s != 1) $display("failed.");
    if (c != 0) $display("failed.");

    a = 0; b = 1; #10;
    if (s != 1) $display("failed.");
    if (c != 0) $display("failed.");

    a = 1; b = 1; #10;
    if (s != 0) $display("failed.");
    if (c != 1) $display("failed.");
  end
endmodule
