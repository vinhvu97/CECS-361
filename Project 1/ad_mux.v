`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: ad_mux.v
// Project: Lab 1
// Created by <Vinh Vu> on <September 22, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: This mux will select what D_out will be, based
// on the select signal which comes from the pixel controller
// to display a hex value from 0 to F. The S is controlled
// by what anode is active at the time.
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module ad_mux(addr, S, D_out, ad_out);

	// Select chooses which input will be assign to the output
	input      [2:0]  S;
	
	// Address input holds 4 sets of 4 bits
	input      [15:0]  addr;
	
	// The 16-bit input has 4 bits for every data 
	input      [15:0] D_out;
	
	// The output carries the addr based on the value of S
	output reg [3:0]  ad_out;
	
	// Always block is executed based on any changes from S, D_out
	// and/or addr. The case statement is solely based on the value
	// of S. 
	always @ (S, D_out, addr) 
		begin
			case (S)
			
				// anode[0], lowest nibble of data out of the RAM
				3'b000: ad_out = D_out [3:0] ;
				
				// anode[1], the next nibble of data out of RAM
				3'b001: ad_out = D_out [7:4] ;
				
				// anode[2], the next nibggle of data out of RAM
				3'b010: ad_out = D_out [11:8] ;
				
				// anode[3], the highest nibble of data out of RAM
				3'b011: ad_out = D_out [15:12] ;
				
				// anode[4], the lowest nibble of the address location
				3'b100: ad_out = addr  [3:0] ;
				
				// anode[5], the next nibble of the address location
				3'b101: ad_out = addr  [7:4] ;
				
				// anode[6], the next nibble of the address location
				3'b110: ad_out = addr  [11:8];
				
				// anode [7], the higest nibble of the address location
				3'b111: ad_out = addr  [15:12];
				
				// default case for hex to be 0 
				default: ad_out = 4'h0;
				
			endcase // end of case statement 
			
		end // end of always block
		
endmodule // end of 8-1 mux