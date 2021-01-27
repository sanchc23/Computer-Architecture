module PADDSB_16bit_tb();

	reg [15:0] A, B;
	wire [15:0] S;
	reg [15:0] correct, before_sat; 
	reg[3:0] Overflow;
	integer i;
	
	// Create our dut
	PADDSB_16bit idut(.A(A), .B(B), .Sum(S));
	initial begin 

	// ADD Tests
	
	for(i = 0; i < 100; i = i + 1) begin 
		A[15:0] = $random;
		B[15:0] = $random;


		before_sat[15:0] = {(A[15:12] + B[15:12]), (A[11:8] + B[11:8]), (A[7:4] + B[7:4]), (A[3:0] + B[3:0])};  // set a signal to the correct value for comparison
		Overflow[0] = ((A[3]~^B[3]) & (before_sat[3] != A[3]));
		Overflow[1] = ((A[7]~^B[7]) & (before_sat[7] != A[7]));
		Overflow[2] = ((A[11]~^B[11]) & (before_sat[11] != A[11]));
		Overflow[3] = ((A[15]~^B[15]) & (before_sat[15] != A[15]));

		correct[3:0] = (A[3] & Overflow[0]) ? 4'b1000 : (~A[3] & Overflow[0]) ? 4'b0111 : before_sat[3:0];
		correct[7:4] = (A[7] & Overflow[1]) ? 4'b1000 : (~A[7] & Overflow[1]) ? 4'b0111 : before_sat[7:4];
		correct[11:8] = (A[11] & Overflow[2]) ? 4'b1000 : (~A[11] & Overflow[2]) ? 4'b0111 : before_sat[11:8];
		correct[15:12] = (A[15] & Overflow[3]) ? 4'b1000 : (~A[15] & Overflow[3]) ? 4'b0111 : before_sat[15:12];
		
		#5;	// wait 5 time units to propigate through the adder
		
		// check for correct sum and for correct handling of overflow
		if((S != correct[15:0])) begin
			$display ("Failure A:%h + B:%h = %h.", A, B, correct);
			$stop;  
		end
		else
			$display ("A:%h + B:%h = S:%h.", A[15:0], B[15:0], S[15:0]);
	end
	$display("Yahoo All Tests Passed!"); 
	end

endmodule
