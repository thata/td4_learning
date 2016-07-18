module flopr_test;
  reg clk, reset;
  reg [3:0] d;
  wire [3:0] q;

  flopr dut (clk, reset, d, q);

  initial begin
    // シミュレータ実行時の変数の値をモニタする（値が変わると出力される）
    $monitor("%t: clk = %b, reset = %b, d = %b, q = %b", $time, clk, reset, d, q);

    // クロックを0にセット
    clk = 0;

    // 非同期でリセットされること
    reset = 1; #10;
    if (q !== 4'b0) $display("failed.");

    // リセットをLOWに戻す
    reset = 0; #10;

    // クロックの立ち上がりで入力値がセットされること
    d = 4'b0001; clk = 1; #10;
    if (q !== 4'b0001) $display("failed.");
  end
endmodule
