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
