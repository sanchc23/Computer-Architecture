module hazard_detect(IFIDrs, IFIDrt, IFIDrd, IDEXrs, IDEXrt, IDEXrd, EXMEMrd, IDEXRegWrite, IDEXMemRead, 
EXMEMMemRead, IFIDBranch, IFIDMemWrite, EXMEMRegWrite, LoadStall, BranchStall, LoadBranchStall, NoOp);

input IFIDrs, IFIDrt, IFIDrd, IDEXrs, IDEXrt, IDEXrd, EXMEMrd;
input IDEXMemRead, IDEXRegWrite, IFIDBranch, IFIDMemWrite, EXMEMRegWrite, EXMEMMemRead; // control signals - idk if this is necessary
output LoadStall, BranchStall, LoadBranchStall;
output [1:0] NoOp;

assign LoadStall = ((IDEXMemRead) & (IDEXrd != 0) & ((IDEXrd == IFIDrs) | (~(IFIDMemWrite) & (IDEXrd == IFIDrt))));

assign BranchStall = ((IFIDBranch & IDEXRegWrite) & (IDEXrd != 0) & ((IDEXrd == IFIDrs) | (IDEXrd == IFIDrt))) |
	((EXMEMMemRead & IFIDBranch) & (EXMEMrd != 0) & ((EXMEMrd == IFIDrs) | (EXMEMrd == IFIDrt))); 

assign LoadBranchStall = LoadStall & BranchStall;

assign NoOp = LoadBranchStall ? 2'b10 : (LoadStall | BranchStall) ? 2'b01 : 2'b00; 

endmodule