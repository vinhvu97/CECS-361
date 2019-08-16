`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: graphics_top_tb.v
// Project: Lab 4
// Created by <Vinh Vu> on <November 5, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: The graphics top test bench. This is a self-checking test bench
// with 16 embedded checking requirements. When the test bench sees no error,
// nothing should be displayed and the testbench runs smoothly without being
// stopped. Once an error is encountered, a message is displayed regarding 
// the error and the testbench stops running. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is a work of my own. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module graphics_top_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire hsync;
	wire vsync;
	wire [11:0] rgb;
	
	parameter period = 20;
	
	// Instantiate the Unit Under Test (UUT)
	graphics_top pong0 (
		.clk(clk), 
		.reset(reset), 
		.hsync(hsync), 
		.vsync(vsync), 
		.rgb(rgb)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;  
		
		#5;
		reset = 0;
	end 
	
	always @(posedge clk, posedge reset) begin 
		
		// Check if reset brings circuits to a known state
		if (reset)
			if( hsync == 0 && vsync == 0 && rgb != 12'b0) begin
				$display("Reset does not bring circuit to a known state.");
				$stop;
				end 
				
		// Check VGA logic gets updated at 20 MHz 
		if ( pong0.sync0.p_tick == 1 && 
		     pong0.sync0.tick0.count != 3) begin
            $display("VGA is not updating at 25MHz");
            $stop;        
            end		
				
		// Check Horizontal Scan Count updated at 25 MHz
		if (pong0.sync0.p_tick)
			if( pong0.sync0.pixel_x == (pong0.sync0.pixel_x + 10'b1)) begin
				$display("Horizontal scan count does not update every 25 MHz");
				$stop;
				end
				
		// Check if horizontal scan count ranges from 0 to 799 
		if( !(pong0.graph0.pixel_x>=0 && 
		      pong0.graph0.pixel_x <= 799)) begin 
			$display("Horizontal Scan Count Out of Range");
			$stop;
			end
		
		// Check if horizontal sync is low active between 656 and 751 
		if ( hsync == (1'b1 && pong0.graph0.pixel_x >=656 && 
		                       pong0.graph0.pixel_x <=751)) begin 
			$display("Horizontal Sync Signal is not low active within the range");
			$stop;
			end
			
		// Check if horizontal video is on from 0 to 639 
		if ( pong0.sync0.h_video != (pong0.graph0.pixel_x >= 0 && 
		                             pong0.graph0.pixel_x <= 639)) begin
			$display("Horizontal Video is not high active from 0 639");
			$stop; 
			end 
		
		// Check if vertical count updates at the end of horizontal count 
		if ( pong0.sync0.p_tick && pong0.sync0.h_end)
			if ( pong0.sync0.vsync_count == (pong0.sync0.vsync_count + 1)) begin
				$display("Vertical count does not update");
				$stop;
				end
		
		// Check if veritcal scan count ranges from 0 to 524 
		if( !(pong0.graph0.pixel_y>=0 && 
		      pong0.graph0.pixel_y <= 524)) begin 
			$display("Vertical Scan Count Out of Range");
			$stop;
			end
			
		// Check if vertical sync is low active between 490 and 491
		if ( vsync == (1'b1 && pong0.graph0.pixel_y >=490 && 
		                       pong0.graph0.pixel_y <=491)) begin 
			$display("Vertical Sync Signal is not low active within the range");
			$stop;
			end
			
		// Check if vertical video is on from 0 to 479
		if ( pong0.sync0.v_video != (pong0.graph0.pixel_y >= 0 && 
		                             pong0.graph0.pixel_y <= 479)) begin
			$display("Vertical Video is not high active from 0 639");
			$stop; 
			end
		
		// Check if Video On Signal is on the same time as h_video and v_video
		if ( pong0.sync0.video_on != (pong0.sync0.v_video && 
		                              pong0.sync0.h_video)) begin
			$display("Video On signal is not properly on");
			$stop;
			end
		// Check if video on and RGB signals correlate 
		if ((pong0.graph0.video_on == 1'b1 && 
		     pong0.graph0.rgb_pic == 12'h000) | 
			 (pong0.graph0.video_on == 1'b0 && 
			  pong0.graph0.rgb_pic != 12'h000)) begin
			$display ("Error video.");
			$stop; 
			end 
		// Graphics Check 
		if (pong0.sync0.p_tick && pong0.graph0.video_on) begin
		
			// Check if wall is in the right position with the right RGB 
         if (pong0.graph0.wall != (pong0.graph0.pixel_x >= 32 && 
			                          pong0.graph0.pixel_x <= 35 && 
											  pong0.graph0.rgb_pic == 12'h808)) begin				 
					 $display("Error Wall");
					 $stop;
                end		
			// Check if bar is in the right position with the right RGB		 
         if (pong0.graph0.bar != (pong0.graph0.pixel_x >= 600 && 
			                         pong0.graph0.pixel_x <= 603 && 
											 pong0.graph0.pixel_y >= 204 && 
											 pong0.graph0.pixel_y <= 276 && 
											 pong0.graph0.rgb_pic == 12'hAA0)) begin
					 $display("Error Bar");
					 $stop;
                end
			// Check if ball is in the right position with the right RGB	
			if (pong0.graph0.ball != (pong0.graph0.pixel_x >= 580 && 
			                          pong0.graph0.pixel_x <= 588 && 
											  pong0.graph0.pixel_y >= 238 && 
											  pong0.graph0.pixel_y <= 246 && 
											  pong0.graph0.rgb_pic == 12'hAAF)) begin
					$display("Error Ball");
					$stop; 
					end
			// Check if background of objects are properly instantiated with correct RGB 
			if (!(pong0.graph0.pixel_x >= 32)  && !(pong0.graph0.pixel_x <= 35) && 
			    !(pong0.graph0.pixel_x >= 600) && !(pong0.graph0.pixel_x <= 603) &&
			    !(pong0.graph0.pixel_y >= 204) && !(pong0.graph0.pixel_y <= 276) &&
				 !(pong0.graph0.pixel_x >= 580) && !(pong0.graph0.pixel_x <= 588) &&
				 !(pong0.graph0.pixel_y >= 238) && !(pong0.graph0.pixel_y <= 246)) begin
					$display("Error Background");
					$stop; 
					end
		end
	end
endmodule
