`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: posedge_detect.v
// Project: Lab 1
// Created by <Vinh Vu> on <September 22, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: The positive edge detect module is designed to detect a positive edge
// input and then returns a one-shot pulse output. If the input is HIGH for first 
// and second clock period, it will output a high one clock period. 
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module posedge_detect(clk , reset , in , ped ) ;

	// Input declarations
	input  clk , reset ;
	input  in  ;
	
	// Output declarations
	output wire ped ;
	
	// Reg declarations 
	reg Q1, Q2;

	// Concatenate two instantiations of 2 D-flops
	// If reset goes high, Q1 and Q2 gets 0. When reset
	// goes low, Q1 gets in and Q2 gets Q1
	always @ (posedge clk, posedge reset)
		if(reset)
			{Q1, Q2} <= 2'b0;
		else
			{Q1, Q2} <= {in, Q1};
	
	// Assign statement that AND Q1 and NOT Q2 
	assign ped = Q1 & ~Q2; 
	
endmodule // end of positive edge detect 
