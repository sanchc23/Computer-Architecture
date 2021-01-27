module reduction_unit(S, A, B);
output[15:0] S;
input [15:0] A, B;

wire [11:0] s;
wire [7:0] a, b, c, d;
wire [8:0] e, f;

wire carry_a, carry_c, carry_e1, carry_e2, trash;
assign a = A[7:0];
assign b = B[7:0];
assign c = A[15:8];
assign d = B[15:8];

// First tree to add the LHW of the registers and to create a 9 bit word
carrylook_4bit cla_0(.A(a[3:0]), .B(b[3:0]), .Cin(1'b0), .S(e[3:0]), .Cout(carry_a));
carrylook_4bit cla_1(.A(a[7:4]), .B(b[7:4]), .Cin(carry_a), .S(e[7:4]), .Cout(e[8]));

// Sencond tree to add the UHW of the registers and to create a 9 bit word
carrylook_4bit clc_0(.A(c[3:0]), .B(d[3:0]), .Cin(1'b0), .S(f[3:0]), .Cout(carry_c));
carrylook_4bit clc_1(.A(c[7:4]), .B(d[7:4]), .Cin(carry_c), .S(f[7:4]), .Cout(f[8]));


carrylook_4bit cls_0(.A(e[3:0]), .B(f[3:0]), .Cin(1'b0),     .S(s[3:0]), .Cout(carry_e1));
carrylook_4bit cls_1(.A(e[7:4]), .B(f[7:4]), .Cin(carry_e1), .S(s[7:4]), .Cout(carry_e2));
carrylook_4bit cls_2(.A({3'b0, e[8]}),   .B({3'b0, f[8]}),   .Cin(carry_e2), .S(s[11:8]), .Cout(trash));

assign S[15:0] = { {8{s[8]}}, s[7:4], s[3:0]};

endmodule
