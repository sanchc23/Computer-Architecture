module addsub_carrylook_16bit_tb();

	reg [15:0] A, B;
	wire [15:0] S;
	reg [15:0] correct;
	reg Ovfl; 
	reg sub;
	integer i;
	
	// Create our dut
	addsub_carrylook_16bit iDut (.Sum(S[15:0]), .Ovfl(Ovfl), .A(A[15:0]), .B(B[15:0]), .sub(sub));
	
	initial begin 

	// ADD Tests
	sub = 1'b0;
	for(i = 0; i < 100; i = i + 1) begin 
		A[15:0] = $random;
		B[15:0] = $random;
		correct[15:0] = A[15:0] + B[15:0];  // set a signal to the correct value for comparison
		#5;	// wait 5 time units to propigate through the adder
		
		// check for correct sum and for correct handling of overflow and Saturation

		if(  ((S != correct[15:0]) && !Ovfl) || (((A[15] == B[15]) && (A[15] != correct[15])) && !Ovfl) || (Ovfl & ~(A[15] | B[15]) && S != 16'h7FFF ) || (Ovfl & A[15] & B[15] && S != 16'h8000 )) begin
			$display ("Failure A:%h + B:%h = %h. Output = %h, Ovfl = %1b", A, B, correct, S, Ovfl);
			$stop;  
		end
		else
			$display ("A:%h + B:%h = S:%h. Ovfl = %b", A, B, S, Ovfl);
	end 

	// SUB Tests
	$display("Testing subtraction");
	sub = 1'b1;
	for(i = 0; i < 100; i = i + 1) begin 
		A[15:0] = $random;
		B[15:0] = $random;
		correct[15:0] = A[15:0] - B[15:0]; 
		#5;
		
		// check for correct differnce and for correct handling of overflow and saturation
		if(  ((S != correct[15:0]) && !Ovfl) || (((A[15] != B[15]) && (A[15] != correct[15])) && !Ovfl) || (Ovfl & A[15] & ~B[15] && S != 16'h8000 ) || (Ovfl & ~A[15] & B[15] && S != 16'h7FFF )) begin 
			$display ("Failure A:%h - B:%h = %h. Output = %4h, Ovfl = %1b", A, B, correct, S, Ovfl);
			$stop;  
		end
		else
			$display ("A:%h - B:%h = S:%h. Ovfl = %b", A, B, S, Ovfl);
	end 
	
	$display("Yahoo all tests passed!");
	end
endmodule 
