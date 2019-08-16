`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: graphics.v
// Project: Lab 4
// Created by <Vinh Vu> on <November 5, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: The graphic generating module contains 3 objects, a wall, a baddle,
// and a ball. The wall is generated within horizontal count of 32 35. The bar 
// is generated between horizontal count 600-603, vertical count 204-276. The ball
// is generated between horizontal count 580-588, vertical count 238-246. If the
// current scan location falls within the boundaries, it asserted a signal to 
// alter rgb signal and colors within the regions. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is a modification of Pong Chu's graphics. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module graphics(video_on, pixel_x, pixel_y, rgb_pic);

	// Input and Output declarations
	input wire video_on;
	input wire [9:0] pixel_x, pixel_y;
	output reg [11:0] rgb_pic;
	
	// Wire declarations 
	wire wall, bar, ball;
	wire [11:0] wall_rgb, bar_rgb, ball_rgb;
	
	// Wall parameters
	localparam wall_x = 32;
	localparam wall_x_end = 35;
	
	// Wall signal is turned on when pixel_x between 32 and 35 
	assign wall = (wall_x <= pixel_x) && (pixel_x <= wall_x_end);
	
	// Wall RGB signal to a designated color 
	assign wall_rgb = 12'h808;
	
	// Bar parameters
	localparam bar_x = 600;
	localparam bar_x_end = 603;

	localparam bar_y = 204;
	localparam bar_y_end = 276;
	
	// Bar signal is turned on when pixel_x between 600-603
	// pixel_y between 204-276
	assign bar = (bar_x <= pixel_x) && (pixel_x <= bar_x_end) &&
	             (bar_y <= pixel_y) && (pixel_y <= bar_y_end);
	
	// Bar RGB signal to a designated color
	assign bar_rgb = 12'hAA0;
	
	// Ball parameters
	localparam ball_x = 580;
	localparam ball_x_end = 588; 
	
	localparam ball_y = 238;
	localparam ball_y_end = 246;
	
	// Ball signal is turned on when pixel_x between 580-588
	// pixel_y between 238-246 
	assign ball = (ball_x <= pixel_x) && (pixel_x <= ball_x_end) &&
					  (ball_y <= pixel_y) && (pixel_y <= ball_y_end);
	
	// Ball RGB signal to a designated color 
	assign ball_rgb = 12'hAAF;
	
	// Combinational block to assign the different RGB signals for
	// the wall, ball, bar, backround, and off mode. 
	always @(*)
		if (~video_on)
			rgb_pic = 12'b0;
		else
			if (wall)
				rgb_pic = wall_rgb;
			else if (bar)
				rgb_pic = bar_rgb;
			else if (ball)
				rgb_pic = ball_rgb;
			else
				rgb_pic = 12'hFFF;
				
endmodule
