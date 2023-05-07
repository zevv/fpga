
module main(i_clk, i_reset, o_hsync, o_vsync, o_red, o_green, o_blue, i_rxd);
	input i_clk;
	input i_reset;
	output o_hsync;
	output o_vsync;
	output o_red;
	output o_green;
	output o_blue;	
	input i_rxd;
	

	wire [12:0] vga_addr;
	reg [7:0] vga_data;
	
	reg [12:0] uart_addr = 0;
	wire [7:0] uart_data;
	reg [3:0] uart_we;
	wire uart_data_valid;
	
	vga vga(i_clk, i_reset, o_hsync, o_vsync, o_red, o_green, o_blue, vga_addr, vga_data);

	uart_rx uart_rx(i_clk, i_rxd, uart_data, uart_data_valid);
	

	always @(posedge i_clk)
		if(uart_data_valid) 
			if(uart_data == 0)
				uart_addr <= 0;
			else 
				uart_addr <= uart_addr + 1;


	wire [7:0] ramdata_0;
	wire [7:0] ramdata_1;
	wire [7:0] ramdata_2;
	wire [7:0] ramdata_3;

	always @(vga_addr)
		case(vga_addr[12:11])
			2'b00: vga_data <= ramdata_0;
			2'b01: vga_data <= ramdata_1;
			2'b10: vga_data <= ramdata_2;
			2'b11: vga_data <= ramdata_3;
		endcase

	always @(uart_addr)
		case(uart_addr[12:11])
			2'b00: uart_we <= 4'b0001;
			2'b01: uart_we <= 4'b0010;
			2'b10: uart_we <= 4'b0100;
			2'b11: uart_we <= 4'b1000;
		endcase

	
	RAMB16_S9_S9 ram0 (
		.DOA(ramdata_0), 
		.ADDRA(vga_addr[10:0]),
		.ADDRB(uart_addr[10:0]), 
		.CLKA(i_clk),
		.CLKB(i_clk),
		.DIB(uart_data),
		.DIPA(1'b1),
		.DIPB(1'b1),
		.ENA(1'b1),
		.ENB(1'b1),
		.SSRA(1'b0),
		.SSRB(1'b0),
		.WEA(1'b0),
		.WEB(uart_data_valid & uart_we[0])
	);


	RAMB16_S9_S9 ram1 (
		.DOA(ramdata_1), 
		.ADDRA(vga_addr[10:0]),
		.ADDRB(uart_addr[10:0]), 
		.CLKA(i_clk),
		.CLKB(i_clk),
		.DIB(uart_data),
		.DIPA(1'b1),
		.DIPB(1'b1),
		.ENA(1'b1),
		.ENB(1'b1),
		.SSRA(1'b0),
		.SSRB(1'b0),
		.WEA(1'b0),
		.WEB(uart_data_valid & uart_we[1])
	);


	RAMB16_S9_S9 ram2 (
		.DOA(ramdata_2), 
		.ADDRA(vga_addr[10:0]),
		.ADDRB(uart_addr[10:0]), 
		.CLKA(i_clk),
		.CLKB(i_clk),
		.DIB(uart_data),
		.DIPA(1'b1),
		.DIPB(1'b1),
		.ENA(1'b1),
		.ENB(1'b1),
		.SSRA(1'b0),
		.SSRB(1'b0),
		.WEA(1'b0),
		.WEB(uart_data_valid & uart_we[2])
	);

	RAMB16_S9_S9 ram3 (
		.DOA(ramdata_3), 
		.ADDRA(vga_addr[10:0]),
		.ADDRB(uart_addr[10:0]), 
		.CLKA(i_clk),
		.CLKB(i_clk),
		.DIB(uart_data),
		.DIPA(1'b1),
		.DIPB(1'b1),
		.ENA(1'b1),
		.ENB(1'b1),
		.SSRA(1'b0),
		.SSRB(1'b0),
		.WEA(1'b0),
		.WEB(uart_data_valid & uart_we[3])
	);


endmodule

