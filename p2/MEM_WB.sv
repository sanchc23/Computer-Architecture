module MEM_WB(
	// Inputs
	clk, rst, 
	rd,
	alu_out,
	dmem_out,
	RegDst,
	Branch, 
	MemtoReg, 
	ALUSrc, 
	RegWrite, 
	BranchReg, 
	PCS, 
	HLT, 
	LB, 
	pc,
	//Outputs
	MEMWBRegDst, 
	MEMWBBranch, 
	MEMWBMemtoReg, 
	MEMWBALUSrc, 
	MEMWBRegWrite, 
	MEMWBBranchReg, 
	MEMWBPCS, 
	MEMWBHLT, 
	MEMWBLB,
	MEMWBalu_out, 
	MEMWBdmem_out,
	MEMWBrd,
	MEMWBpc
);

input wire clk, rst;
input wire[15:0] alu_out, dmem_out, pc;
input wire[3:0] rd;
input wire RegDst, Branch, MemtoReg, ALUSrc, RegWrite, BranchReg, PCS, HLT, LB; 

output wire[15:0] MEMWBalu_out, MEMWBdmem_out, MEMWBpc;
output wire[3:0] MEMWBrd;
output wire MEMWBRegDst, MEMWBBranch, MEMWBMemtoReg, MEMWBALUSrc, MEMWBRegWrite, MEMWBBranchReg, MEMWBPCS, MEMWBHLT, MEMWBLB;

// Flops to hold the current instruction
dff ff12[3:0] (.q(MEMWBrd), .d(rd), .wen(1'b1), .clk(clk), .rst(rst));

// Flops to hold control signals
dff ff1(.q(MEMWBRegDst), .d(RegDst), .wen(1'b1), .clk(clk), .rst(rst));
dff ff2(.q(MEMWBBranch), .d(Branch), .wen(1'b1), .clk(clk), .rst(rst));
dff ff4(.q(MEMWBMemtoReg), .d(MemtoReg), .wen(1'b1), .clk(clk), .rst(rst));
dff ff6(.q(MEMWBALUSrc), .d(ALUSrc), .wen(1'b1), .clk(clk), .rst(rst));
dff ff7(.q(MEMWBRegWrite), .d(RegWrite), .wen(1'b1), .clk(clk), .rst(rst));
dff ff8(.q(MEMWBBranchReg), .d(BranchReg), .wen(1'b1), .clk(clk), .rst(rst));
dff ff9(.q(MEMWBPCS), .d(PCS), .wen(1'b1), .clk(clk), .rst(rst));
dff ff10(.q(MEMWBHLT), .d(HLT), .wen(1'b1), .clk(clk), .rst(rst));
dff ff11(.q(MEMWBLB), .d(LB), .wen(1'b1), .clk(clk), .rst(rst));

// Flop to hold the ALU output
dff ff_alu_out[15:0](.q(MEMWBalu_out), .d(alu_out), .wen(1'b1), .clk(clk), .rst(rst));

// Flop to hold the PC for PCS
dff ff_pc[15:0](.q(MEMWBpc), .d(pc), .wen(1'b1), .clk(clk), .rst(rst));

// Flop to hold the fetched data from memory
dff ff_dmem_out[15:0](.q(MEMWBdmem_out), .d(dmem_out), .wen(1'b1), .clk(clk), .rst(rst));

endmodule
