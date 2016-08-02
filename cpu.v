module cpu(
  input clk,
  input n_reset,
  output [3:0] address,
  input [7:0] instr,
  input [3:0] in,
  output [3:0] out);

  //------------------------
  // Monitor settings
  //------------------------
  initial begin
    // $monitor("%t: pc = %b, a = %b, b = %b, instr = %b, op = %b, im = %b, select_a = %b, select_b = %b, load0 = %b, load1 = %b, load2 = %b", $time, pc_reg, a_reg, b_reg, instr, op, im, select_a, select_b, load0, load1, load2);
  end

  //------------------------
  // Signal Declarations
  //------------------------
  wire [3:0] op;
  wire [3:0] im;
  wire select_a, select_b;
  wire load0, load1, load2, load3;
  wire [3:0] selector_out;
  wire [3:0] alu_out;
  wire c; // Carry out

  reg [3:0] pc_reg; // Program counter
  reg [3:0] a_reg, b_reg; // A, B register
  reg [3:0] out_reg; // Out port register
  reg co_reg; // Carry out register

  //------------------------
  // ALU and carry out register
  //------------------------
  assign {c, alu_out} = selector_out + im;

  always @(negedge n_reset)
    co_reg <= 0;

  always @(posedge clk)
    co_reg <= c;

  //------------------------
  // Data selector
  //------------------------
  data_selector ds (a_reg, b_reg, in, 4'b0000, select_a, select_b, selector_out);

  //------------------------
  // Program Counter
  //------------------------
  assign address = pc_reg;

  always @(negedge n_reset)
    pc_reg <= 0;

  always @(posedge clk)
    pc_reg <= load3 ? im : pc_reg + 1;

  //------------------------
  // Registers
  //------------------------
  always @(negedge n_reset) begin
    a_reg <= 0;
    b_reg <= 0;
    out_reg <= 0;
  end

  always @(posedge clk) begin
    a_reg <= load0 ? alu_out : a_reg;
    b_reg <= load1 ? alu_out : b_reg;
    out_reg <= load2 ? alu_out : out_reg;
  end

  //------------------------
  // Output port
  //------------------------
  assign out = out_reg;

  always @(negedge n_reset) begin
    out_reg <= 0;
  end

  always @(posedge clk) begin
    out_reg <= load2 ? alu_out : out_reg;
  end

  //------------------------
  // Control
  //------------------------
  assign op = instr[7:4];
  assign im = instr[3:0];
  assign select_a = op[0] | op[3];
  assign select_b = op[1];
  assign load0 = !(op[2] | op[3]);
  assign load1 = !(!op[2] | op[3]);
  assign load2 = !op[2] & op[3];
  assign load3 = (!co_reg | op[0]) & op[2] & op[3];
endmodule

module data_selector(
  input [3:0] c0,
  input [3:0] c1,
  input [3:0] c2,
  input [3:0] c3,
  input select_a, select_b,
  output reg [3:0] y
);

  always @(*) begin
    if (select_a & select_b)
      y = c3;
    else if (!select_a & select_b)
      y = c2;
    else if (select_a & !select_b)
      y = c1;
    else
      y = c0;
  end
endmodule

//------------------------
// テストベンチ
//------------------------
module cpu_test();
  reg clk;
  reg n_reset;
  reg [3:0] port_in;

  wire [3:0] address;
  wire [7:0] dout;
  wire [3:0] port_out;

  // Generate clock
  always begin
    #5 clk = 1;
    #5 clk = 0;
  end

  cpu cpu(clk, n_reset, address, dout, port_in, port_out);
  test_rom rom(address, dout);

  // Finish after 1000 unit times
  always
    #1000 $finish;

  initial begin
    $dumpfile("cpu_test.vcd");
    $dumpvars(0, cpu);
    $monitor("%t: out = %b", $time, port_out);
  end

  initial begin
    // Init variables
    #0 clk = 0; n_reset = 1; port_in = 4'b0101;

    // Reset cpu
    #10 n_reset = 0;
    #10 n_reset = 1;
  end
endmodule

//------------------------
// ROM
//------------------------
module test_rom(
  input [3:0] address,
  output reg [7:0] dout
);

  always @(address)
    case (address)
      /*
        carry outするまでAレジスタへ加算を行い、
        carry outしたらAの値を出力後に無限ループを行う
      */
      4'b0000: dout <= 8'b00110000; // MOV A, 0
      4'b0001: dout <= 8'b01000000; // MOV B, A
      4'b0010: dout <= 8'b10010000; // OUT B
      4'b0011: dout <= 8'b00000001; // ADD A, 1
      4'b0100: dout <= 8'b11100001; // JNC 0001
      4'b0101: dout <= 8'b01000000; // MOV B, A
      4'b0110: dout <= 8'b10010000; // OUT B
      4'b0111: dout <= 8'b00000000; // NOP
      4'b1000: dout <= 8'b11110111; // JMP 0111
      4'b1001: dout <= 8'b00000000;
      4'b1010: dout <= 8'b00000000;
      4'b1011: dout <= 8'b00000000;
      4'b1100: dout <= 8'b00000000;
      4'b1101: dout <= 8'b00000000;
      4'b1110: dout <= 8'b00000000;
      4'b1111: dout <= 8'b00000000;
      default: dout <= 8'bxxxxxxxx;
    endcase
endmodule
