module shl2_26 (d_in, d_out);
  input [25:0] d_in;
  output [27:0] d_out;
  
  assign d_out = d_in << 2;
  
endmodule
