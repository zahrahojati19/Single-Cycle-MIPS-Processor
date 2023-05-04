module controller ( opcode, func, zero, reg_dst, mem_to_reg, reg_write, 
                    alu_src, mem_read, mem_write, pc_src, operation, J, write_dst
                  );
                    
    input [5:0] opcode;
    input [5:0] func;
    input zero;
    output  write_dst, mem_to_reg, reg_write, alu_src, 
            mem_read, mem_write, pc_src;
    reg     write_dst, mem_to_reg, reg_write, 
            alu_src, mem_read, mem_write; 
    output [2:0] operation;
    output [1:0]J, reg_dst;
            
    reg [1:0] alu_op, J, reg_dst;     
    reg branch;   
    
    alu_controller ALU_CTRL(alu_op, func, operation);
    
    always @(opcode)
    begin
      {reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op, J, write_dst} = 12'd0;
      case (opcode)
        // RType instructions
        6'b000000 : {reg_dst, reg_write, alu_op, write_dst} = 6'b011100;   
        // Load Word (lw) instruction           
        6'b100011 : {alu_src, mem_to_reg, reg_write, mem_read} = 4'b1111; 
        // Store Word (sw) instruction
        6'b101011 : {alu_src, mem_write} = 2'b11;                                 
        // Branch on equal (beq) instruction
        6'b000100 : {branch, alu_op} = 3'b101; 
        // Add immediate (addi) instruction
        6'b001001: {reg_write, alu_src} = 2'b11; 
	//Jump (J) instruction
	6'b000010: J= 2'b01; // loads the immediate value in pc
	//Jump Register (Jr) instruction
	6'b000110: J= 2'b10; //return control to the caller
	//Jump and link (Jal) instruction
	6'b000011:  {reg_dst, write_dst, reg_write, J} = 6'b101110; // Rd = pc +4 , pc = imm
	//Set on less than (slti) instruction
	6'b001010: {reg_write, alu_src, alu_op, mem_to_reg} = 5'b11110;  //turns the inst[20:16] to 1 if inst[25:21]<immediate value
      endcase
    end
    
    assign pc_src = branch & zero;
  
endmodule
