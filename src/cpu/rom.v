

module rom(clk, addr, di, do, we);

	input clk;
	input [10:0] addr;
	input [7:0] di;
	output [7:0] do;
	input we;

	wire dop;
	
	RAMB16_S9 ram (
		.DO(do),	// 16-bit Data Output
		.DOP(dop),	// 2-bit parity Output
		.ADDR(addr),  	// 10-bit Address Input
		.CLK(clk),	// Clock
		.DI(di),	// 16-bit Data Input
		.DIP(1'd0),	// 2-bit parity Input
		.EN(1'd1),	// RAM Enable Input
		.SSR(1'd0),	// Synchronous Set/Reset Input
		.WE(we)		// Write Enable Input
	);

	defparam ram.INIT_00 = 256'h72756769666e6f632029382874696e69203a6261744_0000_0c02_1020_0901_0870;
//	defparam ram.INIT_00 = 256'h72756769666e6f632029382874696e69203a62617474696e_0c03_1020_0922_0842;

endmodule

