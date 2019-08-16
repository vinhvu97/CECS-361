`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: vga_tb.v
// Project: Lab 3
// Created by <Vinh Vu> on <October 18, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: The video synchronization circuit testbench tests all the requirements
// for the vga. This is to prove the proper operation of the vga_sync module. 
// The stimulus provided by the testbench only include a clock and reset; the
// vga_sync runs on it own once it gets those two elements. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is a work of my own. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////
module vga_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire hsync;
	wire vsync;
	wire video_on;
	wire [9:0] pixel_x;
	wire [9:0] pixel_y;

	// Instantiate the Unit Under Test (UUT)
	vga_sync uut (
		.clk(clk), 
		.reset(reset), 
		.hsync(hsync), 
		.vsync(vsync), 
		.video_on(video_on), 
		.pixel_x(pixel_x), 
		.pixel_y(pixel_y)
	);
	always #5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		#10
		clk = 0;
		reset = 1;
		
		// Wait 100 ns for global reset to finish
		#10
		reset = 0;

	end 
endmodule
