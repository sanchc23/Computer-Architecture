module IF_ID(
	// Inputs
	clk, rst,
	IF_Instr, 
	br_taken,
	PC_in,
	WriteEnable,
	// Outputs
	ID_Instr,
	IFIDrs, IFIDrt, IFIDrd, IFIDBranch, IFIDBranchReg,
	PC_out,
	IFIDHLT
);

input wire clk, rst, WriteEnable;
input wire br_taken;
input wire[15:0] IF_Instr, PC_in; 

output wire[15:0] ID_Instr, PC_out;
output wire[3:0] IFIDrs, IFIDrt, IFIDrd;
output wire IFIDBranch, IFIDHLT, IFIDBranchReg;

// If the branch is taken signal is high then we flush 
wire[15:0] D;
assign D = br_taken ? 16'h0000 : IF_Instr;

// Flops to hold the current instruction
dff ff[15:0](.q(ID_Instr), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

dff pc[15:0](.q(PC_out), .d(PC_in), .wen(1'b1), .clk(clk), .rst(rst));

assign IFIDBranch = ID_Instr[15:13] == 3'b110 ? 1'b1 : 1'b0;
assign IFIDBranchReg = ID_Instr[15:12] == 4'b1101;
assign IFIDrs = ID_Instr[7:4];
assign IFIDrt = ID_Instr[3:0];
assign IFIDrd = ID_Instr[11:8];
assign IFIDHLT = ID_Instr[15:12] == 4'b1111;
endmodule
