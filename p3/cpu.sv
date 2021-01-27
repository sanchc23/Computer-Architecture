module cpu(pc_out, hlt, clk, rst_n);
input clk, rst_n;
output hlt;
output[15:0] pc_out;

/*------------------------------------------------------------*/
/*-------------------------- Interconnects -------------------*/
/*------------------------------------------------------------*/

// INTERCONNECTS
wire[2:0] Flag;
wire[2:0] condition;
wire[3:0] opcode, rd, rs, rt, imm;
wire[7:0] imm_lb;
wire[8:0] offset;
wire[15:0] rf_d1, rf_d2; // Register file outputs
wire[15:0] dmem_out, imem_out, imem_miss, dmiss_mem; // Memory outputs
wire[15:0] sign_ext_imm;
wire[15:0] write_b, alu_in1, alu_in2, alu_out, curr_instr; // ALU, write back and instructions
wire[15:0] PC_Plus_2, PC_Minus_2, PC_if_id, pc_in, pc_branch;

// CONTROL SIGNALS
wire RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, BranchReg, PCS, HLT, LB, MemReadorWrite, IFIDBranch;

// Hazard Detect
wire NoOp;


/*// Some kinda shit
wire hlt_fetch_state;
    dff hlt_fetched(.q(hlt_fetch_state), .d(~hlt_fetch_not_yet), .wen(~hlt_fetch_state), .clk(clk), .rst(rst));

    assign rst = ~rst_n;
    assign hlt = wb_hlt;
    assign hlt_fetch_not_yet = if_inst[15:12] != 4'b1111 ? 1 :
                   id_inst[15:13] != 4'b110 ? 0 : br_taken ? 1 : 0;*/


// Ouputs from MEM/WB Register
wire[15:0] MEMWBalu_out, MEMWBdmem_out, MEMWBpc;
wire[3:0] MEMWBrd;
wire MEMWBRegDst, MEMWBBranch, MEMWBMemtoReg, MEMWBALUSrc, MEMWBRegWrite, MEMWBBranchReg, MEMWBPCS, MEMWBHLT, MEMWBLB;


wire mem_stall, if_stall;
reg dcache_stall, icache_stall;


always @(clk)
casex({mem_stall})
1'b1: dcache_stall = 1;
default: dcache_stall = 0;
endcase

always @(clk)
casex({if_stall})
1'b1: icache_stall = 1;
default: icache_stall = 0;
endcase

wire cache_stall;
assign cache_stall = icache_stall | dcache_stall;

/*------------------------------------------------------------*/
/*-------------------------- IF Stage ------------------------*/
/*---Holds PC, PC_adder, Instruction Mem, and IF/ID Register--*/
/*------------------------------------------------------------*/

wire br_taken;
// If HLT do nothing. If we detect a branch in PCControl use the PC output of PC control
// Else then PC + 2

// Sal thought of this to stall the processor during a if_stall
assign pc_in = HLT ? pc_out : (br_taken ? pc_branch : PC_Plus_2);

// This write enable signal disables PC register and IF/ID on a stall
wire IFIDWriteEnable;
//assign IFIDWriteEnable = NoOp ? 1'b0 : 1'b1;
assign IFIDWriteEnable = NoOp | HLT ? 1'b0 : 1'b1;
// PC register
PC pc (.clk(clk), .rst(~rst_n), .PC_In(pc_in), .PC_Out(pc_out), .PC_en(IFIDWriteEnable | ~cache_stall ));

// Increment PC for next instruction
addsub_16bit addr1 (.Sum(PC_Plus_2), .Ovfl(), .A(pc_out), .B(16'd2), .sub(1'b0));



// FIX WR SET TO 1'B0




wire[15:0] ID_Instr;
wire[3:0] IFIDrs, IFIDrt, IFIDrd;
wire IFIDHLT, IFIDBranchReg;
// IF/ID Register
IF_ID if_id(
	// Inputs
	.clk(clk), 
	.rst(~rst_n), 
	.IF_Instr(imem_out),
	.PC_in(PC_Plus_2),
	.WriteEnable(~dcache_stall),
	.br_taken(br_taken),
	// Outputs 
	.ID_Instr(ID_Instr), 
	.PC_out(PC_if_id),
        .IFIDBranch(IFIDBranch), .IFIDBranchReg(IFIDBranchReg),
	.IFIDrs(IFIDrs), .IFIDrt(IFIDrt), .IFIDrd(IFIDrd), // Only for hazard detection
	.IFIDHLT(HLT) // Need to detect here as per HW instructions
); 



/*------------------------------------------------------------*/
/*-------------------------- ID Stage ------------------------*/
/*Registers, Control Unit, Hazard Detection,and ID/EX Register*/
/*------------------------------------------------------------*/

// Get values from current instruction
assign curr_instr = ID_Instr; 
assign opcode = curr_instr[15:12];
assign rd	  = curr_instr[11:8];
assign rs	  = curr_instr[7:4];
assign rt 	  = ~RegDst ? curr_instr[11:8]: curr_instr[3:0];
assign imm 	  = curr_instr[3:0];
assign sign_ext_imm = {{12{imm[3]}}, imm};
assign imm_lb	  = curr_instr[7:0];
assign offset = curr_instr[8:0];
assign condition = curr_instr[11:9];




// PC_control
// PC CONTROL IS CURRENTLY BROKEN DUE TO HAZARD
// PC_in is pc_out because we need current value of pc
PC_control pc_ctrl(
	.C(condition), 
	.I(offset), 
	.F(Flag), 
	.PC_in(PC_if_id), 
	.reg_target(rf_d1),
	.br(IFIDBranch), 
	.breg(IFIDBranchReg), 
	.PC_out(pc_branch), 
	.HLT(HLT), .rst_n(~rst_n), .br_taken(br_taken)
);

// Control unit
control_unit ctrl_unit(
	//Input
	.opcode(opcode),
	// Outputs
	.RegDst(RegDst),
	.Branch(Branch),
	.MemRead(MemRead),	
	.MemtoReg(MemtoReg),
	.MemWrite(MemWrite),
	.ALUSrc(ALUSrc),
	.RegWrite(RegWrite),
	.BranchReg(BranchReg),
	.PCS(PCS),	
	.LB(LB),
	//.HLT(HLT), 
	.MemReadorWrite(MemReadorWrite)
);


// Register File
RegisterFile rgFile(
    .SrcData1(rf_d1), 
    .SrcData2(rf_d2), 
    .clk(clk), 
    .rst(~rst_n), 
    .SrcReg1(rs), 
    .SrcReg2(rt),
    .DstReg(MEMWBrd), 
    .WriteReg(MEMWBRegWrite & (MEMWBrd != 4'b0000)), 
    .DstData(write_b)
);

// Outputs from ID/EX Register
wire[15:0] IDEX_a, IDEX_b, IDEXpc;
wire[3:0] IDEXrs, IDEXrt, IDEXrd;
wire[3:0] IDEXimm, IDEXOpcode;
wire[15:0] IDEXsign_ext_imm;
wire[7:0] IDEXimm_lb;
wire IDEXRegDst, IDEXBranch, IDEXMemRead, IDEXMemtoReg, IDEXMemWrite, 
	 IDEXALUSrc, IDEXRegWrite, IDEXBranchReg, IDEXPCS, IDEXHLT, IDEXLB, IDEXMemReadorWrite;
	 
wire IDEXRegDst_NoOp, IDEXBranch_NoOp, IDEXMemRead_NoOp, IDEXMemtoReg_NoOp, IDEXMemWrite_NoOp, 
	 IDEXALUSrc_NoOp, IDEXRegWrite_NoOp, IDEXBranchReg_NoOp, IDEXPCS_NoOp, IDEXHLT_NoOp, IDEXLB_NoOp, IDEXMemReadorWrite_NoOp;	 

// If we have a stall, zero out the ID/EX control signals
/*assign IDEXRegDst_NoOp = NoOp ? 0 : RegDst;
assign IDEXBranch_NoOp = NoOp ? 0 : Branch;
assign IDEXMemRead_NoOp = NoOp ? 0 : MemRead;
assign IDEXMemtoReg_NoOp = NoOp ? 0 : MemtoReg;
assign IDEXMemWrite_NoOp = NoOp ? 0 : MemWrite;
assign IDEXALUSrc_NoOp = NoOp ? 0 : ALUSrc ;
assign IDEXRegWrite_NoOp = NoOp ? 0 : RegWrite;
assign IDEXBranchReg_NoOp = NoOp ? 0 : BranchReg ;
assign IDEXPCS_NoOp = NoOp ? 0 : PCS;
assign IDEXHLT_NoOp = NoOp ? 0 : HLT;
assign IDEXLB_NoOp = NoOp ? 0 : LB;
assign IDEXMemReadorWrite_NoOp = NoOp ? 0 : MemReadorWrite;*/


// ID/EX Register
ID_EX id_ex(
	// Inputs
	.clk(clk), .rst(~rst_n),	
	.rs(rs), .rt(rt), .rd(rd),
	.imm(imm), .sign_ext_imm(sign_ext_imm), .imm_lb(imm_lb),
	.Rf_1(rf_d1), .Rf_2(rf_d2), 
	.RegDst(RegDst), 
	.Branch(Branch), 
	.MemRead(MemRead), 
	.MemtoReg(MemtoReg),
	.MemWrite(MemWrite),
	.ALUSrc(ALUSrc),
	.RegWrite(RegWrite),
	.BranchReg(BranchReg),
	.PCS(PCS),
	.HLT(HLT),
	.LB(LB),
	.MemReadorWrite(MemReadorWrite), 
	.opcode(opcode),
	.pc(PC_if_id),
	.WriteEnable(~dcache_stall),
	// Outputs	
	.IDEXRegDst(IDEXRegDst), 
	.IDEXBranch(IDEXBranch), 
	.IDEXMemRead(IDEXMemRead), 
	.IDEXMemtoReg(IDEXMemtoReg), 
	.IDEXMemWrite(IDEXMemWrite), 
	.IDEXALUSrc(IDEXALUSrc), 
	.IDEXRegWrite(IDEXRegWrite), 
	.IDEXBranchReg(IDEXBranchReg),
	.IDEXPCS(IDEXPCS),
	.IDEXHLT(IDEXHLT),
	.IDEXLB(IDEXLB),
	.IDEXMemReadorWrite(IDEXMemReadorWrite),
	.IDEXimm(IDEXimm), 
	.IDEXsign_ext_imm(IDEXsign_ext_imm), 
	.IDEXimm_lb(IDEXimm_lb),
	.IDEX_a(IDEX_a), .IDEX_b(IDEX_b),
	.IDEXrs(IDEXrs), .IDEXrt(IDEXrt), .IDEXrd(IDEXrd),
	.IDEXOpcode(IDEXOpcode),
	.IDEXpc(IDEXpc)
);


/*------------------------------------------------------------*/
/*-------------------------- EX Stage ------------------------*/
/*--------------- ALU, EX/MEM, and Fowarding Unit ------------*/
/*------------------------------------------------------------*/

// ALU
ALU ALU(	
	// Inputs
	.Opcode(IDEXOpcode), 
	.ALU_In1(alu_in1), 
	.ALU_In2(alu_in2),
	// Outputs
	.ALU_Out(alu_out),  
	.Flag(Flag)
);

// Outputs from EX/MEM Register
wire[15:0] EXMEMwrite_data, EXMEMalu_out, EXMEMpc;
wire[3:0] EXMEMrd, EXMEMrt;
wire EXMEMRegDst, EXMEMBranch, EXMEMMemRead, EXMEMMemtoReg, EXMEMMemWrite, 
			EXMEMALUSrc, EXMEMRegWrite, EXMEMBranchReg, EXMEMPCS, EXMEMHLT, EXMEMLB, EXMEMMemReadorWrite;

// EX/MEM Pipeline Register
EX_MEM ex_mem(
	// Inputs
	.clk(clk),
	.rst(~rst_n),
	.rd(IDEXrd), .alu_in2(alu_in2), .alu_out(alu_out),
	.rt(IDEXrt),
	.MemWrite(IDEXMemWrite), 
	.RegDst(IDEXRegDst), 
	.Branch(IDEXBranch), 
	.MemRead(IDEXMemRead), 
	.MemtoReg(IDEXMemtoReg), 
	.ALUSrc(IDEXALUSrc), 
	.RegWrite(IDEXRegWrite), 
	.BranchReg(IDEXBranchReg), 
	.PCS(IDEXPCS), 
	.HLT(IDEXHLT), 
	.LB(IDEXLB), 
	.MemReadorWrite(IDEXMemReadorWrite),
	.memwrite_data(IDEX_b),
	.pc(IDEXpc),
	.WriteEnable(~dcache_stall),
	// Outputs 
	.EXMEMRegDst(EXMEMRegDst), 
	.EXMEMBranch(EXMEMBranch), 
	.EXMEMMemRead(EXMEMMemRead),
	.EXMEMMemtoReg(EXMEMMemtoReg), 
	.EXMEMMemWrite(EXMEMMemWrite), 
	.EXMEMALUSrc(EXMEMALUSrc), 
	.EXMEMRegWrite(EXMEMRegWrite), 
	.EXMEMBranchReg(EXMEMBranchReg), 
	.EXMEMPCS(EXMEMPCS),
	.EXMEMHLT(EXMEMHLT), 
	.EXMEMLB(EXMEMLB), 
	.EXMEMMemReadorWrite(EXMEMMemReadorWrite),
	.EXMEMwrite_data(EXMEMwrite_data),
	.EXMEMalu_out(EXMEMalu_out),
	.EXMEMrd(EXMEMrd),
	.EXMEMrt(EXMEMrt),
	.EXMEMpc(EXMEMpc)
);

/*------------------------------------------------------------*/
/*-------------------------- MEM Stage -----------------------*/
/*--------------------- MEM/WB, and DataMem ------------------*/
/*------------------------------------------------------------*/
wire[15:0] write_data;

cache_control cache(.clk(clk), .rst(~rst_n), .if_stall(if_stall), .mem_stall(mem_stall), .instr_read(1'b1), .instr_write(1'b0), .data_write(EXMEMMemWrite), .data_read(EXMEMMemReadorWrite), 
	.instr_cache_addr(pc_out), .data_cache_addr(EXMEMalu_out), .data_cache_in(write_data), .instr_data_out(imem_out), .data_data_out(dmem_out));


// MEM/WB Pipeline Register
MEM_WB mem_wb(
	// Inputs
	.clk(clk), .rst(~rst_n), 
	.rd(EXMEMrd),
	.alu_out(EXMEMalu_out),
	.dmem_out(dmem_out),
	.RegDst(EXMEMRegDst),
	.Branch(EXMEMBranch), 
	.MemtoReg(EXMEMMemtoReg), 
	.ALUSrc(EXMEMALUSrc), 
	.RegWrite(EXMEMRegWrite), 
	.BranchReg(EXMEMBranchReg), 
	.PCS(EXMEMPCS), 
	.HLT(EXMEMHLT), 
	.LB(EXMEMLB), 
	.pc(EXMEMpc),
	.WriteEnable(~dcache_stall),
	//Outputs
	.MEMWBRegDst(MEMWBRegDst), 
	.MEMWBBranch(MEMWBBranch), 
	.MEMWBMemtoReg(MEMWBMemtoReg), 
	.MEMWBALUSrc(MEMWBALUSrc), 
	.MEMWBRegWrite(MEMWBRegWrite), 
	.MEMWBBranchReg(MEMWBBranchReg), 
	.MEMWBPCS(MEMWBPCS), 
	.MEMWBHLT(MEMWBHLT), 
	.MEMWBLB(MEMWBLB),
	.MEMWBalu_out(MEMWBalu_out), 
	.MEMWBdmem_out(MEMWBdmem_out),
	.MEMWBrd(MEMWBrd),
	.MEMWBpc(MEMWBpc)
);



/*------------------------------------------------------------*/
/*-------------- Forwarding and Hazard Detection -------------*/
/*------------------------------------------------------------*/

wire EXtoEX_A, EXtoEX_B, MEMtoEX_A, MEMtoEX_B, MEMtoMEM;

// Forwarding Unit
fwd_unit fwd_unit(
	// Inputs
	.IDEXrs(IDEXrs), 
	.IDEXrt(IDEXrt), 
	.IDEXrd(IDEXrd),
	.IDEXLB(IDEXLB),
	.EXMEMLB(EXMEMLB),
	.EXMEMrd(EXMEMrd),
	.MEMWBrd(MEMWBrd),
	.EXMEMRegWrite(EXMEMRegWrite),
	.MEMWBRegWrite(MEMWBRegWrite),
	.EXMEMMemWrite(EXMEMMemWrite), 
	.EXMEMrt(EXMEMrt),
	// Outputs
	.EXtoEX_A(EXtoEX_A), 
	.EXtoEX_B(EXtoEX_B), 
	.MEMtoEX_A(MEMtoEX_A), 
	.MEMtoEX_B(MEMtoEX_B), 
	.MEMtoMEM(MEMtoMEM)
);

// Hazard Detection Unit
hazard_detect hazard(
	.IFIDrs(IFIDrs),
	.IFIDrt(IFIDrt), 
	.IFIDrd(IFIDrd), 
	.IDEXrs(IDEXrs), 
	.IDEXrt(IDEXrt), 
	.IDEXrd(IDEXrd), 
	.EXMEMrd(EXMEMrd),
	.if_stall(if_stall),
	.mem_stall(mem_stall), 
	.IDEXRegWrite(IDEXRegWrite), 
	.IDEXMemRead(IDEXMemRead), 
	.EXMEMMemRead(EXMEMMemRead), 
	.IFIDBranch(IFIDBranch), 
	.IFIDMemWrite(IFIDMemWrite), 
	.EXMEMRegWrite(EXMEMRegWrite), 
	.NoOp(NoOp)
);




/*------------------------------------------------------------*/
/*-------------------------- Monkey Muxes --------------------*/
/*------------------------------------------------------------*/


assign write_b = MEMWBMemtoReg ? MEMWBdmem_out : (MEMWBPCS ? MEMWBpc : MEMWBalu_out);

assign alu_in1 = EXtoEX_A ? EXMEMalu_out : (MEMtoEX_A ? write_b : (IDEXLB ? IDEX_b : (IDEXMemReadorWrite ? IDEX_a & 16'hFFFE : IDEX_a)));
// If LW or SW get the 16bit sign extend. If LLB LHB get 8 bit imm, else get rf_d2
assign alu_in2 = (EXtoEX_B & ~IDEXMemWrite) ? EXMEMalu_out : (MEMtoEX_B ? write_b : (IDEXALUSrc ? (IDEXMemReadorWrite ? (IDEXsign_ext_imm << 1) : IDEXsign_ext_imm) : (IDEXLB ? IDEXimm_lb :IDEX_b)));
assign write_data = MEMtoMEM ? write_b : EXMEMwrite_data;
assign hlt = MEMWBHLT;

endmodule
