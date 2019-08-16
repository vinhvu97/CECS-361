`timescale 1ns / 1ps
//*****************************************************************************//
//    This document contains information proprietary to the                    //
//    CSULB student that created the file - any reuse without                  //
//    adequate approval and documentation is prohibited                        //
//                                                                             //
//    Class:         CECS360 Integrated Circuits Design                        //
//    Project name:  VGA_Controller                                            //
//    File name:     Pixel_Gen.v                                               //
//                                                                             //
//    Created by Chanartip Soonthornwan on November 6, 2017.                   //
//    Copyright @ 2017 Chanartip Soonthornwan. All rights reserved.            //
//                                                                             //
//    Abstract:      Generate Color for objects in their regions from          //
//                   xy-coordinate(pixel_x, pixel_y) when video_on             //
//                   signal is active.                                         //
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
module Pixel_Gen(clk, reset, pixel_x, pixel_y, video_on, btn, rgb);

   input               clk, reset;        // clock and reset signal
   input               video_on;          // vid_on
   input        [1:0]  btn;               // ButtonUp[0] and ButtonDown[1]
   input        [9:0]  pixel_x, pixel_y;  // xy-coordinates
   output  reg  [7:0]  rgb;               // Color outputs
     
   wire        ref_tick;   // reference tick (60Hz)
   
   // Check if pixel_xy in their boundaries
   wire        wall_on,  bar_on,  ball_on; 
   // Color to assign on RGB   
   wire  [7:0] wall_rgb, bar_rgb, ball_rgb, bg_rgb;  

   // Bar_Top and Bottom boundary
   reg   [8:0] bar_T,       bar_B;          
     
   // Ball Boundaries
   reg   [9:0] ball_L,      ball_R; 
   reg   [8:0] ball_T,      ball_B;
   // Registers to updating Ball's xy position
   reg   [9:0] ball_X;      
   reg   [8:0] ball_Y;
   reg   [9:0] delta_x;     
   reg   [8:0] delta_y;
    
   /****************************************
    *         P A R A M E T E R S          *
    ****************************************/
   parameter
      // (x,y) coordinate (0,0) to (639, 479)
      MAX_X = 10'd640, MAX_Y = 10'd480,
   
      // Wall object defined variable
      WALL_L = 10'd32, WALL_R = 10'd35,              // LEFT-RIGHT
      
      // Bar object defined variable
      BAR_T_RST = 10'd204, BAR_B_RST = 10'd276,        // TOP-BOTTOM at reset
      BAR_L = 10'd600, BAR_R = 10'd603,              // LEFT-RIGHT
      BAR_V = 10'd2,                                  // Bar Velocity
      BAR_SIZE  = 10'd72,                             // Bar's y size
      
      // Ball object defined variable
      BALL_L_RST = 10'd580, BALL_R_RST = 10'd588,    // LEFT-RIGHT at reset
      BALL_T_RST = 10'd238,  BALL_B_RST = 10'd246,     // TOP-BOTTOM at reset
      BALL_P_V  = 10'd1, BALL_N_V = -BALL_P_V,        // Ball Velocity  
      BALL_SIZE = 10'd8,                              // Size of Ball

      // Color codes
      // RGB = BBGGGRRR
      BLACK  = 8'b00_000_000,   BLUE    = 8'b11_000_000,   
      GREEN  = 8'b00_111_000,   CYAN    = 8'b11_111_000,   
      RED    = 8'b00_000_111,   MAGENTA = 8'b11_000_111,   
      YELLOW = 8'b00_111_111,   WHITE   = 8'b11_111_111,    
      D_GREEN= 8'b10_100_000;
      
      
   // Reference tick
   //    will tick on screen refresh rate (60Hz)
   //    note: Since pixel_x and pixel_y updated by
   //          25MHz in VGA_Sync, ref_tick will be updated
   //          every 25MHz/(800*525) = 59.5Hz
   assign ref_tick = (pixel_x == 0) & (pixel_y == 481);

   // Update Bar
   //    At reset, set bar top and bottom at their origins.
   //    On each frame, if a button is pressed,
   //       move the bar on the button's direction.
   always @ (posedge clk, posedge reset)
      if(reset) begin
         // Reset Bar Position
            bar_T   <= BAR_T_RST;           
            bar_B   <= BAR_B_RST;
      end
      else if(ref_tick) 
         begin
            if(btn[0] & (bar_T >= BAR_V)) // button up & not hit the top
               bar_T <= bar_T - BAR_V;
            else                          // hit the top
            if(btn[0])
               bar_T <= 0;
            else                          // button down & not hit the bottom
            if(btn[1] & (bar_B + BAR_V < MAX_Y-1))
               bar_T <= bar_T + BAR_V;
                
            // updating bar_bottom
            bar_B <= bar_T + BAR_SIZE;
            
         end
         
   // Update Ball
   //    At reset, set ball at its origin.
   //    On each frame, ball moves in x and y direction
   //    with a constant velocity.
   always @ (posedge clk, posedge reset)
      if(reset) begin
         // Reset Ball Positions
         ball_L  <= BALL_L_RST;
         ball_R  <= BALL_R_RST;
         ball_T  <= BALL_T_RST;
         ball_B  <= BALL_B_RST;
         // Reset Ball Velocities
         delta_x <= BALL_N_V;
         delta_y <= BALL_N_V;
      end
      else if(ref_tick) 
         begin
            if(ball_T < 1)                   // If ball hits top,
               delta_y <= BALL_P_V;          //    velocity becomes positive.
            else
            if(ball_B > MAX_Y -1)            // If ball hits bottom,
               delta_y <= BALL_N_V;          //    velocity becomes negative.
            else
            if(ball_L < WALL_R)              // If ball hits the wall,
               delta_x <= BALL_P_V;          //    velocity becomes positive.
            else        
            if(ball_R >= BAR_L   &           // If ball hit the bar
               ball_R <= BAR_R   &           //    velocity becomes negative.
               ball_T <= bar_B   &
               ball_B >= bar_T
               )
               delta_x <= BALL_N_V;
               
            // Update ball boundaries
            ball_T <= ball_T + delta_y;
            ball_B <= ball_T + delta_y + BALL_SIZE;
            ball_L <= ball_L + delta_x;
            ball_R <= ball_L + delta_x + BALL_SIZE;
             
         end

   // Check if pixel_x and pixel_y fall into an object's region
   //    Then assign the region's color to rgb output
   assign wall_on = ( pixel_x >= WALL_L & 
                      pixel_x <= WALL_R 
                     );
                     
   assign bar_on  = ( pixel_x >= BAR_L  & 
                      pixel_x <= BAR_R  &
                      pixel_y >= bar_T  & 
                      pixel_y <= bar_B  
                     );
                      
   assign ball_on = ( pixel_x >= ball_L & 
                      pixel_x <= ball_R &
                      pixel_y >= ball_T & 
                      pixel_y <= ball_B 
                     );
  
   // Assign each object's color
   assign wall_rgb = RED;
   assign bar_rgb  = BLACK;
   assign ball_rgb = WHITE;
   assign bg_rgb   = D_GREEN;
   
   // Updating colors on the screen
   always @ (*) begin
      if(~video_on)
         rgb = BLACK;                        // blank
      else 
         if(wall_on) rgb = wall_rgb;   else  // wall
         if(bar_on)  rgb = bar_rgb;    else  // bar
         if(ball_on) rgb = ball_rgb;   else  // ball
                     rgb = bg_rgb;           // background
   end
 
endmodule
