module data_mem (adr, d_in, mrd, mwr,  clk, d_out);
	input clk, mrd, mwr;
	input [31:0] adr, d_in;
	output reg [31:0] d_out;
	
	reg [31:0] mem [250:700];
	
	initial $readmemb("datamem.txt", mem, 250);
	
	assign d_out = mrd ? mem[adr>>2] : 32'bz;
	always @(posedge clk)
		if (mwr)
			mem[adr>>2] = d_in;
endmodule 
