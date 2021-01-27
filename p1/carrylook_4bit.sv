module carrylook_4bit(A, B, Cin, S, Cout);

input wire[3:0] A, B;
input wire Cin;
output wire[3:0] S;
output wire Cout;
wire[3:0] G, P, C;

wire[3:0] empt; // Have an empty connection for cout


full_adder_1bit ad0(.Sum(S[0]), .Cout(empt[0]), .A(A[0]), .B(B[0]), .Cin(C[0]));
full_adder_1bit ad1(.Sum(S[1]), .Cout(empt[1]), .A(A[1]), .B(B[1]), .Cin(C[1]));
full_adder_1bit ad2(.Sum(S[2]), .Cout(empt[2]), .A(A[2]), .B(B[2]), .Cin(C[2]));
full_adder_1bit ad3(.Sum(S[3]), .Cout(empt[3]), .A(A[3]), .B(B[3]), .Cin(C[3]));

// Look ahead logic

assign G = A & B;
assign P = A | B;

assign C[0] = Cin;
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & C[1]);
assign C[3] = G[2] | (P[2] & C[2]);
assign Cout = G[3] | (P[3] & C[3]);



endmodule
