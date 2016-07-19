module cpu0_test();
  reg clk, reset;
  wire q;

  cpu0 dut (clk, reset, q);

  always
    #5 clk = !clk;

  initial begin
    $monitor("%t: clk = %b, reset = %b, q = %b", $time, clk, reset, q);

    clk = 0; reset = 0; #10;

    // フリップフロップをリセット
    reset = 1; #10;
    reset = 0; #10;
  end

  initial
    #1000 $finish;

endmodule
