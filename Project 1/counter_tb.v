`timescale 1ns / 1ps

module counter_tb;

	// Inputs
	reg clk;
	reg reset;
	reg inc_p;
	reg UHDL;

	// Outputs
	wire [15:0] Q;

	// Instantiate the Unit Under Test (UUT)
	counter uut (
		.clk(clk), 
		.reset(reset), 
		.inc_p(inc_p), 
		.UHDL(UHDL), 
		.Q(Q)
	);
	always #5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		$timeformat (-9, 1, " ns", 6);
		
		clk = 0;
		reset = 0;
		inc_p = 0;
		UHDL = 0;

		@ (negedge clk)
			reset = 1;
		@ (negedge clk);
			reset = 0;
	// Increment
		@ (negedge clk)
			{inc_p, UHDL} = 2'b11;
			
		@ (negedge clk)
			{inc_p, UHDL} = 2'b01;
			
		@ (negedge clk)
			{inc_p, UHDL} = 2'b11;

		@ (negedge clk)
			{inc_p, UHDL} = 2'b01;
			
		@ (negedge clk)
			{inc_p, UHDL} = 2'b11;

		@ (negedge clk)
			{inc_p, UHDL} = 2'b01;

		@ (negedge clk)
			{inc_p, UHDL} = 2'b11;
			
		@ (negedge clk)
			{inc_p, UHDL} = 2'b01;

		@ (negedge clk)
			{inc_p, UHDL} = 2'b11;
			
		@ (negedge clk)
			{inc_p, UHDL} = 2'b01;

	
	// Decrement 
		@ (negedge clk)
			{inc_p, UHDL} = 2'b10;
		
		@ (negedge clk)
			{inc_p, UHDL} = 2'b00;
			
		@ (negedge clk)
			{inc_p, UHDL} = 2'b10;
			
		@ (negedge clk)
			{inc_p, UHDL} = 2'b00;

		@ (negedge clk)
			{inc_p, UHDL} = 2'b10;
			
		@ (negedge clk)
			{inc_p, UHDL} = 2'b00;

		@ (negedge clk)
			{inc_p, UHDL} = 2'b10;
			
		@ (negedge clk)
			{inc_p, UHDL} = 2'b00;

		@ (negedge clk)
			{inc_p, UHDL} = 2'b10;
			
		@ (negedge clk)
			{inc_p, UHDL} = 2'b00;
			
		$finish;

	end
      
endmodule

