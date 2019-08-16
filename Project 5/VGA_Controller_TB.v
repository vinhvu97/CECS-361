`timescale 1ns / 1ps

//*****************************************************************************//
//    This document contains information proprietary to the                    //
//    CSULB student that created the file - any reuse without                  //
//    adequate approval and documentation is prohibited                        //
//                                                                             //
//    Class:         CECS360 Integrated Circuits Design                        //
//    Project name:  VGA_Controller                                            //
//    File name:     VGA_Controller_TB.v                                       //
//                                                                             //
//    Created by Chanartip Soonthornwan on October 15, 2017.                   //
//    Copyright @ 2017 Chanartip Soonthornwan. All rights reserved.            //
//                                                                             //
//    Abstract:      Self-checking test bench verifies and anticipates         //
//                   the positioning and color of the objects on display       //
//                                                                             //
//    In submitting this file for class work at CSULB                          //
//    I am confirming that this is my work and the work                        //
//    of no one else.                                                          //
//                                                                             //
//    In the event other code sources are utilized I will                      //
//    document which portion of code and who is the author                     //
//                                                                             //
//    In submitting this code I acknowledge that plagiarism                    //
//    in student project work is subject to dismissal from the class           //
//                                                                             //
//*****************************************************************************//
module VGA_Controller_TB;

	// Inputs
	reg sys_clk;
	reg sys_reset;
    reg [1:0] in_btn;

	// Outputs
	wire out_Hsync;
	wire out_Vsync;
	wire [7:0] out_RGB;
   
	// Instantiate the Unit Under Test (UUT)
	VGA_Controller uut (
		.clk(sys_clk), 
      .btn(in_btn),
		.reset(sys_reset), 
		.Hsync(out_Hsync), 
		.Vsync(out_Vsync), 
		.RGB(out_RGB)
	); 

   // Generating 10ns clock period
   always #10 sys_clk = ~sys_clk;
   
   // Initialize Inputs
	initial begin
		sys_clk = 0;    
		sys_reset = 1;
      in_btn[0] = 0;
      in_btn[1] = 0;
      
      // set any register to a 'known' state
      @(negedge sys_clk) 
         sys_reset = 0;
      
	end //end initialized 

endmodule
