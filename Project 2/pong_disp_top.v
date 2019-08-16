`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:44:55 10/28/2018 
// Design Name: 
// Module Name:    pong_disp_top 
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
module pong_disp_top(clk, rst, hsync, vsync, rgb);
	input wire clk, rst;
	output wire hsync, vsync;
	output wire [11:0] rgb;
	
	wire [9:0] x, y;
	wire video_on, tick;
	reg [11:0] rgb_reg;
	wire [11:0] rgb_next;
	
	vga_sync sync0 (.clk(clk), 
						 .reset(rst), 
						 .hsync(hsync), 
						 .vsync(vsync), 
						 .video_on(video_on), 
						 .p_tick(tick),
						 .pixel_x(x), 
						 .pixel_y(y));
						
	pong_graphics pong0 (.video_on(video_on), 
								.pixel_x(x), 
								.pixel_y(y), 
								.rgb_pic(rgb_next));	
	always @ (posedge clk)
		if(tick)
			rgb_reg <= rgb_next;
			
	assign rgb = rgb_reg;
endmodule
