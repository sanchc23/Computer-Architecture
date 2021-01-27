module cpu(pc_out, hlt, clk, rst_n);
input clk, rst_n;
output hlt;
output[15:0] pc_out;

// INTERCONNECTS
wire[2:0] Flag;
wire[2:0] condition;
wire[3:0] opcode, rd, rs, rt, imm;
wire[8:0] offset, imm_lb;
wire[15:0] rf_d1, rf_d2; // Register file outputs
wire[15:0] dmem_out, imem_out; // Memory outputs
wire[15:0] sign_ext_imm;
wire[15:0] write_b, alu_in1, alu_in2, alu_out, pc_in, curr_instr; // ALU, write back and instructions

// CONTROL SIGNALS
wire RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, BranchReg, PCS, HLT, LB, MemReadorWrite;

// Get values from current instruction
assign curr_instr = imem_out;
assign opcode = curr_instr[15:12];
assign rd	  = curr_instr[11:8];
assign rs	  = curr_instr[7:4];
assign rt 	  = ~RegDst ? curr_instr[11:8]: curr_instr[3:0];
assign imm 	  = curr_instr[3:0];
assign sign_ext_imm = {{12{imm[3]}}, imm};
assign imm_lb	  = curr_instr[7:0];
assign offset = curr_instr[8:0];
assign condition = curr_instr[11:9];



// MONKEY MUXES
assign write_b = MemtoReg ? dmem_out : (PCS ? pc_in : alu_out);
assign alu_in1 = LB ? rf_d2 : (MemReadorWrite ? rf_d1 & 16'hFFFE : rf_d1);
// If LW or SW get the 16bit sign extend. If LLB LHB get 8 bit imm, else get rf_d2
assign alu_in2 = ALUSrc ? (MemReadorWrite ? (sign_ext_imm << 1) : sign_ext_imm) : (LB ? imm_lb :rf_d2);
assign hlt = HLT;

// MODULES

// Control unit
control_unit ctrl_unit(.RegDst(RegDst), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite),
					   .ALUSrc(ALUSrc), .RegWrite(RegWrite), .BranchReg(BranchReg), .PCS(PCS), .LB(LB), .HLT(HLT), 
					   .opcode(opcode), .MemReadorWrite(MemReadorWrite));
// FIX WR SET TO 1'B0
// Instruction memory
memory1c instr_mem(.data_out(imem_out), .data_in(), .addr(pc_out), .enable(1'b1), 
				   .wr(1'b0), .clk(clk), .rst(~rst_n)); 

// Data memory
memory1c data_mem(.data_out(dmem_out), .data_in(rf_d2), .addr(alu_out), .enable(MemReadorWrite), 
				  .wr(MemWrite), .clk(clk), .rst(~rst_n)); 

// Register File
RegisterFile rgFile(.SrcData1(rf_d1), .SrcData2(rf_d2), .clk(clk), .rst(~rst_n), .SrcReg1(rs), .SrcReg2(rt),
					.DstReg(rd), .WriteReg(RegWrite), .DstData(write_b));


// PC register
PC pc (.clk(clk), .rst(~rst_n), .PC_In(pc_in), .PC_Out(pc_out), .PC_en(1'b1));



// PC_control
// PC_in is pc_out because we need current value of pc
PC_control pc_ctrl(.C(condition), .I(offset), .F(Flag), .PC_in(pc_out), .reg_target(rf_d1),
				   .br(Branch), .breg(BranchReg), .PC_out(pc_in), .HLT(HLT), .rst_n(rst_n));

// ALU
ALU ALU(.ALU_Out(alu_out), .Flag(Flag), .ALU_In1(alu_in1), .ALU_In2(alu_in2), .Opcode(opcode));



endmodule