
module minimal(i_reset, i_clk, i_button, o_led1, o_hsync, o_vsync, o_blue);

	input i_reset;
	input i_clk;
	input i_button;
	output o_led1;
	output o_vsync;
	output o_hsync;
	output o_blue;

	reg [10:0] cnt_x;
	reg [10:0] cnt_y;
	reg onoff;
	reg pixelclock;

	wire xmax = (cnt_x == 784);
	wire ymax = (cnt_y == 509);


	/* Generate pixel clock */

	always @(posedge i_clk) 
		if(i_reset)
			pixelclock <= 0;
		else
			pixelclock <= !pixelclock;


	/* X counter */

	always @(posedge i_clk) 
		if(i_reset)
			cnt_x <= 0;
		else
			if(xmax)
				cnt_x <= 0;
			else
				if(pixelclock) 
					cnt_x <= cnt_x + 1;


	/* Y counter */

	always @(posedge i_clk)
		if(i_reset)
			cnt_y <= 0;
		else
			if(ymax)
				cnt_y <= 0;
			else
				if(xmax)
					cnt_y <= cnt_y + 1;


	assign o_led1 = pixelclock;
	assign o_hsync = ~(cnt_x[10:6] == 0);
	assign o_vsync = ~(cnt_y[10:6] == 0);
	assign o_blue = (cnt_x[3] ^ cnt_y[3]);

endmodule

/*
 * vi: ft=verilog ts=3 sw=3
 */
