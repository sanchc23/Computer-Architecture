module ID_EX(
	// Inputs
	clk, rst, 
	rt, rs, rd, 
	imm, sign_ext_imm, imm_lb, 
	Rf_1, Rf_2,  
	RegDst, 
	Branch, 
	MemRead, 
	MemtoReg, 
	MemWrite,  
	ALUSrc, 
	RegWrite, 
	BranchReg, 
	PCS, 
	HLT, 
	LB, 
	MemReadorWrite,
	opcode,
	pc,
	WriteEnable,
	//Outputs
	IDEXRegDst, 
	IDEXBranch, 
	IDEXMemRead, 
	IDEXMemtoReg, 
	IDEXMemWrite, 
	IDEX_a, IDEX_b, 
	IDEXrs, 
	IDEXrt, 
	IDEXrd, 
	IDEXimm, 
	IDEXsign_ext_imm, 
	IDEXimm_lb,
	IDEXALUSrc, 
	IDEXRegWrite, 
	IDEXBranchReg, 
	IDEXPCS, 
	IDEXHLT, 
	IDEXLB, 
	IDEXMemReadorWrite,
	IDEXOpcode,
	IDEXpc
);

// Clock and reset
input wire clk, rst, WriteEnable;

// Registers #s, values
input wire[15:0] Rf_1, Rf_2, pc;
input wire[3:0] rs, rt, rd;
input wire[3:0] opcode;

// Immediates
input wire[3:0] imm;
input wire[15:0] sign_ext_imm;
input wire[7:0] imm_lb;

// Control signals
input wire RegDst, Branch, MemRead, MemtoReg, MemWrite, 
			ALUSrc, RegWrite, BranchReg, PCS, HLT, LB, MemReadorWrite; 

// Ouputs - operands A and B, rs/rt/rd, immediates, and control signals
output wire[15:0] IDEX_a, IDEX_b, IDEXpc;
output wire[3:0] IDEXrs, IDEXrt, IDEXrd;
output wire[3:0] IDEXimm;
output wire[3:0] IDEXOpcode;
output wire[15:0] IDEXsign_ext_imm;
output wire[7:0] IDEXimm_lb;
output wire IDEXRegDst, IDEXBranch, IDEXMemRead, IDEXMemtoReg, IDEXMemWrite, 
			IDEXALUSrc, IDEXRegWrite, IDEXBranchReg, IDEXPCS, IDEXHLT, IDEXLB, IDEXMemReadorWrite;

// Flops to hold register numbers 
dff ff_rt[3:0](.q(IDEXrt), .d(rt), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff_rs[3:0](.q(IDEXrs), .d(rs), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff_rd[3:0](.q(IDEXrd), .d(rd), .wen(WriteEnable), .clk(clk), .rst(rst));

dff ff_op[3:0](.q(IDEXOpcode), .d(opcode), .wen(WriteEnable), .clk(clk), .rst(rst));

//Flops to hold operands A and B and pc
dff rf_1[15:0](.q(IDEX_a), .d(Rf_1), .wen(WriteEnable), .clk(clk), .rst(rst));
dff rf_2[15:0](.q(IDEX_b), .d(Rf_2), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff_pc[15:0](.q(IDEXpc), .d(pc), .wen(WriteEnable), .clk(clk), .rst(rst));

// Flops to hold immediates
dff ff_imm[3:0](.q(IDEXimm), .d(imm), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff_sign_ext_imm[15:0](.q(IDEXsign_ext_imm), .d(sign_ext_imm), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff_imm_lb[7:0](.q(IDEXimm_lb), .d(imm_lb), .wen(WriteEnable), .clk(clk), .rst(rst));

// Flops to hold control signals
dff ff1(.q(IDEXRegDst), .d(RegDst), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff2(.q(IDEXBranch), .d(Branch), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff3(.q(IDEXMemRead), .d(MemRead), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff4(.q(IDEXMemtoReg), .d(MemtoReg), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff5(.q(IDEXMemWrite), .d(MemWrite), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff6(.q(IDEXALUSrc), .d(ALUSrc), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff7(.q(IDEXRegWrite), .d(RegWrite), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff8(.q(IDEXBranchReg), .d(BranchReg), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff9(.q(IDEXPCS), .d(PCS), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff10(.q(IDEXHLT), .d(HLT), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff11(.q(IDEXLB), .d(LB), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff12(.q(IDEXMemReadorWrite), .d(MemReadorWrite), .wen(WriteEnable), .clk(clk), .rst(rst));


endmodule
