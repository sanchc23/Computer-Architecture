module full_adder_1bit (Sum, Cout, A, B, Cin);
	input A, B; //Input values
	input Cin; // carry-in bit
	output Sum, Cout; // sum and cout 

	assign Sum = A ^ B ^ Cin;
	assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule

module addsub_16bit (Sum, Ovfl, A, B, sub);
	input [15:0] A, B; //Input values
	input sub; // add-sub indicator
	output [15:0] Sum; //sum output
	output Ovfl; //To indicate overflow
	wire [15:0] s; 

	wire [15:0] B_com, co;

	assign B_com = sub ? ~B : B;

	full_adder_1bit fa0 ( .Sum(s[0]), .Cout(co[0]), .A(A[0]), .B(B_com[0]), .Cin(sub) );
	full_adder_1bit a[14:0] (.Sum(s[15:1]), .Cout(co[15:1]), .A(A[15:1]), .B(B_com[15:1]), .Cin(co[14:0]) );
	

	assign  Ovfl = sub ? ((A[15] ^ B[15]) & (A[15] != s[15])) : ((A[15]~^B[15]) & (s[15] != A[15]));

	// This saturates the output of our adder
	// This is an example of negative overflow since msb are 1 and ovfl flag is high
	// We then check for positive overflow since msb are equal to 0 and ovfl flag means positive ovfl
	assign Sum = (A[15] & B[15] & Ovfl) ? 16'h8000 : ((~(A[15] | B[15])) & Ovfl) ? 16'h7FFF : s;

endmodule
