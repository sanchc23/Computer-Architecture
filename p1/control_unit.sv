module control_unit(RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, BranchReg, PCS, HLT, LB, MemReadorWrite, opcode);

input[3:0] opcode;
output RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, BranchReg, PCS, HLT, LB, MemReadorWrite;

// RegDst asserted if op is ADD, SUB, or XOR, PADDSB, or RED
assign RegDst = (opcode[3:2] == 2'b00) | (opcode == 4'b0111);

// Branch if op is B or BR
assign Branch = (opcode == 4'b1100) | (opcode == 4'b1101);

// Read memory if op is LW
assign MemRead = (opcode == 4'b1000);

// Write memory if op is SW
assign MemWrite = opcode == 4'b1001;

// Write memory data to reg if op is LW
assign MemtoReg = (opcode == 4'b1000);

assign MemReadorWrite = (opcode == 4'b1000) | (opcode == 4'b1001);

// ALUSrc select immediate if op is LW or SW
assign ALUSrc = (opcode == 4'b1001) | (opcode == 4'b1000) | (opcode == 4'b0100) | (opcode == 4'b0101) | (opcode == 4'b0110);

// Always write to register unless op is B, BR, HLT, or SW
assign RegWrite = (opcode != 4'b1100) & (opcode != 4'b1101) & (opcode != 4'b1111) & (opcode != 4'b1001);

assign BranchReg = (opcode == 4'b1101);

assign PCS = (opcode == 4'b1110);

assign HLT = (opcode == 4'b1111);

assign LB = (opcode == 4'b1011) | (opcode == 4'b1010);

endmodule
