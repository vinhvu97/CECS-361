`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: display_controller.v
// Project: Lab 1
// Created by <Vinh Vu> on <September 22, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: This is the display controller module used to tie all the features of
// 			the display controller in Lab 4 together. This module implements and 
//				instantiates the pixel_controller, ad_mux(8-1-Mux), and 
//				Hex_to_7seg module. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module display_controller(clk, reset,addr, D_out, anode, a, b, c, d, e, f, g);

    // Input declarations
    input 		   clk , reset ;
    input  [15:0] addr ;
    input  [15:0] D_out ;

    // Output declarations
    output [7:0] anode;
    output       a , b , c , d , e , f , g ;

    // Temp wires to pass binary data from module to modules
    wire   [2:0] S;
    wire   [3:0] mux_wire;
	
	// Instantiate Pixel Controller
   // A Finite State Machine(FSM) counting up states
   // and outputs a select variable(S) that sends 
	// 3-bits of data to the 8-1 mux module to perform data selection on 
	// which inputs are to be selected in order to be represented on the display
    pixel_controller controller0 (.clk(clk) , 
										    .reset(reset) , 
											 .S(S) , 
											 .anode(anode)) ;

    // Instantiates an address mux that sends 4-bit value to the 7 segment
	 // module. This 8-1 mux sends a nibble(4-bits) to the 
	 // Hex_to_7seg module to choose the correct segments to display on the board
	 ad_mux           mux0        (.addr(addr) , 
											 .S(S) , 
											 .D_out(D_out) , 
											 .ad_out(mux_wire)) ;


    // Instantiate the hex to 7 segment to display the values onto the board 
    hex_to_7seg      hex7        (.hex(mux_wire), 
											 .a(a) , .b(b) , .c(c) , .d(d) , 
											 .e(e) , .f(f) , .g(g));

endmodule // end of display controller module