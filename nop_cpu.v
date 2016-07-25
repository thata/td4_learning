// nopのみを実行するCPU
module nop_cpu_test();
  reg a;

  reg clk, reset;
  wire [3:0] rom_adr;
  wire [7:0] rom_data;

  nop_cpu cpu0 (clk, reset, rom_adr, rom_data);
  rom rom0 (rom_adr, rom_data);

  always
    #5 clk = !clk;

  initial begin
    // init clock
    clk = 0;

    // reset cpu
    reset = 1; #10;
    reset = 0; #10;
  end
endmodule

module nop_cpu(
  input clk, reset,
  output [3:0] adr,
  input [7:0] instr
);

  wire [3:0] pcf; // PCの出力
  wire [3:0] im;
  wire [3:0] alu_out;
  wire alu_co;
  wire [3:0] reg_a_data;

  flopr reg_a (clk, reset, alu_out, reg_a_data);
  counter pc0 (clk, reset, 1'b0, 4'b0000, pcf); // ひとまずインクリメントのみ
  adder4 alu (reg_a_data, im, alu_out, alu_co);

  assign adr = pcf;
  assign im = instr[3:0];

  initial begin
    $monitor("%t: clk = %b, pc = %b, a = %b", $time, clk, pcf, reg_a_data);
  end
endmodule

module rom(
  input [3:0] adr,
  output reg [7:0] dout);

  always @ (adr)
    // ROMの中身
    case (adr)
      4'b0000: dout <= 8'b00000000;
      4'b0001: dout <= 8'b00000000;
      4'b0010: dout <= 8'b00000000;
      4'b0011: dout <= 8'b00000000;
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
