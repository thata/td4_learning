module full_adder_test();
  reg a, b, ci;
  wire s, co;

  full_adder dut (a, b, ci, s, co);

  initial begin
    $monitor("%t: a = %b, b = %b, ci = %b, s = %b, co = %b", $time, a, b, ci, s, co);

    a = 0; b = 0; ci = 0; #10;
    if (s != 0) $display("failed.");
    if (co != 0) $display("failed.");

    a = 0; b = 1; ci = 0; #10;
    if (s != 1) $display("failed.");
    if (co != 0) $display("failed.");

    a = 1; b = 0; ci = 0; #10;
    if (s != 1) $display("failed.");
    if (co != 0) $display("failed.");

    a = 1; b = 1; ci = 0; #10;
    if (s != 0) $display("failed.");
    if (co != 1) $display("failed.");

    a = 0; b = 0; ci = 1; #10;
    if (s != 1) $display("failed.");
    if (co != 0) $display("failed.");

    a = 1; b = 0; ci = 1; #10;
    if (s != 0) $display("failed.");
    if (co != 1) $display("failed.");

    a = 0; b = 1; ci = 1; #10;
    if (s != 0) $display("failed.");
    if (co != 1) $display("failed.");

    a = 1; b = 1; ci = 1; #10;
    if (s != 1) $display("failed.");
    if (co != 1) $display("failed.");
  end
endmodule
