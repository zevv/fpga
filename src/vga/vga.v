
//`define RES_TEST
`define RES_800x600

`define CHAR_WIDTH 5
`define CHAR_HEIGHT 10

`ifdef RES_TEST
`define H_VISIBLE 72
`define H_SYNC_START 74
`define H_SYNC_END 76
`define H_MAX 78
`define V_VISIBLE 55
`define V_SYNC_START 57
`define V_SYNC_END 59
`define V_MAX 61
`endif

`ifdef RES_800x600
`define H_VISIBLE 799
`define H_SYNC_START 857
`define H_SYNC_END 976
`define H_MAX 1040
`define V_VISIBLE 600
`define V_SYNC_START 637
`define V_SYNC_END 643
`define V_MAX 666
`endif



module vga(i_clk, i_reset, o_hsync, o_vsync, o_red, o_green, o_blue, ram_addr, ram_data);
	input i_clk;
	input i_reset;
	output o_hsync;
	output o_vsync;
	output o_red;
	output o_green;
	output o_blue;	
	output [12:0] ram_addr;	
	input [7:0] ram_data;

	wire i_reset;
	wire i_clk;
	wire o_hsync;
	wire o_vsync;
	wire o_red;
	wire o_green;
	wire o_blue;

	reg [10:0] screen_x;		/* Horizontal pixel in screen */
	wire screen_x_reset;
	reg [9:0] screen_y;		/* vertical pixel in screen */
	wire screen_y_reset;
	reg [2:0] char_x;		/* Horizontal pixel in current character */
	wire char_x_reset;
	reg [2:0] p2_char_x;		/* for 2nd pipeline */
	reg [2:0] p3_char_x;		/* for 3d pipeline */
	reg [4:0] char_y;		/* Horizontal pixel in current character */
	wire char_y_reset;
	reg [4:0] p2_char_y;		/* same for 2nd pipeline */
	reg [7:0] col;	  		/* Character column */
	wire col_reset;
	reg [5:0] row;			/* Character row */
	wire row_reset;

	wire p3_pixel;			/* The pixel value */

	wire [12:0] ram_addr;		/* Ram address of current character */
	wire [7:0] ram_data;		/* Output of text RAM */
	wire [10:0] rom_addr;		/* character ROM address of current character */
	wire [7:0] rom_data;		/* Output of character ROM */

	reg p2_hsync;	  		/* Horizontal sync signal */
	reg p3_hsync;
	reg p2_vsync;			/* Vertical sync signal */
	reg p3_vsync;
	reg p2_hactive;		  	/* Horizontal active time */
	reg p2_vactive;			/* Vertical active time */
	wire p2_active;			/* Beam in active area */
	reg p3_active;


 	/* Generate the various counters */

	always @(posedge i_clk)

		if(i_reset) begin

			char_x <= 0;
			char_y <= 0;
			col <= 0;
			row <= 0;
			screen_x <= 0;
			screen_y <= 0;

		end else begin			 

			if(screen_x_reset) screen_x <= 0; else screen_x <= screen_x + 1;
			if(screen_y_reset) screen_y <= 0; else if(screen_x_reset) screen_y <= screen_y + 1;

			if(char_x_reset) char_x <= 0; else char_x <= char_x + 1;
			if(char_y_reset) char_y <= 0; else if(col_reset) char_y <= char_y + 1;

			if(col_reset) col <= 0; else if(char_x_reset) col <= col + 1; 
			if(row_reset) row <= 0; else if(char_y_reset) row <= row + 1;

		end



	/* Signals for resetting counters */

	assign screen_x_reset = (screen_x == `H_MAX);
	assign screen_y_reset = (screen_y == `V_MAX) && screen_x_reset;

	assign char_x_reset = (char_x == `CHAR_WIDTH) || screen_x_reset;
	assign char_y_reset = ((char_y == `CHAR_HEIGHT) && col_reset) || screen_y_reset;
	
	assign col_reset = screen_x_reset;
	assign row_reset = screen_y_reset;



	/* VGA sync and active signals */
	
	always @(posedge i_clk) begin
		
		if(i_reset) begin
		
			p2_hactive <= 1;
			p2_vactive <= 1;
			p2_hsync <= 1;
			p2_vsync <= 1;

		end else begin

			case(screen_x)
				0: p2_hactive <= 1;
				`H_VISIBLE: p2_hactive <= 0;
				`H_SYNC_START: p2_hsync <= 0;
				`H_SYNC_END: p2_hsync <= 1;
			endcase

			case(screen_y)
				0: p2_vactive <= 1;
				`V_VISIBLE: p2_vactive <= 0;
				`V_SYNC_START: p2_vsync <= 0;
				`V_SYNC_END: p2_vsync <= 1;
			endcase
		end
	
	end

	assign p2_active = p2_hactive & p2_vactive;


	/* clock some data to next pipeline stages */

	always @(posedge i_clk) begin

		p3_char_x <= p2_char_x;
		p2_char_x <= char_x;
		p2_char_y <= char_y;
		p3_hsync <= p2_hsync;
		p3_vsync <= p2_vsync;
		p3_active <= p2_active;
	end


	/* Text ram and character rom control */

	assign ram_addr = row * (`H_VISIBLE / (`CHAR_WIDTH+1)) + col;
	assign rom_addr = ram_data * (`CHAR_HEIGHT+1) + p2_char_y;	


	/* Clock out the font bitmap row */

	assign p3_pixel = rom_data[p3_char_x];

	assign o_hsync = p3_hsync;
	assign o_vsync = p3_vsync;
	assign o_red   = p3_active & p3_pixel;
	assign o_green = p3_active & p3_pixel;
	assign o_blue  = p3_active & p3_pixel;


	wire rom_dop;

	RAMB16_S9 fontrom (
		.DO(rom_data),  	// 8-bit Data Output
		.DOP(rom_dop),		// 1-bit parity Output
		.ADDR(rom_addr),	// 11-bit Address Input
		.CLK(i_clk),	  	// Clock
		.DI(8'd0),		// 8-bit Data Input
		.DIP(1'd0),	  	// 1-bit parity Input
		.EN(1'd1),		// RAM Enable Input
		.SSR(1'd0),	  	// Synchronous Set/Reset Input
		.WE(1'd0)		// Write Enable Input
	);

	`include "ramdata/fontrom.init"
	

endmodule


