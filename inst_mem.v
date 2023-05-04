module inst_mem (adr, d_out);
	input [31:0] adr;
	output reg [31:0] d_out;
	
	reg [31:0] mem [0:127];
	
	initial $readmemb("instruction1.txt", mem);
	
	assign d_out = mem[adr >> 2];
endmodule

