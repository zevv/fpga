
`timescale 10 ns / 1 ns
`define DT 870


module sim_main;
	reg i_clk;
	reg i_reset;
	wire o_vsync;
	wire o_hsync;
	wire o_vclk;
	wire o_vid;
	reg i_rxd;
	reg GSR;
	reg [7:0] c = 8'd64;
	reg [7:0] d = 8'd66;
	
	
	assign glbl.GSR = GSR;

	main main(i_clk, i_reset, o_vsync, o_hsync, o_vclk, o_vid, i_rxd);
		
		 
	initial begin
		$dumpfile("main.vcd");
		$dumpvars(1, main);
		
		i_clk <= 0;
		i_reset <= 1;
		i_rxd <= 1;
		
		#6 i_reset <= 0;
		
		#1 c <= 8'd55;
		#`DT i_rxd = 0;
		#`DT i_rxd = c[0];
		#`DT i_rxd = c[1];
		#`DT i_rxd = c[2];
		#`DT i_rxd = c[3];
		#`DT i_rxd = c[4];
		#`DT i_rxd = c[5];
		#`DT i_rxd = c[6];
		#`DT i_rxd = c[7];
		#`DT i_rxd = 1;

		#1 c <= 8'd66;
		#`DT i_rxd = 0;
		#`DT i_rxd = c[0];
		#`DT i_rxd = c[1];
		#`DT i_rxd = c[2];
		#`DT i_rxd = c[3];
		#`DT i_rxd = c[4];
		#`DT i_rxd = c[5];
		#`DT i_rxd = c[6];
		#`DT i_rxd = c[7];
		#`DT i_rxd = 1;
		
	end


	always #1 i_clk = ~i_clk;
	always #40000 $finish;
	
	

endmodule

