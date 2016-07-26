module td4_test();
  reg clk, reset;
  wire [3:0] rom_adr;
  wire [7:0] rom_data;

  td4 cpu0 (clk, reset, rom_adr, rom_data);
  td4_rom rom0 (rom_adr, rom_data);

  always
    #5 clk = !clk;

  initial
    // 400単位時間後にfinish
    #400 $finish;

  initial begin
    // init clock
    clk = 0;

    // reset cpu
    reset = 1; #10;
    reset = 0; #10;
  end
endmodule

module td4(
  input clk, reset,
  output [3:0] adr,
  input [7:0] instr
);

  wire [3:0] pcf; // PCの出力
  wire [3:0] im;
  wire [3:0] alu_out;
  wire alu_co, m_alu_co;
  wire [3:0] reg_a_data, reg_b_data;
  wire [3:0] selector_out;
  wire select_a, select_b;
  wire load0, load1, load2, load3;

  register reg_a (clk, reset, load0, alu_out, reg_a_data);
  register reg_b (clk, reset, load1, alu_out, reg_b_data);
  data_selector selector0 (reg_a_data, reg_b_data, 4'b0000, 4'b0000, select_a, select_b, selector_out);
  counter pc0 (clk, reset, load3, alu_out, pcf);
  adder4 alu (selector_out, im, alu_out, alu_co);
  dff alu_co_memo (clk, reset, alu_co, m_alu_co);

  assign adr = pcf;

  assign im = instr[3:0];
  assign select_a = instr[4] | instr[7];
  assign select_b = instr[5];
  assign load0 = !(instr[6] | instr[7]);
  assign load1 = !(!instr[6] | instr[7]);
  assign load2 = instr[7] & !instr[6];
  assign load3 = (!m_alu_co | instr[4]) & instr[6] & instr[7];

  initial begin
    $monitor("%t: pc = %b, a = %b, b = %b,", $time, pcf, reg_a_data, reg_b_data);
    // $monitor(">> ALU: in0 = %b, in1 = %b, out = %b, co = %b, select_a = %b, select_b = %b", selector_out, im, alu_out, m_alu_co, select_a, select_b);
  end
endmodule

module td4_rom(
  input [3:0] adr,
  output reg [7:0] dout);

  always @ (adr)
    // ROMの中身
    case (adr)
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
