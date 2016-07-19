module counter_test();
  reg clk, reset, load;
  reg [3:0] d;
  wire [3:0] q;

  counter c0 (clk, reset, load, d, q);

  initial begin
    $monitor("%t: clk = %b, reset = %b, load = %b, d = %b, q = %b", $time, clk, reset, load, d, q);

    // init registers
    clk = 0; reset = 0; load = 0; d = 4'b0;

    // reset counter
    reset = 1; #10; reset = 0; #10;

    // counter++
    clk = ! clk; #5; clk = ! clk; #5;
    if (q != 4'b0001) $display("failed");

    // counter++
    clk = ! clk; #5; clk = ! clk; #5;
    if (q != 4'b0010) $display("failed");

    // counter++
    clk = ! clk; #5; clk = ! clk; #5;
    if (q != 4'b0011) $display("failed");

    // load data
    d = 4'b1010; load = 1; clk = ! clk; #5;
    load = 0; clk = ! clk; #5;
    if (q != 4'b1010) $display("failed");

    // counter++
    clk = ! clk; #5; clk = ! clk; #5;
    if (q != 4'b1011) $display("failed");
  end
endmodule
