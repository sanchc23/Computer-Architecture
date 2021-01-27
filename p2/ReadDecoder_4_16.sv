module ReadDecoder_4_16 (Wordline, RegId);
input [3:0] RegId;
output [15:0] Wordline;

//RegId = 0000;
assign Wordline[0] = ~RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 0001;
assign Wordline[1] = ~RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];

//RegId = 0010;
assign Wordline[2] = ~RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];

//RegId = 0011;
assign Wordline[3] = ~RegId[3] & ~RegId[2] & RegId[1] & RegId[0];

//RegId = 0100;
assign Wordline[4] = ~RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 0101;
assign Wordline[5] = ~RegId[3] & RegId[2] & ~RegId[1] & RegId[0];

//RegId = 0110;
assign Wordline[6] = ~RegId[3] & RegId[2] & RegId[1] & ~RegId[0];

//RegId = 0111;
assign Wordline[7] = ~RegId[3] & RegId[2] & RegId[1] & RegId[0];

//RegId = 1000;
assign Wordline[8] = RegId[3] & ~RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 1001;
assign Wordline[9] = RegId[3] & ~RegId[2] & ~RegId[1] & RegId[0];

//RegId = 1010;
assign Wordline[10] = RegId[3] & ~RegId[2] & RegId[1] & ~RegId[0];

//RegId = 1011;
assign Wordline[11] = RegId[3] & ~RegId[2] & RegId[1] & RegId[0];

//RegId = 1100;
assign Wordline[12] = RegId[3] & RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 1101;
assign Wordline[13] = RegId[3] & RegId[2] & ~RegId[1] & RegId[0];

//RegId = 1110;
assign Wordline[14] = RegId[3] & RegId[2] & RegId[1] & ~RegId[0];

//RegId = 1111;
assign Wordline[15] = RegId[3] & RegId[2] & RegId[1] & RegId[0];

endmodule