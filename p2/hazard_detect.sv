module hazard_detect(IFIDrs, IFIDrt, IFIDrd, IDEXrs, IDEXrt, IDEXrd, EXMEMrd, IDEXRegWrite, IDEXMemRead, 
EXMEMMemRead, IFIDBranch, IFIDMemWrite, EXMEMRegWrite, NoOp);

input wire[3:0] IFIDrs, IFIDrt, IFIDrd, IDEXrs, IDEXrt, IDEXrd, EXMEMrd;
input IDEXMemRead, IDEXRegWrite, IFIDBranch, IFIDMemWrite, EXMEMRegWrite, EXMEMMemRead; // control signals - idk if this is necessary
output NoOp;

wire LoadStall, BranchStall;

assign LoadStall = ((IDEXMemRead) & (IDEXrd != 0) & ((IDEXrd == IFIDrs) | (~(IFIDMemWrite) & (IDEXrd == IFIDrt))));

assign BranchStall = ((IFIDBranch & IDEXRegWrite) & (IDEXrd != 0) & ((IDEXrd == IFIDrs) | (IDEXrd == IFIDrt))) |
	((EXMEMMemRead & IFIDBranch) & (EXMEMrd != 0) & ((EXMEMrd == IFIDrs) | (EXMEMrd == IFIDrt))); 

assign NoOp = LoadStall | BranchStall;

endmodule