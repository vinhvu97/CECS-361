`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: AISO.v
// Project: Lab 1
// Created by <Vinh Vu> on <September 22, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: This is an Asynchronous In Synchronous Out module. The purpose of 
// this module is to synchronize the release of reset. Once the reset button
// is released, reset is turn off synchronously. 
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module AISO ( clk , reset , reset_sync ) ;
	// Input declarations
	input      clk       , reset;
	
	// Output declaration
	output   wire  reset_sync;
	
	// Wire declarations to interconnect
	reg Q1 , Q2 ;
	
	// Sequential block to instantiate two d-flops 
	// As soon as reset go to 1, Q goes to 0, and 
	// get inverted to output a 1
	always @ (posedge clk, posedge reset)
		if (reset)
			{Q1, Q2} <= 2'b0;
		else
			{Q1, Q2} <= {1'b1, Q1};
	
	// Assign statement to invert the output to be a 1
	assign reset_sync = ~Q2;

endmodule //end of AISO
