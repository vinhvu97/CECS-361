`timescale 1ns / 1ps

module debounce_tb;

	// Inputs
	reg clk;
	reg reset;
	reg in;

	// Outputs
	wire p_out;

	// Instantiate the Unit Under Test (UUT)
	debounce uut (
		.clk(clk), 
		.reset(reset), 
		.in(in), 
		.p_out(p_out)
	);
	
	always #5 clk = ~clk; 
	initial begin
		// Initialize Inputs
		$timeformat (-9, 1, " ns", 6);
		
		clk = 0;
		reset = 0;
		in = 0;

		@ (negedge clk)
			reset = 1;
		@ (negedge clk);
			reset = 0;
			
		// Moving the FSM to state 4; 
		@ (negedge clk)
			in = 1;
			
		#500
		
		$finish;
	end
      
endmodule

