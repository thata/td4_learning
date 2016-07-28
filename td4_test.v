module td4_test();
  reg clk, reset;
  wire [3:0] rom_adr;
  wire [7:0] rom_data;
  reg [3:0] in_port;
  wire [3:0] out_port;

  td4 cpu0 (clk, reset, rom_adr, rom_data, in_port, out_port);
  td4_rom rom0 (rom_adr, rom_data);

  always
    #5 clk = !clk;

  initial
    // 400単位時間後にfinish
    #400 $finish;

  initial begin
    // 出力ポートをモニタする
    // $monitor("out_port = %b", out_port);

    // init clock
    clk = 0;

    // reset cpu
    reset = 1; #10;
    reset = 0; #10;

    // in_port へ 0101 をセット
    in_port = 4'b0101;
  end
endmodule

module td4_rom(
  input [3:0] adr,
  output reg [7:0] dout);

  always @ (adr)
    // ROMの中身
    case (adr)
      4'b0000: dout <= 8'b00111111; // MOV A, 1111
      4'b0001: dout <= 8'b01000000; // MOV B, A
      4'b0010: dout <= 8'b00110000; // MOV A, 0000
      4'b0011: dout <= 8'b01110000; // MOV B, 0000
      4'b0100: dout <= 8'b00000000;
      4'b0101: dout <= 8'b00000000;
      4'b0110: dout <= 8'b00000000;
      4'b0111: dout <= 8'b00000000;
      4'b1000: dout <= 8'b00000000;
      4'b1001: dout <= 8'b00000000;
      4'b1010: dout <= 8'b00000000;
      4'b1011: dout <= 8'b00000000;
      4'b1100: dout <= 8'b00000000;
      4'b1101: dout <= 8'b00000000;
      4'b1110: dout <= 8'b00000000;
      4'b1111: dout <= 8'b00000000;
/*
      4'b0000: dout <= 8'b00000001; // ADD A, 1
      4'b0001: dout <= 8'b11100000; // JNC 0000
      4'b0010: dout <= 8'b01010001; // ADD B, 1
      4'b0011: dout <= 8'b11110000; // JMP 0000
      4'b0100: dout <= 8'b00000000;
      4'b0101: dout <= 8'b00000000;
      4'b0110: dout <= 8'b00000000;
      4'b0111: dout <= 8'b00000000;
      4'b1000: dout <= 8'b00000000;
      4'b1001: dout <= 8'b00000000;
      4'b1010: dout <= 8'b00000000;
      4'b1011: dout <= 8'b00000000;
      4'b1100: dout <= 8'b00000000;
      4'b1101: dout <= 8'b00000000;
      4'b1110: dout <= 8'b00000000;
      4'b1111: dout <= 8'b00000000;
*/
    endcase
endmodule
