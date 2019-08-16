`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: top_level.v
// Project: Lab 1
// Created by <Vinh Vu> on <September 22, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: This is the top level module for lab 1 to tie together all of the 
// created modules for the lab. Lab 1's purpose is to increment or decrement 
// a value based on the switch inputs. This top level implements AISO, debounce, 
// posedge_detect, counter, and display_controller to load and display onto the
// Nexys4DDR FPGA board. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module top_level(clk , anode , reset_button , db_button, sw_uhdl , 
	              a , b , c , d , e , f , g ) ;
	// Input and output declarations
	input        clk  , reset_button , db_button , sw_uhdl ;
	output [7:0] anode;
	output       a , b , c , d , e , f , g ;
	
	// Wire initiations to interconnect the modules
	wire         reset , tick , p_o , ped ; 
	wire [15:0]  count ;
	
	// Instantiate Asynchronous In Synchrnous Out module
	// to synchronize the release of reset
	AISO               reset_sync0(.clk(clk), 
											 .reset(reset_button), 
											 .reset_sync(reset));
											 
	// Instantiate debounce module to generate a stable
	// signal. Any transition less than 20ms is ignored 
	debounce           bounce0    (.clk(clk), 
									       .reset(reset), 
								   		 .in(db_button), 
									    	 .p_out(p_o));
	
	// Instantiate posedge_detect module to detect the 
	// positive edge of the clock
	posedge_detect     ped0       (.clk(clk), 
							             .reset(reset), 
									       .in(p_o), 
									       .ped(ped));
	
	// Instantiate the counter module to either 
	// increment or decrement Q 
	counter            count0     (.clk(clk), 
									       .reset(reset), 
									       .UHDL(sw_uhdl), 
								     		 .inc_p(ped), 
										    .Q(count));
	
	// Instantiate the display controller module
	// to display counter Q onto the 7seg display
	display_controller displ0     (.clk(clk), 
									       .reset(reset), 
											 .anode(anode), 
											 .a(a), .b(b), 
											 .c(c), .d(d), 
											 .e(e), .f(f), .g(g), 
											 .D_out(count), 
											 .addr(16'b0));
	
endmodule // end of top_level module 
