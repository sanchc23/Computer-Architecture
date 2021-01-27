module full_adder_1bit (Sum, Cout, A, B, Cin);
	input A, B; //Input values
	input Cin; // carry-in bit
	output Sum, Cout; // sum and cout 

	assign Sum = A ^ B ^ Cin;
	assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule

module addsub_4bit (Sum, Ovfl, A, B, sub);
	input [3:0] A, B; //Input values
	input sub; // add-sub indicator
	output [3:0] Sum; //sum output
	output Ovfl; //To indicate overflow

	wire Cout0, Cout1, Cout2;
	wire [3:0] B_com;

	assign B_com = sub ? ~B : B;

	full_adder_1bit FA0 ( .Sum(Sum[0]), .Cout(Cout0), .A(A[0]), .B(B_com[0]), .Cin(sub) );
	full_adder_1bit FA1 ( .Sum(Sum[1]), .Cout(Cout1), .A(A[1]), .B(B_com[1]), .Cin(Cout0) );
	full_adder_1bit FA2 ( .Sum(Sum[2]), .Cout(Cout2), .A(A[2]), .B(B_com[2]), .Cin(Cout1) );
	full_adder_1bit FA3 ( .Sum(Sum[3]), .Cout(), .A(A[3]), .B(B_com[3]), .Cin(Cout2) );

	assign  Ovfl = sub ? ((A[3] ^ B[3]) & (A[3] != Sum[3])) : ((A[3]~^B[3]) & (Sum[3] != A[3]));

endmodule
