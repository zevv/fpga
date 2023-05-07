

`ifndef SIMULATION

`define XMAX 643	// 644 in total
`define XHS 639 	// 640 visible
`define YMAX 403
`define CXMAX 5
`define CYMAX 10

`else

`define XMAX 50
`define XHS 48
`define YMAX 33
`define CXMAX 5
`define CYMAX 10

`endif

module lcd(i_clk, i_reset, o_vclk, o_vsync, o_hsync, o_vid, o_addr, i_data);

	input i_clk;
	input i_reset;
	output o_vclk;
	output o_vsync;
	output o_hsync;
	output o_vid;
	output [11:0] o_addr;
	input [7:0] i_data;
	
	wire i_clk;
	wire o_vsync;
	wire o_hsync;
	wire o_vid;
	wire [11:0] o_addr;
	wire [7:0] i_data;
	

	wire vsync;
	reg hsync;
	
	reg [9:0] x = 0;	// X-coord within screen
	wire x_reset;
	wire x_count;

	reg [9:0] y = 0;	// Y-coord within screen
	wire y_reset;
	wire y_count;
	
	reg [2:0] cx = 0;	// X-coord within character
	wire cx_reset;
	wire cx_count;
	
	reg [3:0] cy = 0;	// Y-coord within character
	wire cy_reset;
	wire cy_count;


	reg [11:0] rowaddr = 0;	// Video RAM address of start of row
	wire rowaddr_reset;
	wire rowaddr_setaddr;

	reg [11:0] addr = 0;	// Video RAM address of current (col,row)
	wire addr_reset;
	wire addr_setrowaddr;
	wire addr_count;

	wire rom_dop;
	wire [7:0] rom_data;	// Address of font rom of current (col_2, row_2)
	wire [10:0] rom_addr;


	/*
	 * Create the video clock
	 */
	 
	wire clkfb;
	wire clk0;
	wire vclk;

	BUFG bufg(clkfb, clk0);

	DCM dcm (
      		.CLK0(clk0),
      		.CLKFB(clkfb),
      		.CLKIN(i_clk),
      		.CLKFX(vclk),
      		.RST(i_reset)
   	);

//	defparam dcm.CLKFX_DIVIDE 	= 14.0; 
//	defparam dcm.CLKFX_MULTIPLY 	= 5.0;
	defparam dcm.CLKFX_DIVIDE 	= 6.0; 
	defparam dcm.CLKFX_MULTIPLY 	= 2.0;
	defparam dcm.CLKIN_PERIOD	= 20;


	/* 
	 * Screen (x,y) counters 
	 */
	
	always @(negedge vclk) if(x_reset) x <= 0; else if(x_count) x <= x + 1;
	assign x_count = 1;
	assign x_reset = (x == `XMAX);

	always @(negedge vclk) if(y_reset) y <= 0; else if(y_count) y <= y + 1;
	assign y_count = x_reset;
	assign y_reset = (y == `YMAX) && x_reset;
	
	/*
	 * Char (cx,cy) counters
	 */
	
	always @(negedge vclk) if(cx_reset) cx <= 0; else if(cx_count) cx <= cx + 1;
	assign cx_count = 1;
	assign cx_reset = x_reset || (cx == `CXMAX);

	always @(negedge vclk) if(cy_reset) cy <= 0; else if(cy_count) cy <= cy + 1;
	assign cy_count = x_reset;
	assign cy_reset = y_reset || ((cy == `CYMAX) && x_reset);
	

	/* 
	 * Ram address counters. addr is the current address, rowaddr the address of the leftmost 
	 * character in the row
	 */

	always @(negedge vclk) 
		if(addr_reset) addr <= 0;
		else if(addr_setrowaddr) addr <= rowaddr;
		else if(addr_count) addr <= addr + 1;

	assign addr_reset = y_reset;
	assign addr_setrowaddr = x_reset && ~cy_reset;
	assign addr_count = cx_reset;

	always @(negedge vclk) if(rowaddr_reset) rowaddr <= 0; else if(rowaddr_setaddr) rowaddr <= addr+1;
	assign rowaddr_reset = y_reset;
	assign rowaddr_setaddr = cy_reset;
	
	assign o_addr = addr;

	/* 
	 * Sync generators
	 */

	always @(negedge vclk) begin
		if(x == `XHS) hsync <= 0;
		if(x == `XMAX) hsync <= 1;
	end

	assign vsync = ~y_reset;

	

	/************************************************************************
	 * Stage 2:
	 *
	 * the videoram data is available one i_clk later; delay
	 * the cx and cy values one clock to lookup the proper
	 * rom address
	 */

	reg [2:0] cx_2 = 0;
	reg [3:0] cy_2 = 0;
	reg vsync_2;
	reg hsync_2;
	reg vclk_2;
	always @(posedge i_clk) begin
		cx_2 <= cx;
		cy_2 <= cy;
		vsync_2 <= vsync;
		hsync_2 <= hsync;
		vclk_2 <= vclk;
	end
	
	assign rom_addr = i_data * (`CYMAX+1) + cy_2;


	/************************************************************************
	 * Stage 3:
	 *
	 * The rom contents is available another i_clk later;
	 * delay the cx one more time
	 */
	 
	reg vsync_3;
	reg hsync_3;
	reg vclk_3;
	reg vid_3;
	always @(posedge i_clk) begin
		vsync_3 <= vsync_2;
		hsync_3 <= hsync_2;
		vclk_3 <= vclk_2;
		vid_3 <= rom_data[cx_2];
	end
	
	/*
	 * Latch all the outputs one more time, on the
	 * negative clock edge
	 */
	 
	reg vsync_4;
	reg hsync_4;
	reg vclk_4;
	reg vid_4;
	always @(posedge i_clk) begin
		vsync_4 <= vsync_3;
		hsync_4 <= hsync_3;
		vclk_4 <= vclk_3;
		vid_4 <= vid_3;
	end
	 


	assign o_vsync = vsync_4;
	assign o_hsync = hsync_4;
	assign o_vclk = vclk_4;
	assign o_vid = vid_4;
		
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