module fwd_unit (
	EXtoEX_A, 
	EXtoEX_B, 
	MEMtoEX_A, 
	MEMtoEX_B,
	MEMtoMEM,
				EXMEMLB, IDEXLB, IDEXrs, IDEXrt, IDEXrd, EXMEMrd, EXMEMRegWrite,
				MEMWBrd, MEMWBRegWrite, EXMEMMemWrite, EXMEMrt);

output wire EXtoEX_A, EXtoEX_B, MEMtoEX_A, MEMtoEX_B, MEMtoMEM;
input wire[3:0] IDEXrs, IDEXrt, IDEXrd, EXMEMrd, EXMEMrt, MEMWBrd;
input wire EXMEMLB, IDEXLB;
output wire EXMEMRegWrite, EXMEMMemWrite, MEMWBRegWrite;

assign EXtoEX_A = (EXMEMRegWrite) & ((IDEXrs == EXMEMrd) | (EXMEMLB & IDEXLB & (IDEXrt == EXMEMrd))) & (EXMEMrd != 0);
assign EXtoEX_B = (EXMEMRegWrite) & (IDEXrt == EXMEMrd) & (EXMEMrd != 0) & ~IDEXLB;

assign MEMtoEX_A = (MEMWBRegWrite) & (IDEXrs == MEMWBrd) & (MEMWBrd != 0)
					& ~( EXMEMRegWrite & EXMEMrd != 0 & (IDEXrs == EXMEMrd) );
assign MEMtoEX_B = (MEMWBRegWrite) & (IDEXrt == MEMWBrd) & (MEMWBrd != 0)
					& ~( EXMEMRegWrite & EXMEMrd != 0 & (IDEXrt == EXMEMrd) ) & ~IDEXLB;

assign MEMtoMEM = EXMEMMemWrite & MEMWBRegWrite & (MEMWBrd != 0) & (MEMWBrd == EXMEMrt);

endmodule 