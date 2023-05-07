
module uart_rx(i_clk, i_rxd, o_data, o_data_valid);
	
	input i_clk;
	input i_rxd;
	output [7:0] o_data;
	output o_data_valid;
	
	wire i_clk;
	wire i_rxd;
	reg p2_rxd = 1;
	reg p3_rxd = 1;
	reg [9:0] bits;
	wire [7:0] o_data;

	reg [16:0] div;  	
	reg [4:0] bitnum;
	reg receiving = 0;
	wire o_data_valid;
	
	wire div_reset;
	wire div_count;
	wire bitnum_reset;
	wire bitnum_count;
	
	wire shift_bit;
	
	/* Latch input twice */
	
	always @(posedge i_clk) begin
		p3_rxd <= p2_rxd;
		p2_rxd <= i_rxd;
	end


	/*  2 x baudrate clock */
	
	always @(posedge i_clk)
		if(div_reset) div <= 0;
		else if(div_count) div <= div + 1;
			
	assign div_reset = (div == 210) || !receiving;
	assign div_count = receiving;


	/* Bit number counter */

	always @(posedge i_clk) 
		if(bitnum_reset) bitnum <= 0;
		else if(bitnum_count) bitnum <= bitnum + 1;

	assign bitnum_reset = !receiving;
	assign bitnum_count = receiving && div_reset;
				

	always @(posedge i_clk) begin
		if(!receiving && !p3_rxd) receiving <= 1;
		if(receiving && o_data_valid) receiving <= 0;
		if(shift_bit) bits <= { p3_rxd, bits[9:1] };
	end
	
	assign shift_bit = bitnum_count & !bitnum[0];
	assign o_data_valid = receiving && (bitnum == 19) && div_reset;
	assign o_data[7:0] = bits[8:1];
	
endmodule	
	
	
	
