module WordEnable_3_8(Wordline, RegId);
input [2:0] RegId;
output [7:0] Wordline;

//RegId = 0000;
assign Wordline[0] = ~RegId[2] & ~RegId[1] & ~RegId[0]; 

//RegId = 0001;
assign Wordline[1] = ~RegId[2] & ~RegId[1] & RegId[0]; 

//RegId = 0010;
assign Wordline[2] = ~RegId[2] & RegId[1] & ~RegId[0]; 

//RegId = 0011;
assign Wordline[3] = ~RegId[2] & RegId[1] & RegId[0];

//RegId = 0100;
assign Wordline[4] = RegId[2] & ~RegId[1] & ~RegId[0];

//RegId = 0101;
assign Wordline[5] = RegId[2] & ~RegId[1] & RegId[0];

//RegId = 0110;
assign Wordline[6] = RegId[2] & RegId[1] & ~RegId[0];

//RegId = 0111;
assign Wordline[7] = RegId[2] & RegId[1] & RegId[0];

endmodule
