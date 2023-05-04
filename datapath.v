module datapath ( clk, rst, inst_adr, inst,
                  data_adr, data_out, data_in, 
                  reg_dst, mem_to_reg, alu_src, pc_src, alu_ctrl, reg_write,
                  zero, J, write_dst
                 );
  input  clk, rst;
  output [31:0] inst_adr;
  input  [31:0] inst;
  output [31:0] data_adr;
  output [31:0] data_out;
  input  [31:0] data_in;
  input  write_dst, mem_to_reg, alu_src, pc_src, reg_write;
  input  [2:0] alu_ctrl;
  input  [1:0] J;
  input  [1:0] reg_dst;
  output zero;

  wire [31:0] pc_out;
  wire [31:0] adder1_out;
  wire [31:0] read_data1, read_data2;
  wire [31:0] sgn_ext_out;
  wire [31:0] mux2_out;
  wire [31:0] alu_out;
  wire [31:0] adder2_out;
  wire [31:0] shl2_out;
  wire [31:0] mux3_out;
  wire [31:0] mux4_out;
  wire [31:0] mux33_out;
  wire [27:0] shift;
  wire [31:0] mux44_out;

  wire [4:0]  mux1_out;

  reg_32b PC(mux33_out, rst, 1'b1, clk, pc_out);

  adder_32b ADDER_1 (pc_out , 32'd4, 1'b0, , adder1_out);

  mux3to1_5b MUX_1(inst[20:16], inst[15:11], 5'b11111, reg_dst, mux1_out);

  mux2to1_32b MUX_11(mux4_out, adder1_out, write_dst, mux44_out);

  reg_file  RF(mux44_out, inst[25:21], inst[20:16], mux1_out, reg_write, rst, clk, read_data1, read_data2);

  sign_ext SGN_EXT(inst[15:0], sgn_ext_out);

  mux2to1_32b MUX_2(read_data2, sgn_ext_out, alu_src, mux2_out);

  alu ALU(read_data1, mux2_out, alu_ctrl, alu_out, zero);

  shl2 SHL2(sgn_ext_out, shl2_out);

  adder_32b ADDER_2(adder1_out, shl2_out, 1'b0, , adder2_out);

  mux2to1_32b MUX_3(adder1_out, adder2_out, pc_src, mux3_out);

  shl2_26 SHL22(inst[25:0],shift);

  mux3to1_32b MUX_33(mux3_out, {adder1_out[31:28],shift}, sgn_ext_out, J, mux33_out);

  mux2to1_32b MUX_4(alu_out, data_in, mem_to_reg, mux4_out);

  assign inst_adr = pc_out;
  assign data_adr = alu_out;
  assign data_out = read_data2;
  
endmodule
