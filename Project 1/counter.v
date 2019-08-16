`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: counter.v
// Project: Lab 1
// Created by <Vinh Vu> on <September 22, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: This module is a 16-bit counter that increments or decrements D 
// depends on the input UHDL. When the sw goes HIGH, the module increments. When
// the sw goes LOW, the module decrements. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module counter(clk , reset , inc_p , UHDL , Q) ; 
	// Input declarations
	input             clk , reset , inc_p , UHDL ;
	
	// Output declaration 
	output reg [15:0] Q   ;
	
	// If reset goes HIGH, Q goes to 0. When reset is off,
	// the input determines whether the module remains, increments,
	// or decrements and output that value Q 
	always @ ( posedge clk , posedge reset )
		if (reset) 
			Q <= 16'b0;
		else
			case ({inc_p, UHDL})
				2'b00: Q <= Q;
				2'b01: Q <= Q;
				2'b10: Q <= Q - 16'b1;
				2'b11: Q <= Q + 16'b1;
			endcase

endmodule // end of counter
