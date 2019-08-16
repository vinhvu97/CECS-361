`timescale 1ns / 1ps
module graphics_top(clk, reset, hsync, vsync, rgb);
	input wire clk, reset;
	output wire hsync, vsync;
	output wire [11:0] rgb;
	
	wire [9:0] x, y;
	wire video_on, tick;
	reg [11:0] rgb_reg;
	wire [11:0] rgb_next;
	
	vga_sync sync0 (.clk(clk),
						 .reset(reset),
						 .hsync(hsync),
						 .vsync(vsync),
						 .video_on(video_on),
						 .p_tick(tick),
						 .pixel_x(x),
						 .pixel_y(y));
	graphics graph0 (.video_on(video_on),
				        .pixel_x(x),
						  .pixel_y(y),
						  .rgb_pic(rgb_next));
	always @ (posedge clk)
		if(tick)
			rgb_reg <= rgb_next;
		else
			rgb_reg <= rgb_reg;
	
	assign rgb = rgb_reg; 

endmodule
