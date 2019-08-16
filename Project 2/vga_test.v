`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: vga_test.v
// Project: Lab 2
// Created by <Vinh Vu> on <Optober 18, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: This represents the top level module for the vga_sync. This module
// is designed to verify operation of the synchronization circuit. The rgb
// signal is connected to 12 swithes on the Nexys4 DDR board to change color
// configurations. The entire visible region should be turned on with a single
// color. Whenn all switches are off, the screen is black. When all switches 
// are on, it's close to white. There is a buffer output added to the rbg 
// signal. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is a modification of Pong Chu's vga_sync. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////
module vga_test(clk, reset, sw, hsync, vsync, rgb);

	// Input declarations
	input clk, reset;
	input [11:0] sw;
	
	// Output declarations
	output hsync, vsync;
	output wire [11:0] rgb;
	
	// Wire and reg declarations
	reg [11:0] rgb_reg;
	wire on;
	
	// Instantiating the vga_sync module
	vga_sync v0 (.clk(clk), 
	             .reset(reset), 
					 .hsync(hsync), 
					 .vsync(vsync), 
					 .video_on(on), 
					 .pixel_x(), 
					 .pixel_y());
					 
	// Sequential block to assign rgb signal to the switches
	always @ (posedge clk, posedge reset)
		if (reset)
			rgb_reg <= 12'b0;
		else
			rgb_reg <= sw;
	
	// Output buffer determines whether video on signal is active/inactive 
	assign rgb = (on) ? rgb_reg : 12'b0;

endmodule
