`timescale 1ns / 1ps
//*****************************************************************************//
//    This document contains information proprietary to the                    //
//    CSULB student that created the file - any reuse without                  //
//    adequate approval and documentation is prohibited                        //
//                                                                             //
//    Class:         CECS360 Integrated Circuits Design                        //
//    Project name:  VGA_Controller                                            //
//    File name:     VGA_Controller.v                                          //
//                                                                             //
//    Created by Chanartip Soonthornwan on November 6, 2017.                   //
//    Copyright @ 2017 Chanartip Soonthornwan. All rights reserved.            //
//                                                                             //
//    Abstract:       Top level of this project contained VGA_sync             //
//                    generating Horizontal Sync and Vertical Sync,            //
//                    and Pixel generator generates colors for each            //
//                    pixel on the screen.                                     //
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
module VGA_Controller(clk, reset, Hsync, Vsync, btn, RGB);
 
   input             clk,   reset;        // On-board clock, reset
   input  wire [1:0] btn;                 // ButtonUp[0] and ButtonDown[1]
   output wire       Hsync, Vsync;        // Horizontal and Vertical Sync
   output wire [7:0] RGB;                 // RGB color on display
   
          wire       reset_s;             // Inter-
          wire       tick,    vid_on;     //   -connection-
          wire [9:0] pixel_x, pixel_y;    //         -wires
          wire       btnU, btnD;
   
   // VGA Synchronizer
   //    generates horizontal and vertical sync signal
   //    to turn on and off the beam of VGA display
   //    and generates clock signal and xy-coordinate
   //    for Pixel Generator.
   VGA_sync vga_sync (.clk(clk),              // On-board clock
                      .reset(reset_s),        // reset
                      .vid_on(vid_on),        // video_on signal
                      .h_sync(Hsync),         // Horizontal sync
                      .v_sync(Vsync),         // Vertical sync
                      .pixel_x(pixel_x),      // H count
                      .pixel_y(pixel_y)       // V count
                      );
    
   // Pixel Generator
   //    generates color on xy-coordinate on display
   Pixel_Gen pix_gen(.clk(clk),
                     .reset(reset_s),
                     .pixel_x(pixel_x),      // H count
                     .pixel_y(pixel_y),      // v count
                     .video_on(vid_on),      // video_on signal
                     .btn({btnD,btnU}),      // Up[0] and Down[1]
                     .rgb(RGB)               // Color output
                     );
   
   // Asynchronized-In Synchronized out Reset
    AISO_rst AISO (.clk(clk),                // On-board clock
                   .rst(reset),              // Asynchronized reset
                   .rst_s(reset_s));         // Synchronized reset
 
   // Debounce
   //    debounced button Up(btn[0]) and down(btn[1])
   Debounce db_u (clk, reset_s, btn[0], btnU),
            db_d (clk, reset_s, btn[1], btnD);
   
endmodule
