
module sim_life;

	reg rst;
	reg clk;
	reg en_out;
	wire dout;
	wire [168:0] cel = 0;

	life life(rst, clk, en_out, dout);
	
	initial begin
		$dumpfile("life.vcd");
		$dumpvars(2, sim_life);

		clk <= 0;
		rst <= 1;
		en_out <= 0;

		
//		cel[3] = 1;
//		cel[4] = 1;
//		cel[3+15] = 1;
		
		#3 rst <= 0;
		#5 en_out <= 1;
		#100 en_out <= 0;
	end
	
	always #1 clk = ~clk;
	always #3000 $finish;   
	        
endmodule
