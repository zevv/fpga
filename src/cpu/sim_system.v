
module sim_system();

	reg clk;
	reg rst;
	reg GSR;
	
	assign glbl.GSR = GSR;

	system system(clk, rst);

	initial begin
	
		$dumpfile("sim_system.vcd");
		$dumpvars(2, system);
		
		clk <= 1;
		rst <= 0;
		
//		#5 rst <=  0;
		
	end

	always #1 clk = ~clk;
	always #20 $finish;

		
endmodule
	
	
	
