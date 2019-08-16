`timescale 1ns / 1ps
//*****************************************************************************//
//    This document contains information proprietary to the                    //
//    CSULB student that created the file - any reuse without                  //
//    adequate approval and documentation is prohibited                        //
//                                                                             //
//    Class:         CECS360 Integrated Circuits Design                        //
//    Project name:  VGA_sync                                                  //
//    File name:     VGA_sync.v                                                //
//                                                                             //
//    Created by Chanartip Soonthornwan on September 27, 2017.                 //
//    Copyright @ 2017 Chanartip Soonthornwan. All rights reserved.            //
//                                                                             //
//    Abstract:      A VGA's beam controller outputs current pixel x,y         //
//                   position to Pixel Generation Circuit, also outputs        //
//                   pixel clock using in this module for synchronizing        //
//                   this module and the Pixel Generator. Moreover,            //
//                   checking if the beam display only on-screen region        //
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
module VGA_sync(clk, reset, vid_on, h_sync, v_sync, pixel_x, pixel_y);

   input          clk, reset;           // On-board clock, and reset signal
   output wire        vid_on;           // Video_on signal to turn on/off display
   output wire        h_sync;           // Horizontal synchronization on display
   output wire        v_sync;           // Verital synchronization on display
   output wire [9:0] pixel_x,           // pixel x,y position on display
                     pixel_y;
   
   // Clock pulse and Counters
   reg [1:0]       tick_25MHz;          // Slowed clock from on-board clock(100MHz)
	reg [9:0] h_count, v_count;          // Pixel and Line counter (x,y direction)
   wire          h_end, v_end;          // Flag at the end of displayable region
   wire                p_tick;          // Pixel clock
   
   parameter   
      HR = 10'd799, HD = 10'd640,       // Horizontal Range, Display
      VR = 10'd524, VD = 10'd480,       // Vertical Range, Display
      HSL = 10'd656, HSR = 10'd751,     // HSync Left-Right bound
      VSL = 10'd490, VSR = 10'd491;     // VSync Left-Right bound

   // 25 MHz clock update
   assign p_tick = tick_25MHz == 2'b11; // Slowed clock from 100MHz to 25MHz
    
   always@(posedge clk, posedge reset)
      if(reset)   tick_25MHz <= 2'b0;     else     // Receive reset set signal
      if(p_tick)  tick_25MHz <= 2'b0;              // Reset when tick = 4.
      else        tick_25MHz <= tick_25MHz + 2'b1; // Counting up by one.
      
   // Horizontal update
   always@(posedge clk, posedge reset)
      if(reset)      h_count <= 10'b0;     else    // Receive reset set signal 
      if(p_tick)                                   // At active of 25MHz clock
         if(h_end)   h_count <= 10'b0;             //    End of Horizontal edge
         else        h_count <= h_count + 10'b1;   //    Count up pixel by one
   
   assign   h_end = h_count == HR;                 // Reset at the edge of screen
      // Low active horizontal sync
      // return zero when the beam is in horizontal off-screen region
   assign   h_sync = ~(h_count>=HSL & h_count<=HSR);
         
   // Vertical update 
   always@(posedge clk, posedge reset)
      if(reset)       v_count <= 10'b0;     else    // Receive reset set signal
      if(p_tick)                                    // At active of 25MHz clock
         if(h_end)                                  //   End of Horizontal edge
            if(v_end) v_count <= 10'b0;             //      End of Vertical line
            else      v_count <= v_count + 10'b1;   //      Count up line by one
   
   assign   v_end = v_count == VR;             // Reset at the edge of screen
      // Low active horizontal sync
      // return zero when the beam is in vertical off-screen region
   assign   v_sync = ~(v_count>=VSL & v_count<=VSR);

   // High active on/off display controller
   // return one when the beam is on on-screen region
   assign   vid_on = (h_count < HD & v_count < VD);
   
   // Outputing position on x,y panel
   assign   pixel_x = h_count;
   assign   pixel_y = v_count;
   
endmodule
