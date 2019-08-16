`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: top_tbl.v
// Project: Lab 1
// Created by <Vinh Vu> on <September 22, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
// 
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////
module top_tb;

	// Inputs
	reg clk;
	reg reset_button;
	reg db_button;
	reg sw_uhdl;

	// Outputs
	wire [7:0] anode;
	wire a;
	wire b;
	wire c;
	wire d;
	wire e;
	wire f;
	wire g;

	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk(clk), 
		.anode(anode), 
		.reset_button(reset_button), 
		.db_button(db_button), 
		.sw_uhdl(sw_uhdl), 
		.a(a), 
		.b(b), 
		.c(c), 
		.d(d), 
		.e(e), 
		.f(f), 
		.g(g)
	);

	always #5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		db_button = 0;
		reset_button = 1;
		sw_uhdl = 0;
		

		#100 reset_button = 0;
        
		#100 db_button = 1;
		sw_uhdl = 1;
		
		#40_000_000; 
		
	end 
      
endmodule

