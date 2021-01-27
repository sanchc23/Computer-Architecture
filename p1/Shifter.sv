module Shifter(Shift_Out, Shift_In, Shift_Val, Mode);
input wire[15:0] Shift_In;  // This is the input data to perform shift operation on
input wire[3:0] Shift_Val;  // Shift amount (used to shift the input data)
input [1:0] Mode;  // To indicate 0 = SLL or 1 = SRA
output wire[15:0] Shift_Out; // Shifted output data

// Registers for assigning outputs depending on the operation
reg[15:0] Arith_Out, Log_Out, ROR_Out;

	// Implements SLL and SRA for every possible shift value 0-15
	always @* case(Shift_Val)
		0 : begin
			Log_Out = Shift_In[15:0];
			Arith_Out = Shift_In[15:0];
			ROR_Out = Shift_In[15:0];
		end

		1 : begin
			Log_Out = {Shift_In[14:0], 1'b0};
			Arith_Out = {Shift_In[15], Shift_In[15:1]};
			ROR_Out = {Shift_In[0], Shift_In[15:1]};
		end

		2 : begin
			Log_Out = {Shift_In[13:0], 2'b0};
			Arith_Out = {{2{Shift_In[15]}}, Shift_In[15:2]};
			ROR_Out = {Shift_In[1:0], Shift_In[15:2]};
		end

		3 : begin
			Log_Out = {Shift_In[12:0], 3'b0};
			Arith_Out = {{3{Shift_In[15]}}, Shift_In[15:3]};
			ROR_Out = {Shift_In[2:0], Shift_In[15:3]};
		end

		4 : begin
			Log_Out = {Shift_In[11:0], 4'b0};
			Arith_Out = {{4{Shift_In[15]}}, Shift_In[15:4]};
			ROR_Out = {Shift_In[3:0], Shift_In[15:4]};
		end

		5 : begin
			Log_Out = {Shift_In[10:0], 5'b0};
			Arith_Out = {{5{Shift_In[15]}}, Shift_In[15:5]};
			ROR_Out = {Shift_In[4:0], Shift_In[15:5]};
		end

		6 : begin
			Log_Out = {Shift_In[9:0], 6'b0};
			Arith_Out = {{6{Shift_In[15]}}, Shift_In[15:6]};
			ROR_Out = {Shift_In[5:0], Shift_In[15:6]};
		end

		7 : begin
			Log_Out = {Shift_In[8:0], 7'b0};
			Arith_Out = {{7{Shift_In[15]}}, Shift_In[15:7]};
			ROR_Out = {Shift_In[6:0], Shift_In[15:7]};
		end

		8 : begin
			Log_Out = {Shift_In[7:0], 8'b0};
			Arith_Out = {{8{Shift_In[15]}}, Shift_In[15:8]};
			ROR_Out = {Shift_In[7:0], Shift_In[15:8]};
		end

		9 : begin
			Log_Out = {Shift_In[6:0], 9'b0};
			Arith_Out = {{9{Shift_In[15]}}, Shift_In[15:9]};
			ROR_Out = {Shift_In[8:0], Shift_In[15:9]};
		end

		10 : begin
			Log_Out = {Shift_In[5:0], 10'b0};
			Arith_Out = {{10{Shift_In[15]}}, Shift_In[15:10]};
			ROR_Out = {Shift_In[9:0], Shift_In[15:10]};

		end

		11 : begin
			Log_Out = {Shift_In[4:0], 11'b0};
			Arith_Out = {{11{Shift_In[15]}}, Shift_In[15:11]};
			ROR_Out = {Shift_In[10:0], Shift_In[15:11]};
		end

		12 : begin
			Log_Out = {Shift_In[3:0], 12'b0};
			Arith_Out = {{12{Shift_In[15]}}, Shift_In[15:12]};
			ROR_Out = {Shift_In[11:0], Shift_In[15:12]};
		end

		13 : begin
			Log_Out = {Shift_In[2:0], 13'b0};
			Arith_Out = {{13{Shift_In[15]}}, Shift_In[15:13]};
			ROR_Out = {Shift_In[12:0], Shift_In[15:13]};
		end

		14 : begin
			Log_Out = {Shift_In[1:0], 14'b0};
			Arith_Out = {{14{Shift_In[15]}}, Shift_In[15:14]};
			ROR_Out = {Shift_In[13:0], Shift_In[15:14]};
		end

		15 : begin
			Log_Out = {Shift_In[0], 15'b0};
			Arith_Out = {{16{Shift_In[15]}}};
			ROR_Out = {Shift_In[14:0], Shift_In[15]};
		end
	endcase
	
	// Assigns output depending on operation
	assign Shift_Out = Mode[1] ? ROR_Out : (Mode[0] ? Arith_Out : Log_Out);

endmodule
