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

module td4(
  input clk, reset,
  output [3:0] adr,
  input [7:0] instr,
  input [3:0] in_port,
  output [3:0] out_port
);

  wire [3:0] pcf; // PCの出力
  wire [3:0] im;
  wire [3:0] alu_out;
  wire alu_co, m_alu_co;
  wire [3:0] reg_a_data, reg_b_data;
  wire [3:0] selector_out;
  wire op0, op1, op2, op3;
  wire select_a, select_b;
  wire load0, load1, load2, load3;

  register reg_a (clk, reset, load0, alu_out, reg_a_data);
  register reg_b (clk, reset, load1, alu_out, reg_b_data);
  register reg_c (clk, reset, load2, alu_out, out_port);
  data_selector selector0 (reg_a_data, reg_b_data, in_port, 4'b0000, select_a, select_b, selector_out);
  counter pc0 (clk, reset, load3, alu_out, pcf);
  adder4 alu (selector_out, im, alu_out, alu_co);
  dff alu_co_memo (clk, reset, alu_co, m_alu_co);

  assign adr = pcf;

  assign im = instr[3:0];
  assign op0 = instr[4];
  assign op1 = instr[5];
  assign op2 = instr[6];
  assign op3 = instr[7];
  assign select_a = op0 | op3;
  assign select_b = op1;
  assign load0 = !(op2 | op3);
  assign load1 = !(!op2 | op3);
  assign load2 = !op2 & op3;
  assign load3 = (!m_alu_co | op0) & op2 & op3;

  initial begin
    $monitor("%t: pc = %b, a = %b, b = %b,", $time, pcf, reg_a_data, reg_b_data);
    // $monitor("%t: pc = %b, a = %b, b = %b, op0 = %b, op1 = %b, op2 = %b, op3 = %b, select_a = %b, select_b = %b, load0 = %b, load1 = %b, load2 = %b, load3 = %b, instr = %b", $time, pcf, reg_a_data, reg_b_data, op0, op1, op2, op3, select_a, select_b, load0, load1, load2, load3, instr);
    // $monitor(">> ALU: in0 = %b, in1 = %b, out = %b, co = %b, select_a = %b, select_b = %b", selector_out, im, alu_out, m_alu_co, select_a, select_b);
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

module dff(
  input clk,
  input reset,
  input d,
  output reg q);

  always @ (posedge clk, posedge reset)
    if (reset)
      q <= 1'b0;
    else
      q <= d;
endmodule
