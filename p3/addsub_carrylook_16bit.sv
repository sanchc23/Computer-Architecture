module addsub_carrylook_16bit(A, B, sub, Sum, Ovfl);

input wire[15:0] A, B;
input wire sub;

output wire[15:0] Sum;
wire[15:0] Saturation_add, Saturation_sub;
output Ovfl;

wire [15:0] B_comp, S;
wire [3:0] carry;

assign B_comp = sub ? ~B : B;

carrylook_4bit c0(.A(A[3:0]), .B(B_comp[3:0]), .Cin(sub), .S(S[3:0]), .Cout(carry[0]));
carrylook_4bit c1(.A(A[7:4]), .B(B_comp[7:4]), .Cin(carry[0]), .S(S[7:4]), .Cout(carry[1]));
carrylook_4bit c2(.A(A[11:8]), .B(B_comp[11:8]), .Cin(carry[1]), .S(S[11:8]), .Cout(carry[2]));
carrylook_4bit c3(.A(A[15:12]), .B(B_comp[15:12]), .Cin(carry[2]), .S(S[15:12]), .Cout(carry[3]));


// check for ovfl
assign  Ovfl = sub ? ((A[15] ^ B[15]) & (A[15] != S[15])) : ((A[15]~^B[15]) & (S[15] != A[15]));

// So we need to check to see if both numbers are Pos & Ovfl then we saturate to the Most Pos Number. 
// If both numbers are Neg and we have overflow then we saturate to the Most Neg Number 
//assign Saturation_add = (A[15] & B[15] & Ovfl) ? 16'h8000 : ((~(A[15] | B[15])) & Ovfl) ? 16'h7FFF : S;


// Subtraction acts differently. If we have a Neg - Pos w/ Ovfl then we have the Most Neg number
// Likewise, Pos - Neg w/ Ovfl then we get the most Pos Number
//assign Saturation_sub = (A[15] & ~B[15] & Ovfl) ? 16'h8000 : ((~A[15] & B[15]) & Ovfl) ? 16'h7FFF : S;

assign Sum = (A[15] & Ovfl) ? 16'h8000 : (~A[15] & Ovfl) ? 16'h7FFF : S;

endmodule
