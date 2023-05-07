
`timescale 1 ns / 1 ns

module sim_i2c();


	reg clk; // master clock
	reg ena; // count enable
	reg rst; // synchronous active high reset

	reg [ 7:0] Tsync = 4; // sync duration
	reg [ 7:0] Tgdel = 5; // gate delay
	reg [15:0] Tgate = 6; // gate length
	reg [15:0] Tlen  = 7;  // line time / frame time

	wire Sync; // synchronization pulse
	wire Gate; // gate
	wire Done; // done with line/frame
	
	vga_vtim vtim (clk, ena, rst, Tsync, Tgdel, Tgate, Tlen, Sync, Gate, Done);

	initial begin
	
		$dumpfile("vtim.vcd");
		$dumpvars(1, vtim);
		
		clk <= 0;
		rst <= 0;
		ena <= 1;
		
		#3 rst <= 1;
		#3 rst <= 0;
		
	end
	
	always #1 clk = ~clk;
	always #1000 $finish;
	

endmodule

