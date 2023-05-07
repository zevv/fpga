
`timescale 1 ns / 1 ns

`define DT 870

module sim_main;

	reg i_clk;
	reg i_rxd;
	wire o_txd;
	wire [3:0] o_disp_an;
	wire [7:0] o_disp_seg;
	wire [7:0] o_ld;

	main main(i_clk, i_rxd, o_txd, o_disp_an, o_disp_seg, o_ld);
	
	initial begin
		$dumpfile("main.vcd");
		$dumpvars(2, main);
		
		i_clk <= 0;
		i_rxd <= 1;
		
		#`DT i_rxd <= 0;	// start
		#`DT i_rxd <= 1;
		#`DT i_rxd <= 0;
		#`DT i_rxd <= 1;
		#`DT i_rxd <= 1;
		#`DT i_rxd <= 0;
		#`DT i_rxd <= 0;
		#`DT i_rxd <= 0;
		#`DT i_rxd <= 0;
		#`DT i_rxd <= 1;	// stop
	
		#`DT i_rxd <= 0;	// start
		#`DT i_rxd <= 0;
		#`DT i_rxd <= 1;
		#`DT i_rxd <= 0;
		#`DT i_rxd <= 1;
		#`DT i_rxd <= 0;
		#`DT i_rxd <= 1;
		#`DT i_rxd <= 0;
		#`DT i_rxd <= 1;
		#`DT i_rxd <= 1;	// stop
	end

	always #1 i_clk = ~i_clk;
	
	always #30000 $finish;   
	        
	        
endmodule
