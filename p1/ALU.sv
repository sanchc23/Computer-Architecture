module ALU (ALU_Out, Flag, ALU_In1, ALU_In2, Opcode);
input [15:0] ALU_In1, ALU_In2;
input [3:0] Opcode; 
output reg[15:0] ALU_Out;
output reg[2:0] Flag; // [N:V:Z]

wire Ovfl_addsub, Ovfl_PADDSB;
wire[15:0] L_mask, H_mask, L_b, H_b;

wire sub = (Opcode == 4'b0001);

wire [15:0] Sum_addsub, Sum_PADDSB, Shifted_Val, Sum_RED;

addsub_16bit ALU_addr(.Sum(Sum_addsub), .Ovfl(Ovfl_addsub), .A(ALU_In1), .B(ALU_In2), .sub(sub));

PSA_16bit PADDSB (.Sum(Sum_PADDSB), .Error(Ovfl_PADDSB), .A(ALU_In1), .B(ALU_In2));

Shifter shifter (.Shift_Out(Shifted_Val), .Shift_In(ALU_In1), .Shift_Val(ALU_In2[3:0]), .Mode(Opcode[1:0]));

reduction_unit reduction (.S(Sum_RED), .A(ALU_In1), .B(ALU_In2));


assign L_mask = {8'hFF, 8'h00};
assign L_b    = {8'h00, ALU_In2};
assign H_mask = {8'h00, 8'hFF};
assign H_b    = {ALU_In2, 8'h00};
	always @* case(Opcode)
		// ADD
		0 : begin
			ALU_Out = Sum_addsub;
			Flag[0] = ALU_Out == 16'h0000;
			Flag[1] = Ovfl_addsub;
			Flag[2] = ALU_Out[15];
		end
		
		// SUB
		1 : begin
			ALU_Out = Sum_addsub;
			Flag[0] = ALU_Out == 16'h0000;
			Flag[1] = Ovfl_addsub;
			Flag[2] = ALU_Out[15];
		end

		// XOR
		2 : begin
			ALU_Out = ALU_In1 ^ ALU_In2;
			Flag[0] = ALU_Out == 16'h0000;
		end

		// RED
		3 : begin
			ALU_Out = Sum_RED;
		end

		// SLL
		4 : begin
			ALU_Out = Shifted_Val;
			Flag[0] = ALU_Out == 16'h0000;
		end

		// SRA
		5 : begin
			ALU_Out = Shifted_Val;
			Flag[0] = ALU_Out == 16'h0000;
		end

		// ROR
		6 : begin
			ALU_Out = Shifted_Val;
			Flag[0] = ALU_Out == 16'h0000;
		end

		// PADDSB
		7 : begin
			ALU_Out = Sum_PADDSB;
		end

		// LW
		8 : begin
			ALU_Out = Sum_addsub;
			
		end

		// SW
		9 : begin
			ALU_Out = Sum_addsub;
		end

		// LLB
		10 : begin
			ALU_Out = (ALU_In1 & L_mask) | L_b;
		end

		// LHB
		11 : begin
			ALU_Out = (ALU_In1 & H_mask) | H_b;
		end

		// B
		12 : begin
			
		end

		// BR
		13 : begin
			
		end

		// PCS
		14 : begin
			
		end

		// HLT
		15 : begin
			
		end
	endcase


endmodule
