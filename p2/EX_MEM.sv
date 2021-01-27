module EX_MEM(
	//Inputs maybe remove rd- alu_out, aluin2
	clk, rst, 
	rd, rt, alu_in2, alu_out, pc,
	MemWrite, 
	RegDst, 
	Branch, 
	MemRead, 
	MemtoReg, 
	ALUSrc, 
	RegWrite, 
	BranchReg, 
	PCS, 
	HLT, 
	LB, 
	MemReadorWrite,
	memwrite_data,
	// Outputs 
	EXMEMMemWrite, 
	EXMEMRegDst, 
	EXMEMBranch, 
	EXMEMMemRead, 
	EXMEMMemtoReg, 
	EXMEMALUSrc, 
	EXMEMRegWrite, 
	EXMEMBranchReg,
	EXMEMPCS, 
	EXMEMHLT, 
	EXMEMLB, 
	EXMEMMemReadorWrite,
	EXMEMwrite_data,
	EXMEMalu_out,
	EXMEMrd,
	EXMEMrt,
	EXMEMpc
);

input wire clk, rst;
input wire[15:0] alu_out, alu_in2, memwrite_data, pc;
input wire[3:0] rd, rt;
input wire RegDst, Branch, MemRead, MemtoReg, MemWrite, 
			ALUSrc, RegWrite, BranchReg, PCS, HLT, LB, MemReadorWrite; 

output wire[15:0] EXMEMwrite_data, EXMEMalu_out, EXMEMpc;
output wire[3:0] EXMEMrd, EXMEMrt;
output wire EXMEMRegDst, EXMEMBranch, EXMEMMemRead, EXMEMMemtoReg, EXMEMMemWrite, 
			EXMEMALUSrc, EXMEMRegWrite, EXMEMBranchReg, EXMEMPCS, EXMEMHLT, EXMEMLB, EXMEMMemReadorWrite;

// Flops to hold control signals
dff ff1(.q(EXMEMRegDst), .d(RegDst), .wen(1'b1), .clk(clk), .rst(rst));
dff ff2(.q(EXMEMBranch), .d(Branch), .wen(1'b1), .clk(clk), .rst(rst));
dff ff3(.q(EXMEMMemRead), .d(MemRead), .wen(1'b1), .clk(clk), .rst(rst));
dff ff4(.q(EXMEMMemtoReg), .d(MemtoReg), .wen(1'b1), .clk(clk), .rst(rst));
dff ff5(.q(EXMEMMemWrite), .d(MemWrite), .wen(1'b1), .clk(clk), .rst(rst));
dff ff6(.q(EXMEMALUSrc), .d(ALUSrc), .wen(1'b1), .clk(clk), .rst(rst));
dff ff7(.q(EXMEMRegWrite), .d(RegWrite), .wen(1'b1), .clk(clk), .rst(rst));
dff ff8(.q(EXMEMBranchReg), .d(BranchReg), .wen(1'b1), .clk(clk), .rst(rst));
dff ff9(.q(EXMEMPCS), .d(PCS), .wen(1'b1), .clk(clk), .rst(rst));
dff ff10(.q(EXMEMHLT), .d(HLT), .wen(1'b1), .clk(clk), .rst(rst));
dff ff11(.q(EXMEMLB), .d(LB), .wen(1'b1), .clk(clk), .rst(rst));
dff ff12(.q(EXMEMMemReadorWrite), .d(MemReadorWrite), .wen(1'b1), .clk(clk), .rst(rst));

// Flop to hold the ALU output
dff ff_alu_out[15:0](.q(EXMEMalu_out), .d(alu_out), .wen(1'b1), .clk(clk), .rst(rst));

// Flop to hold the PC for PCS
dff ff_pc[15:0](.q(EXMEMpc), .d(pc), .wen(1'b1), .clk(clk), .rst(rst));

// Flop to hold the rd register
dff ff_rd[3:0](.q(EXMEMrd), .d(rd), .wen(1'b1), .clk(clk), .rst(rst));
dff ff_rt[3:0](.q(EXMEMrt), .d(rt), .wen(1'b1), .clk(clk), .rst(rst));

// Flop to hold the write data (for SW)
dff ff_write_data[15:0](.q(EXMEMwrite_data), .d(memwrite_data), .wen(1'b1), .clk(clk), .rst(rst));

endmodule
