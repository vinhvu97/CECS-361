`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: ticker.v
// Project: Lab 1
// Created by <Vinh Vu> on <September 22, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: The ticker intakes in the default clock frequency and generate a 
// 10 ms clock. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////
module ticker( clk , reset , tick ) ;
	// Input declarations
	input       clk   , reset ;
	
	// Output declarations
	output      tick  ; 
	
	// Register to hold values for D and count 
	reg  [19:0] count , D ;
	
	// Tick goes high if count counts up to 999,999 in decimal
	assign tick = (count == 20'd999_999);
	
	// If tick goes high, reset D. If tick is not yet high,
	// continue to increment D
	always @ (*)
		if (tick) 
			D = 20'b0;
		else
			D = count + 20'b1;
	
	// If reset goes high, count goes 0. Else count gets D for 
	// incrementing 
	always @ (posedge clk, posedge reset)
		if (reset) 
			count <= 20'b0;
		else
			count <= D;
		
endmodule // end of ticker 
