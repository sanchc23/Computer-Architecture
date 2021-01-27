module RegisterFile (SrcData1, SrcData2, clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData);
input clk, rst, WriteReg;
input[3:0] SrcReg1, SrcReg2, DstReg;
input[15:0] DstData;
inout[15:0] SrcData1, SrcData2;

wire[15:0] r_word_1, r_word_2, w_word, data_1, data_2;

// Don't need this for single cycle processor
assign SrcData1 = (DstReg == SrcReg1) ? (WriteReg ? DstData : data_1) : data_1;
assign SrcData2 = (DstReg == SrcReg2) ? (WriteReg ? DstData : data_2) : data_2;

ReadDecoder_4_16 r_decode1(.Wordline(r_word_1), .RegId(SrcReg1));
ReadDecoder_4_16 r_decode2(.Wordline(r_word_2), .RegId(SrcReg2));
WriteDecoder_4_16 w_decode(.Wordline(w_word), .RegId(DstReg), .WriteReg(WriteReg));

Register r[14:0](.Bitline1(data_1), .Bitline2(data_2), .clk(clk), .rst(rst), .D(DstData), 
			.WriteReg(w_word[15:1]), .ReadEnable1(r_word_1[15:1]), .ReadEnable2(r_word_2[15:1]));
			
// Hardline this bad boy to 0
// Refuse to ever write to this so it can never be anything but 0
Register hard(.Bitline1(data_1), .Bitline2(data_2), .clk(clk), .rst(rst), .D(DstData), 
			.WriteReg(1'b0), .ReadEnable1(r_word_1[0]), .ReadEnable2(r_word_2[0]));

endmodule