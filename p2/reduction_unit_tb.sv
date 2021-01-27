module reduction_unit_tb();

	reg [15:0] A, B;
	wire [15:0] S;
	reg [15:0] correct;
	reg [8:0] e, f;
	reg [8:0] g;

	integer i;
	
	// Create our dut
	reduction_unit idut(.A(A), .B(B), .S(S));
	initial begin 

	// ADD Tests
	
	for(i = 0; i < 100; i = i + 1) begin 
		A[15:0] = $random;
		B[15:0] = $random;
		e = A[7:0] + B[7:0];
		f = A[15:8] + B[15:8];
		g = e + f;
		correct = { {7{g[8]}}, g};
		#5;	// wait 5 time units to propigate through the adder
		
		// check for correct sum and for correct handling of overflow
		if((S != correct)) begin
			$display ("Failure A:%h + B:%h = %h.", A, B, correct);
			$stop;  
		end
		else
			$display ("A:%h + B:%h = S:%h.", A[15:0], B[15:0], S[15:0]);
	end
	$display("Yahoo All Tests Passed!"); 
	end



endmodule
