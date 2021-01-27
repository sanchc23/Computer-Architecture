module ReadDecoder_6_64 (Wordline, RegId);
input [5:0] RegId;
output [63:0] Wordline;


//RegId = 000000;
assign Wordline[0] = ~RegId[5] & ~RegId[4] & ~RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 000001;
assign Wordline[1] = ~RegId[5] & ~RegId[4] & ~RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];

//RegId = 000010;
assign Wordline[2] = ~RegId[5] & ~RegId[4] & ~RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];

//RegId = 000011;
assign Wordline[3] = ~RegId[5] & ~RegId[4] & ~RegId[3] & ~RegId[2] & RegId[1] & RegId[0];

//RegId = 000100;
assign Wordline[4] = ~RegId[5] & ~RegId[4] & ~RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 000101;
assign Wordline[5] = ~RegId[5] & ~RegId[4] & ~RegId[3] & RegId[2] & ~RegId[1] & RegId[0];

//RegId = 000110;
assign Wordline[6] = ~RegId[5] & ~RegId[4] & ~RegId[3] & RegId[2] & RegId[1] & ~RegId[0];

//RegId = 000111;
assign Wordline[7] = ~RegId[5] & ~RegId[4] & ~RegId[3] & RegId[2] & RegId[1] & RegId[0];

//RegId = 001000;
assign Wordline[8] = ~RegId[5] & ~RegId[4] & RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 001001;
assign Wordline[9] = ~RegId[5] & ~RegId[4] &  RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];

//RegId = 001010;
assign Wordline[10] = ~RegId[5] & ~RegId[4] & RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];

//RegId = 001011;
assign Wordline[11] = ~RegId[5] & ~RegId[4] & RegId[3] & ~RegId[2] & RegId[1] & RegId[0];

//RegId = 001100;
assign Wordline[12] = ~RegId[5] & ~RegId[4] & RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 001101;
assign Wordline[13] = ~RegId[5] & ~RegId[4] & RegId[3] & RegId[2] & ~RegId[1] & RegId[0];

//RegId = 001110;
assign Wordline[14] = ~RegId[5] & ~RegId[4] & RegId[3] & RegId[2] & RegId[1] & ~RegId[0];

//RegId = 001111;
assign Wordline[15] = ~RegId[5] & ~RegId[4] & RegId[3] & RegId[2] & RegId[1] & RegId[0];

//RegId = 010000;
assign Wordline[16] = ~RegId[5] & RegId[4] & ~RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 010001;
assign Wordline[17] = ~RegId[5] & RegId[4] & ~RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];

//RegId = 010010;
assign Wordline[18] = ~RegId[5] & RegId[4] & ~RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];

//RegId = 010011;
assign Wordline[19] = ~RegId[5] & RegId[4] & ~RegId[3] & ~RegId[2] & RegId[1] & RegId[0];

//RegId = 010100;
assign Wordline[20] = ~RegId[5] & RegId[4] & ~RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 010101;
assign Wordline[21] = ~RegId[5] & RegId[4] & ~RegId[3] & RegId[2] & ~RegId[1] & RegId[0];

//RegId = 010110;
assign Wordline[22] = ~RegId[5] & RegId[4] & ~RegId[3] & RegId[2] & RegId[1] & ~RegId[0];

//RegId = 010111;
assign Wordline[23] = ~RegId[5] & RegId[4] & ~RegId[3] & RegId[2] & RegId[1] & RegId[0];

//RegId = 011000;
assign Wordline[24] = ~RegId[5] & RegId[4] & RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 011001;
assign Wordline[25] = ~RegId[5] & RegId[4] &  RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];

//RegId = 011010;
assign Wordline[26] = ~RegId[5] & RegId[4] & RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];

//RegId = 011011;
assign Wordline[27] = ~RegId[5] & RegId[4] & RegId[3] & ~RegId[2] & RegId[1] & RegId[0];

//RegId = 011100;
assign Wordline[28] = ~RegId[5] & RegId[4] & RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 011101;
assign Wordline[29] = ~RegId[5] & RegId[4] & RegId[3] & RegId[2] & ~RegId[1] & RegId[0];

//RegId = 011110;
assign Wordline[30] = ~RegId[5] & RegId[4] & RegId[3] & RegId[2] & RegId[1] & ~RegId[0];

//RegId = 011111;
assign Wordline[31] = ~RegId[5] & RegId[4] & RegId[3] & RegId[2] & RegId[1] & RegId[0];

//RegId = 100000;
assign Wordline[32] = RegId[5] & ~RegId[4] & ~RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 100001;
assign Wordline[33] = RegId[5] & ~RegId[4] & ~RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];

//RegId = 100010;
assign Wordline[34] = RegId[5] & ~RegId[4] & ~RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];

//RegId = 100011;
assign Wordline[35] = RegId[5] & ~RegId[4] & ~RegId[3] & ~RegId[2] & RegId[1] & RegId[0];

//RegId = 100100;
assign Wordline[36] = RegId[5] & ~RegId[4] & ~RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 100101;
assign Wordline[37] = RegId[5] & ~RegId[4] & ~RegId[3] & RegId[2] & ~RegId[1] & RegId[0];

//RegId = 100110;
assign Wordline[38] = RegId[5] & ~RegId[4] & ~RegId[3] & RegId[2] & RegId[1] & ~RegId[0];

//RegId = 100111;
assign Wordline[39] = RegId[5] & ~RegId[4] & ~RegId[3] & RegId[2] & RegId[1] & RegId[0];

//RegId = 101000;
assign Wordline[40] = RegId[5] & ~RegId[4] & RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 101001;
assign Wordline[41] = RegId[5] & ~RegId[4] &  RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];

//RegId = 101010;
assign Wordline[42] = RegId[5] & ~RegId[4] & RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];

//RegId = 101011;
assign Wordline[43] = RegId[5] & ~RegId[4] & RegId[3] & ~RegId[2] & RegId[1] & RegId[0];

//RegId = 101100;
assign Wordline[44] = RegId[5] & ~RegId[4] & RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 101101;
assign Wordline[45] = RegId[5] & ~RegId[4] & RegId[3] & RegId[2] & ~RegId[1] & RegId[0];

//RegId = 101110;
assign Wordline[46] = RegId[5] & ~RegId[4] & RegId[3] & RegId[2] & RegId[1] & ~RegId[0];

//RegId = 101111;
assign Wordline[47] = RegId[5] & ~RegId[4] & RegId[3] & RegId[2] & RegId[1] & RegId[0];

//RegId = 110000;
assign Wordline[48] = RegId[5] & RegId[4] & ~RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 110001;
assign Wordline[49] = RegId[5] & RegId[4] & ~RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];

//RegId = 110010;
assign Wordline[50] = RegId[5] & RegId[4] & ~RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];

//RegId = 110011;
assign Wordline[51] = RegId[5] & RegId[4] & ~RegId[3] & ~RegId[2] & RegId[1] & RegId[0];

//RegId = 110100;
assign Wordline[52] = RegId[5] & RegId[4] & ~RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 110101;
assign Wordline[53] = RegId[5] & RegId[4] & ~RegId[3] & RegId[2] & ~RegId[1] & RegId[0];

//RegId = 110110;
assign Wordline[54] = RegId[5] & RegId[4] & ~RegId[3] & RegId[2] & RegId[1] & ~RegId[0];

//RegId = 110111;
assign Wordline[55] = RegId[5] & RegId[4] & ~RegId[3] & RegId[2] & RegId[1] & RegId[0];

//RegId = 111000;
assign Wordline[56] = RegId[5] & RegId[4] & RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 111001;
assign Wordline[57] = RegId[5] & RegId[4] &  RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];

//RegId = 111010;
assign Wordline[58] = RegId[5] & RegId[4] & RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];

//RegId = 111011;
assign Wordline[59] = RegId[5] & RegId[4] & RegId[3] & ~RegId[2] & RegId[1] & RegId[0];

//RegId = 111100;
assign Wordline[60] = RegId[5] & RegId[4] & RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 111101;
assign Wordline[61] = RegId[5] & RegId[4] & RegId[3] & RegId[2] & ~RegId[1] & RegId[0];

//RegId = 111110;
assign Wordline[62] = RegId[5] & RegId[4] & RegId[3] & RegId[2] & RegId[1] & ~RegId[0];

//RegId = 111111;
assign Wordline[63] = RegId[5] & RegId[4] & RegId[3] & RegId[2] & RegId[1] & RegId[0];


endmodule
