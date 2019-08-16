`timescale 1ns / 1ps
//*****************************************************************************//
//    This document contains information proprietary to the                    //
//    CSULB student that created the file - any reuse without                  //
//    adequate approval and documentation is prohibited                        //
//                                                                             //
//    Class:         CECS360 Integrated Circuits Design                        //
//    Project name:  VGA_Controller                                            //
//    File name:     TB_Post_translate.v                                       //
//                                                                             //
//    Created by Chanartip Soonthornwan on December 12 2017.                   //
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
module TB_Post_translate;

	// Inputs
	reg clk;
	reg reset;
	reg [1:0] btn;

	// Outputs
	wire Hsync;
	wire Vsync;
	wire [7:0] RGB;

	// Instantiate the Unit Under Test (UUT)
	VGA_Controller uut (
		.clk(clk), 
		.reset(reset), 
		.Hsync(Hsync), 
		.Vsync(Vsync), 
		.btn(btn), 
		.RGB(RGB)
	);

   integer ErrorBall, ErrorWall, ErrorPaddle;
   integer ErrorVsync, ErrorHsync;
   integer     X, Y;
   integer     tick;
   
   parameter 
      HR = 10'd799, VR = 10'd524,       // Horizontal Range & Vertical Range
      HSL = 10'd656, HSR = 10'd751,     // HSync Left-Right bound
      VSL = 10'd490, VSR = 10'd491,     // VSync Left-Right bound
      
      // Object Boundaries
      Ball_L = 10'd580, Ball_R = 10'd588, Ball_T = 10'd238, Ball_B = 10'd246,
      Padd_L = 10'd600, Padd_R = 10'd603, Padd_T = 10'd204, Padd_B = 10'd276,
      Wall_L = 10'd32 , Wall_R = 10'd35 , Wall_T = 10'd0  , Wall_B = 10'd639,

      // Color codes
      // RGB = BBGGGRRR
      BLUE    = 8'b11_000_000, 
      GREEN   = 8'b00_111_000, 
      MAGENTA = 8'b11_000_111;   
      
   // Generating 20ns clock period
   always #2.975 clk = ~clk;
   
   // Initialize Inputs
	initial begin
		clk = 0;    
		reset = 1;
      ErrorBall = 0;
      ErrorWall = 0;
      ErrorPaddle = 0;
      ErrorVsync = 0;
      ErrorHsync = 0;
      X <= -1;
      Y <= 0;
      tick <= 1;  
      
      // set any register to a 'known' state
      @(posedge clk) reset = 0;
      
	end //end initialized 

   // Generate clock counter
   always@(posedge clk)
      tick <= tick+1;           // Counting up by one.
      
   // Horizontal update
   always@(*) begin
      if(tick % 4 == 0) begin
         X = X + 1'b1;
      end 
      
      if(X == 800) begin
         X = 0;
         Y = Y + 1'b1;
      end
      if(Y == 525) #20 report;
   end
   
 
   always@(posedge clk) 
      // Checking while Vsync is not active.(LOW active)
      //if(tick)
      begin  
         // Objects' regions checking 
         //    Ball Object
         if(((X < Ball_L | X > Ball_R)  & 
             (Y < Ball_T | Y > Ball_B)) & 
            (RGB == GREEN))
            ErrorBall <= 1;             // Found Green outside Ball's region
            
         //    Paddle Object
         if (((X < Padd_L | X > Padd_R)  & 
              (Y < Padd_T | Y > Padd_B)) & 
             (RGB == MAGENTA))
            ErrorPaddle <= 1;           // Found Magenta outside Paddle's region
         
         //    Wall Object
         if ((X < Wall_L | X > Wall_R)   &
             (RGB == BLUE) )
            ErrorWall <= 1;             // Found Blue outside Wall's region
    
         // Vsync & Hsync checking
         if((X < HSL | X > HSR) & (!Hsync))
            ErrorHsync <= 1;
         
         if((Y < VSL | Y > VSR) & (!Vsync))
            ErrorVsync <= 1;
            
      end   // end tick  
     
   // Report Task 
   //    Display error message if an error flag of 
   //    wall, ball, or paddle is up.
   task report;
   begin
      if(ErrorBall == 1)
         $display("Error: Found Green outside Ball's region.");
      else
         $display("Ball is in its region.");
         
      if(ErrorPaddle == 1 )
         $display("Error: Found Magenta outside Paddle's region");
      else
         $display("Paddle is in its region.");
      
      if(ErrorWall == 1)
         $display("Error: Found Blue outside Wall's region.");
      else
         $display("Wall is in its region.");
      
      if(ErrorHsync == 1)
         $display("Error: Hsync is active outside its boundary.");
      else
         $display("Hsync is active correctly.");
         
      if(ErrorVsync == 1)
         $display("Error: Vsync is active outside its boundary.");
      else
         $display("Vsync is active correctly."); 
         
      $finish;       // Finish the Test Bench
   end
   endtask;
       
      
endmodule

