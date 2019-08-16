`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File Name: debounce.v
// Project: Lab 1
// Created by <Vinh Vu> on <September 22, 2018>
// Copright @ 2018 <Vinh Vu>. All rights reserved
//
// Purpose: The debounce module is a FSM (finite state machine) that wait for 
// the input as well as a tick module instantiated within itself to determine
// its next state and output. This module purpose is to stablizing signals. 
// 
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work of no one else. In 
// submitting this code I acknowledge that plagiarism in student project
// work is subject to dismissal from the class. 
////////////////////////////////////////////////////////////////////////////////

module debounce( clk , reset , in , p_out ) ;

	// Input declarations
	input  clk, reset , in ;
	
	// Output declaration 
	output reg p_out ;
	
	// Register declarations for next state and present state
	reg [2:0]  n_state , p_state ;
	reg        n_out ;
	
	// Wire declaration for tick which is a determine factor
	// for the FSM 
	wire       tick  ; 
	
	
	// Instantiation of the ticker to generate a 10ms pulse 
	ticker tick0 (.clk(clk), 
	              .reset(reset), 
					  .tick(tick));
	
	// Sequential block for state register. When reset is on,
	// present state and output is 0. When it's off, present 
	// state and outputnget next state and output
	always @( posedge clk , posedge reset )
		if (reset) 
			{p_state , p_out} <= {3'b000, 1'b0};
		
		else 
			{p_state , p_out} <= {n_state, n_out};
	
	// Next state and Output logic block. A case statement based on
	// the present state, in, and tick to determine where the FSM 
	// should go for its next state and output. 
	always @ (*)
		begin
		casex({ p_state , in , tick })
			
			// First four states of the FSM. The FSM moves forward when 
			// input is 1 and tick is 1. When input is 0, it will go back 
			// to state 0. When input is 1 and tick is 0, it will loop to
			// itself 
			{3'b000 , 1'b1 , 1'bx} : {n_state, n_out} = {3'b001, 1'b0};
			{3'b001 , 1'b1 , 1'b1} : {n_state, n_out} = {3'b010, 1'b0};
			{3'b010 , 1'b1 , 1'b1} : {n_state, n_out} = {3'b011, 1'b0}; 
			{3'b011 , 1'b1 , 1'b1} : {n_state, n_out} = {3'b100, 1'b0}; 			
			
			// Last four states of the FSM. The FSM moves forward when 
			// input is 0 and tick is 1, When the input is 1, it will 
			// go back to state 4. When input is 0 and tick is 0, it will
			// loop back to itself 
			{3'b100 , 1'b0 , 1'bx} : {n_state, n_out} = {3'b101, 1'b1}; 
			{3'b101 , 1'b0 , 1'b1} : {n_state, n_out} = {3'b110, 1'b1};
			{3'b110 , 1'b0 , 1'b1} : {n_state, n_out} = {3'b111, 1'b1};
			{3'b111 , 1'b0 , 1'b1} : {n_state, n_out} = {3'b000, 1'b1};
			
			// Default cases 
			{3'b0xx , 1'b0 , 1'bx} : {n_state, n_out} = {3'b000, 1'b0};
			{3'b1xx , 1'b1 , 1'bx} : {n_state, n_out} = {3'b100, 1'b1};
			default: {n_state, n_out} = {p_state, p_out}; 
			
			endcase
		end
			
endmodule // end of debounce 
