`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: vga_sync.v
// Project: Lab 3
// Created by <Vinh Vu> on <October 18, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: The video synchronization circuit generates a hsync sign, the 
// required time to transverse a row, and vsync signal, the required time to 
// transverse the entire screen. The VGA sync module requires a 25 MHz pixel 
// ticker, which means that 25M pixels are processed in one second. The monitor
// includes black border around the visible screen which adds more pixel to
// the counter outside of the 640x480 screen. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is a modification of Pong Chu's vga_sync. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module vga_sync(clk, reset, hsync, vsync, video_on, pixel_x, pixel_y, p_tick);
	// Input and Output declarations
	input clk, reset;
	output wire hsync, vsync, video_on, p_tick;
	output wire [9:0] pixel_x, pixel_y;
	
	// sync counters
	reg [9:0] hsync_count, hsync_count_next;
	reg [9:0] vsync_count, vsync_count_next;
	
	// output buffer
	reg  vsync_reg,  hsync_reg;
	wire vsync_next, hsync_next;
	
	// video on signals
	wire h_video, v_video;
	
	// status signal
	wire h_end, v_end, pixel_tick;
	
	// RGB signal
	wire rgb;
	// Instantiate ticker to generate a 25MHz clock
	ticker tick0(.clk(clk), .reset(reset), .tick(pixel_tick));
	
	always @(posedge clk, posedge reset)
		if (reset) begin
			hsync_count <= 10'b0;
			vsync_count <= 10'b0;
			hsync_reg <= 1'b0;
			vsync_reg <= 1'b0;
			end
		else begin
			hsync_count <= hsync_count_next;
			vsync_count <= vsync_count_next;
			hsync_reg <= hsync_next;
			vsync_reg <= vsync_next;
			end
	
	// End of horizontal count (799)
	assign h_end = hsync_count == 10'd799;
	
	// End of vertical count (524)
	assign v_end = vsync_count == 10'd524;
	
	// Next state logic of horizontal counter
	always @(*)
		if (pixel_tick)
			if (h_end)
				hsync_count_next = 10'b0;
			else
				hsync_count_next = hsync_count + 1'b1;
		else 
			hsync_count_next = hsync_count;
	
	// Next state logic of vertical counter
	always @(*)
		if (pixel_tick & h_end)
			if (v_end)
				vsync_count_next = 10'b0;
			else
				vsync_count_next = vsync_count + 1'b1;
		else
			vsync_count_next = vsync_count;
	
	// Horizontal and verticle sync, buffer to avoid glitch
	// Horizontal sync asserted between 656 and 751
	// Vertical sync assert between 490 and 491
	assign hsync_next = (hsync_count_next >=10'd656 && hsync_count_next <= 10'd751);
	assign vsync_next = (vsync_count_next >=10'd490 && vsync_count_next <= 10'd491);
	
	// Horizontal Video On, HIGH ACTIVE when horizontal scan 0 through 639
	assign h_video = (hsync_count>=10'd0 && hsync_count <= 10'd639);

	// Vertical Video On, HIGH ACTIVE when vertical count scan 0 through 479
	assign v_video = (vsync_count>=10'd0 && vsync_count <= 10'd479);
	
	// Video on/off
	assign video_on = h_video && v_video;
	
	// Assign outputs
	assign hsync = ~hsync_reg;
	assign vsync = ~vsync_reg;
	assign pixel_x = hsync_count;
	assign pixel_y = vsync_count;	
	assign p_tick = pixel_tick; 
endmodule
