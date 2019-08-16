`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: graphics_top.v
// Project: Lab 4
// Created by <Vinh Vu> on <November 5, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: The graphics top level module is designed to connect the graphics
// with the vga_sync module to complete the video interface. Notice, the rgb signal
// is only asserted when pixel tick is asserted. This synchronizes the rgb_signal
// output with hsync and vsync. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is a modification of Pong Chu's graphics. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module graphics_top(clk, reset, hsync, vsync, rgb);

	// Input and Output Declarations
	input wire clk, reset;
	output wire hsync, vsync;
	output wire [11:0] rgb;
	
	// Wire and Reg Declarations 
	wire [9:0] x, y;
	wire video_on, tick;
	reg [11:0] rgb_reg;
	wire [11:0] rgb_next;
	
	// Instantiating the vga_sync for the signals 
	vga_sync sync0 (.clk(clk),
						 .reset(reset),
						 .hsync(hsync),
						 .vsync(vsync),
						 .video_on(video_on),
						 .p_tick(tick),
						 .pixel_x(x),
						 .pixel_y(y));
	
	// Instantiating the graphics modole that generates 3 objects
	graphics graph0 (.video_on(video_on),
				        .pixel_x(x),
						  .pixel_y(y),
						  .rgb_pic(rgb_next));
						
	always @ (posedge clk)
		if(tick)
			rgb_reg <= rgb_next;
	
	assign rgb = rgb_reg; 

endmodule
