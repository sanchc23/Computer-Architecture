module PSA_16bit (Sum, Error, A, B);
input [15:0] A, B; 	// Input data values
output [15:0] Sum; 	// Sum output
output Error; 	// To indicate overflows

wire [3:0] s0, s1, s2, s3;
wire [3:0] Overflow;

addsub_4bit add0(.Sum(s0[3:0]), .Ovfl(Overflow[0]), .A(A[3:0]), .B(B[3:0]), .sub(1'b0));
addsub_4bit add1(.Sum(s1[3:0]), .Ovfl(Overflow[1]), .A(A[7:4]), .B(B[7:4]), .sub(1'b0));
addsub_4bit add2(.Sum(s2[3:0]), .Ovfl(Overflow[2]), .A(A[11:8]), .B(B[11:8]), .sub(1'b0));
addsub_4bit add3(.Sum(s3[3:0]), .Ovfl(Overflow[3]), .A(A[15:12]), .B(B[15:12]), .sub(1'b0));

assign Sum[3:0] = (A[3] & B[3] & Overflow[0]) ? 4'b1000 : ((~(A[3] | B[3])) & Overflow[0]) ? 4'b0111 : s0;
assign Sum[7:4] = (A[7] & B[7] & Overflow[1]) ? 4'b1000 : ((~(A[7] | B[7])) & Overflow[1]) ? 4'b0111 : s1;
assign Sum[11:8] = (A[11] & B[11] & Overflow[2]) ? 4'b1000 : ((~(A[11] | B[11])) & Overflow[2]) ? 4'b0111 : s2;
assign Sum[15:12] = (A[15] & B[15] & Overflow[3]) ? 4'b1000 : ((~(A[15] | B[15])) & Overflow[3]) ? 4'b0111 : s3;


assign Error = |Overflow;

endmodule
