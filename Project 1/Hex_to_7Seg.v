`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: hex_to_7seg.v
// Project: Lab 1
// Created by <Vinh Vu> on <September 22, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: This hex_to_7Seg module essentially takes in a four-bit(nibble) input,
//				converts the input information by selecting the correct corresponding 
//				segments (a-g) on the seven segment LED display in order to represent 
//				that four-bit input integer. This method was completed by using 
//				case-statements for all of the appropriate four-bit input options
//				from 0-F and assigning the correct values of a-g to later display. 
//				A 0 is on and a 1 is off for the LED segments. 
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module hex_to_7seg(hex, a, b, c, d, e, f, g);

   // Input and output declarations
	input      [3:0] hex ;
	output reg       a , b , c , d , e , f , g ;
	
	always @ (hex)
	
      /***********************************************
		* The four-bit hex input from 0-F is specified
		* by 4'h0 to 4'hF. The case statement is used to
		* decode each hex value in order to choose the
		* correct LED is on for that specific hex value. 
		***********************************************/
		case(hex)
		
			 // 7-segment display for 0-3
          4'h0: {a, b, c, d, e, f, g} = 7'b0000001; // 0
          4'h1: {a, b, c, d, e, f, g} = 7'b1001111; // 1
          4'h2: {a, b, c, d, e, f, g} = 7'b0010010; // 2
          4'h3: {a, b, c, d, e, f, g} = 7'b0000110; // 3
			 
          // 7-segment display for 4-7
          4'h4: {a, b, c, d, e, f, g} = 7'b1001100; // 4
          4'h5: {a, b, c, d, e, f, g} = 7'b0100100; // 5
          4'h6: {a, b, c, d, e, f, g} = 7'b0100000; // 6
          4'h7: {a, b, c, d, e, f, g} = 7'b0001111; // 7
			 
          // 7-segment display for 8-B
          4'h8: {a, b, c, d, e, f, g} = 7'b0000000; // 8
          4'h9: {a, b, c, d, e, f, g} = 7'b0000100; // 9
          4'hA: {a, b, c, d, e, f, g} = 7'b0001000; // A
          4'hB: {a, b, c, d, e, f, g} = 7'b1100000; // B
			 
          // 7-segment display for C-F
          4'hC: {a, b, c, d, e, f, g} = 7'b0110001; // C
          4'hD: {a, b, c, d, e, f, g} = 7'b1000010; // D
          4'hE: {a, b, c, d, e, f, g} = 7'b0110000; // E
          4'hF: {a, b, c, d, e, f, g} = 7'b0111000; // F
			 
          // default display if other cases do not apply
          default: {a, b, c, d, e, f, g} = 7'b0110111; 
			 
      endcase // endcase 
	
endmodule // end of hex_to7seg module