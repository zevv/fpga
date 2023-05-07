

module sim_main;
	reg i_clk;
	reg i_reset;
	wire o_hsync;
	wire o_vsync;
	wire o_red;
	wire o_green;
	wire o_blue;
	reg GSR;
	reg i_rxd;
	
	assign glbl.GSR = GSR;

	main main(i_clk, i_reset, o_hsync, o_vsync, o_red, o_green, o_blue, i_rxd);
		 
	initial begin
		$dumpfile("sim_main.vcd");
		$dumpvars(2, main);
		
		i_clk <= 0;
		i_reset <= 1;
		i_rxd <= 1;
		
		#10 i_reset <= 0;
		
		
	end

	always #1 i_clk = ~i_clk;
	always #5000 $finish;
	
	

endmodule

