module PADDSB_16bit (A, B, Sum);
input wire[15:0] A, B;
output wire[15:0] Sum;

wire [3:0] s0, s1, s2, s3;
wire [3:0] garbage;
wire [3:0] Overflow;

carrylook_4bit ad0 (.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .S(s0), .Cout(garbage[0]));
carrylook_4bit ad1 (.A(A[7:4]), .B(B[7:4]), .Cin(1'b0), .S(s1), .Cout(garbage[1]));
carrylook_4bit ad2 (.A(A[11:8]), .B(B[11:8]), .Cin(1'b0), .S(s2), .Cout(garbage[2]));
carrylook_4bit ad3 (.A(A[15:12]), .B(B[15:12]), .Cin(1'b0), .S(s3), .Cout(garbage[3]));

// check for ovfl for each 4 bit add
assign Overflow[0] = ((A[3]~^B[3]) & (s0[3] != A[3]));
assign Overflow[1] = ((A[7]~^B[7]) & (s1[3] != A[7]));
assign Overflow[2] = ((A[11]~^B[11]) & (s2[3] != A[11]));
assign Overflow[3] = ((A[15]~^B[15]) & (s3[3] != A[15]));

// We Need to check for saturation for each 4 bit add
// So we need to check to see if both numbers are Pos & Ovfl then we saturate to the Most Pos Number. 
// If both numbers are Neg and we have overflow then we saturate to the Most Neg Number 

assign Sum[3:0] = (A[3] & Overflow[0]) ? 4'b1000 : (~A[3] & Overflow[0]) ? 4'b0111 : s0;
assign Sum[7:4] = (A[7] & Overflow[1]) ? 4'b1000 : (~A[7] & Overflow[1]) ? 4'b0111 : s1;
assign Sum[11:8] = (A[11] & Overflow[2]) ? 4'b1000 : (~A[11] & Overflow[2]) ? 4'b0111 : s2;
assign Sum[15:12] = (A[15] & Overflow[3]) ? 4'b1000 : (~A[15] & Overflow[3]) ? 4'b0111 : s3;


endmodule
