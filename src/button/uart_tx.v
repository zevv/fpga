

module uart_tx(i_clk, i_data, i_start, o_tx, o_busy);

	input i_clk;
	input [7:0] i_data;
	input i_start;
	output o_tx;
	output o_busy;
	
	wire i_clk;
	wire [7:0] i_data;
	wire i_start;
	wire o_tx;
	reg o_busy = 0;
	
	reg [4:0] bitnum;
	reg [7:0] data;
	wire [9:0] bits;
	reg [10:0] div = 0;
	
	wire div_count;
	wire div_reset;
	
	wire bitnum_count;
	wire bitnum_reset;
	
	always @(posedge i_clk)
		
		if(div_reset && (bitnum == 9))

			o_busy <= 0;

		else if(i_start && (o_busy==0)) begin

			data <= i_data;
			o_busy <= 1;
		end


	assign bits[0] = 0;
	assign bits[8:1] = data;
	assign bits[9] = 1;

	always @(posedge i_clk) begin

		if(div_reset) 
			div <= 0;
		else if(div_count) 
			div <= div + 1;

		if(bitnum_reset)
			bitnum <= 0;
		else if(bitnum_count)
			bitnum <= bitnum + 1;


	end
	
	assign div_reset = i_start || (div == 434);
	assign div_count = 1;
	
	assign bitnum_reset = ~o_busy;
	assign bitnum_count = o_busy & div_reset;

	assign o_tx = o_busy ? bits[bitnum] : 1;
	
endmodule
