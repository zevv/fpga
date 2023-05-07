
module main(i_clk, i_rxd, o_txd, o_disp_an, o_disp_seg, o_ld);

	input i_clk;
	input i_rxd;
	output o_txd;
	output [3:0] o_disp_an;
	output [7:0] o_disp_seg;
	output [7:0] o_ld;
	
	wire i_clk;
	wire i_rxd;
	wire o_txd;
	wire [3:0] o_disp_an;
	wire [7:0] o_disp_seg;
	wire [7:0] uart_data;
	wire uart_data_valid;
	wire uart_tx_busy;
	
	reg [15:0] display_data = 0;
	
	assign o_ld = uart_data;

	always @(posedge i_clk)
		if(uart_data_valid) begin
			display_data[15:8] <= display_data[7:0];
			display_data[7:0] <= uart_data;
		end
			


	display display(
		.i_clk(i_clk),
		.i_value(display_data),
		.o_disp_an(o_disp_an),
		.o_disp_seg(o_disp_seg)
	);
	
	uart_rx uart_rx(
		.i_clk(i_clk),
		.i_rxd(i_rxd),
		.o_data(uart_data),
		.o_data_valid(uart_data_valid)
	);
	
	uart_tx uart_tx(
		.i_clk(i_clk),
		.i_data(uart_data),
		.i_start(uart_data_valid),
		.o_tx(o_txd),
		.o_busy(uart_tx_busy)
	);

endmodule

