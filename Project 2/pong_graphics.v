`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:16:00 10/28/2018 
// Design Name: 
// Module Name:    pong_graphics 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pong_graphics(video_on, pixel_x, pixel_y, rgb_pic);
	input wire video_on;
	input wire [9:0] pixel_x, pixel_y;
	output reg[11:0] rgb_pic;
	
	wire wall_on, bar_on, ball_on;
	wire [11:0] wall_rgb, bar_rgb, ball_rgb;
	
	//
	// WALL 
	//
	localparam wall_x_l = 32;
	localparam wall_x_r = 35;
	//------------------------
	assign wall_on  = (wall_x_l <= pixel_x) && (pixel_x <=wall_x_r);
	assign wall_rgb = 12'h ABC; 
	//
	// BAR
	//
	localparam bar_x_l = 600;
	localparam bar_x_r = 603;

	localparam bar_y_t = 204;
	localparam bar_y_b = 275;
	//------------------------
	assign bar_on = (bar_x_l <= pixel_x) && (pixel_x <= bar_x_r) &&
						 (bar_y_t <= pixel_y) && (pixel_y <= bar_y_b);
	assign bar_rgb = 12'h 0F8; 
	//
	// BALL
	//
	localparam ball_x_l = 580;
	localparam ball_x_r = 587;
	
	localparam ball_y_t = 238;
	localparam ball_y_b = 245;
   //------------------------
	assign ball_on = (ball_x_l <= pixel_x) && (pixel_x <= ball_x_r) &&
						  (ball_y_t <= pixel_y) && (pixel_y <= ball_y_b);
	assign ball_rgb = 12'h 789;					  
					
	always @(*)
		if (~video_on)
			rgb_pic = 12'b0;
		else 
			if (wall_on)
				rgb_pic = wall_rgb;
			else if (bar_on)
				rgb_pic = bar_rgb;
			else if (ball_on)
				rgb_pic = ball_rgb;
			else 
				rgb_pic = 12'h 6A5;
	
endmodule
