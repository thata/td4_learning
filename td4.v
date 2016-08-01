module td4(
  input clk, reset,
  output [3:0] adr,
  input [7:0] instr,
  input [3:0] in_port,
  output [3:0] out_port
);

  wire [3:0] op;
  wire [3:0] im;
  
  wire [3:0] pcf; // PCの出力
  wire [3:0] alu_out;
  wire alu_co, m_alu_co;
  wire [3:0] reg_a_data, reg_b_data;
  wire [3:0] selector_out;
  wire select_a, select_b;
  wire load0, load1, load2, load3;

  register reg_a (clk, reset, load0, alu_out, reg_a_data);
  register reg_b (clk, reset, load1, alu_out, reg_b_data);
  register reg_c (clk, reset, load2, alu_out, out_port);
  data_selector selector0 (reg_a_data, reg_b_data, in_port, 4'b0000, select_a, select_b, selector_out);
  counter pc0 (clk, reset, load3, alu_out, pcf);
  adder4 alu (selector_out, im, alu_out, alu_co);
  dff alu_co_memo (clk, reset, alu_co, m_alu_co);

  assign im = instr[3:0];
  assign op = instr[7:4];

  assign adr = pcf;

  assign select_a = op[0] | op[3];
  assign select_b = op[1];
  assign load0 = !(op[2] | op[3]);
  assign load1 = !(!op[2] | op[3]);
  assign load2 = !op[2] & op[3];
  assign load3 = (!m_alu_co | op[0]) & op[2] & op[3];

  initial begin
    $monitor("%t: pc = %b, a = %b, b = %b,", $time, pcf, reg_a_data, reg_b_data);
  end
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
