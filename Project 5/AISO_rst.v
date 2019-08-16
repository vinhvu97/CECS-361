`timescale 1ns / 1ps
//*****************************************************************************//
//    This document contains information proprietary to the                    //
//    CSULB student that created the file - any reuse without                  //
//    adequate approval and documentation is prohibited                        //
//                                                                             //
//    Class:         CECS360 Integrated Circuits Design                        //
//    Project name:  Counter on 7-segment display                              //
//    File name:     AISO_rst.v                                                //
//                                                                             //
//    Created by Chanartip Soonthornwan on September 17, 2017.                 //
//    Copyright @ 2017 Chanartip Soonthornwan. All rights reserved.            //
//                                                                             //
//    Abstract:       Receives reset signal input from a reset button          //
//                    then generates synchronized output at rising edge        //
//                    to other module in the design.                           //
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
module AISO_rst(clk, rst, rst_s);
   
   input      clk, rst;                 // on-board clock, and AISO reset signal
   output  wire  rst_s;                 // Synchronized reset signal
   reg          q1, q2;                 // registers
   
   always@(posedge clk, posedge rst) 
      if(rst) {q1,q2} <= 2'b0;          // reset
      else    {q1,q2} <= {1'b1, q1};    // q2 gets q1, and q1 get 1'b1
      
   /* 
    * if reset(rst) is HIGH, the output will be HIGH
    * else output will always be LOW
    */
   assign rst_s = ~q2;
   
endmodule
