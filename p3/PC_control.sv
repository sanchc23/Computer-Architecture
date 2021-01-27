module PC_control(C, I, F, PC_in, reg_target, br, breg, PC_out, HLT, rst_n, br_taken);

	output [15:0] PC_out;
	input wire HLT, rst_n;
	input [2:0] C, F;
	input [8:0] I;
	input [15:0] PC_in;
	input [15:0] reg_target;
	input br, breg;
	
	wire [15:0] pc_plus_target;

	//addsub_16bit addr1 (.Sum(pc_plus_2), .Ovfl(), .A(PC_in), .B(16'd2), .sub(1'b0));
	// PC+2 IS NOW HANDLED IN CPU before the ID_IF register
	addsub_16bit addr2 (.Sum(pc_plus_target), .Ovfl(), .A(PC_in), .B( {{7{I[8]}}, I << 1} ), .sub(1'b0));

	// F[2:0] => N, V, Z
	output reg br_taken;
	always @* case(C)
		3'b000: assign br_taken = ~F[0] & br;
		3'b001: assign br_taken = F[0] & br;
		3'b010: assign br_taken = ~F[0] & ~F[2] & br;
		3'b011: assign br_taken = F[2]  & br;
		3'b100: assign br_taken = (F[0] & br) | (~(F[0] | F[2])  & br);
		3'b101: assign br_taken = (F[0] | F[2])  & br;
		3'b110: assign br_taken = F[1]  & br;
		3'b111: assign br_taken = 1 & br;
	endcase

	// PC_out will either be the register target or the Immediate target
	assign PC_out = breg ? reg_target : pc_plus_target;  
	
// NEED TO FIX THIS TO REMOVE PC_PLUS_2
//assign PC_out = (HLT ? PC_in : (br_taken ? (breg ? reg_target : pc_plus_target) : pc_plus_2));

endmodule