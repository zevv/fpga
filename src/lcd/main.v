

module main(i_clk, i_reset, o_vsync, o_hsync, o_vclk, o_vid, i_rxd);
	input i_clk;
	input i_reset;
	output o_vsync;
	output o_hsync;
	output o_vclk;
	output o_vid;
	input i_rxd;
	
	wire [11:0] lcd_addr;
	wire [7:0] lcd_data;
	
	wire [7:0] uart_data;
	reg [11:0] uart_addr = 0;
	wire uart_data_valid;


	lcd lcd(
		.i_clk(i_clk),
		.i_reset(i_reset),
		.o_vclk(o_vclk),
		.o_vsync(o_vsync),
		.o_hsync(o_hsync),
		.o_vid(o_vid),
		.o_addr(lcd_addr),
		.i_data(lcd_data)
	);


	videoram videoram (
		.i_clk(i_clk),
		.i_addr_a(lcd_addr),
		.o_data_a(lcd_data),
		.i_addr_b(uart_addr),
		.i_data_b(uart_data),
		.i_we_b(uart_data_valid)
	);
	

	uart_rx uart_rx(
		.i_clk(i_clk),
		.i_rxd(i_rxd),
		.o_data(uart_data), 
		.o_data_valid(uart_data_valid)
	);
	
	always @(posedge i_clk) 
		if(uart_data == 0) uart_addr <= 0;
		else if(uart_data_valid) uart_addr <= uart_addr + 1;
		
	
		
endmodule
		