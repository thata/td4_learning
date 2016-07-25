module rom_sample_test();
  reg [3:0] adr;
  wire [7:0] dout;

  rom_sample rom0 (adr, dout);

  initial begin
    $monitor("%t: adr = %b, dout = %b", $time, adr, dout);

    // ROM がそれっぽく動くことを確認
    // ROM の中身は任意に変更可能なので、値の検証は行わない。
    adr = 4'b0000; #10;
    adr = 4'b0001; #10;
    adr = 4'b0010; #10;
    adr = 4'b1111; #10;
  end
endmodule
