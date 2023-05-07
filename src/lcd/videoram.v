
module videoram (i_clk, i_addr_a, o_data_a, i_addr_b, i_data_b, i_we_b);

	input i_clk;
	input [11:0] i_addr_a;
	output [7:0] o_data_a;
	input [11:0] i_addr_b;
	input [7:0] i_data_b;
	input i_we_b;
	
	wire [11:0] i_addr_a;
	wire i_clk;
	wire [7:0] o_data_a;
	
	wire [7:0] o_data_0;
	wire [7:0] o_data_1;
	wire [10:0] addr;
	wire cs_a;
	wire cs_b;
	
	assign addr = i_addr_a[10:0];
	assign cs_a  = i_addr_a[11];
	assign cs_b  = i_addr_b[11];
	assign o_data_a = cs_a ? o_data_1 : o_data_0;

	RAMB16_S9_S9 ram0 (
		.DOA(o_data_0), 
		.ADDRA(i_addr_a[10:0]),
		.ADDRB(i_addr_b[10:0]), 
		.CLKA(i_clk),
		.CLKB(i_clk),
		.DIB(i_data_b),
		.DIPA(1'b1),
		.DIPB(1'b1),
		.ENA(1'b1),
		.ENB(1'b1),
		.SSRA(1'b0),
		.SSRB(1'b0),
		.WEA(1'b0),
		.WEB(i_we_b && ~cs_b)
	);

	RAMB16_S9_S9 ram1 (
		.DOA(o_data_1), 
		.ADDRA(i_addr_a[10:0]),
		.ADDRB(i_addr_b[10:0]), 
		.CLKA(i_clk),
		.CLKB(i_clk),
		.DIB(i_data_b),
		.DIPA(1'b1),
		.DIPB(1'b1),
		.ENA(1'b1),
		.ENB(1'b1),
		.SSRA(1'b0),
		.SSRB(1'b0),
		.WEA(1'b0),
		.WEB(i_we_b && cs_b)
	);

	
endmodule
	
