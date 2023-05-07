
`timescale 1 ns / 1 ps

module sim_hot;

	reg clk;
	reg rst;
	wire o;
	wire oclk;
	
	hot hot(rst, clk, o, oclk);
	
	initial begin
		$dumpfile("hot.vcd");
		$dumpvars(2, sim_hot);
		
		clk <= 0;
		rst <= 0;

		#6 rst <= 0;		
		
	end

	always #1 clk = ~clk;
	
	always #1000 $finish;   
	        
	        
endmodule
