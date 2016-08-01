module cpu(
  input clk,
  input n_reset,
  output [3:0] address,
  input [7:0] instr);

  //------------------------
  // Monitor settings
  //------------------------
  initial
    $monitor("%t: pc = %b, a = %b, b = %b, instr = %b, op = %b, im = %b, select_a = %b, select_b = %b, load0 = %b, load1 = %b, load2 = %b", $time, pc_reg, a_reg, b_reg, instr, op, im, select_a, select_b, load0, load1, load2);

  //------------------------
  // Signal Declarations
  //------------------------
  wire [3:0] op;
  wire [3:0] im;
  reg [3:0] pc_reg; // Program counter
  reg [3:0] a_reg, b_reg; // A, B register

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
  end

  always @(posedge clk) begin
    a_reg <= load0 ? im : a_reg;
    b_reg <= load1 ? im : b_reg;
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
  // assign load3 = (!m_alu_co | op[0]) & op[2] & op[3];
endmodule

module cpu_test();
  reg clk;
  reg n_reset;

  wire [3:0] address;
  wire [7:0] dout;

  // Generate clock
  always begin
    #5 clk = 1;
    #5 clk = 0;
  end

  cpu cpu(clk, n_reset, address, dout);
  test_rom rom(address, dout);

  // Finish after 1000 unit times
  always
    #100 $finish;

  initial begin
    // Init variables
    #0 clk = 0; n_reset = 1;

    // Reset cpu
    #10 n_reset = 0;
    #10 n_reset = 1;
  end
endmodule

// ROM
module test_rom(
  input [3:0] address,
  output reg [7:0] dout
);

  always @(address)
    case (address)
      4'b0000: dout <= 8'b00000000;
      4'b0001: dout <= 8'b00000001;
      4'b0010: dout <= 8'b00000010;
      4'b0011: dout <= 8'b00000011;
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
      default: dout <= 8'bxxxxxxxx;
    endcase
endmodule
