
`timescale 1 ns / 1 ps

module sim_math;

	reg clk;
	reg rst;
	reg i;
	reg [15:0] a;
	reg [15:0] b;
	reg [15:0] c;
	reg [15:0] d;
	wire [15:0] result;
	
	math m (rst, clk, a, b, c, d, result);
	
	initial begin
		$dumpfile("math.vcd");
		$dumpvars(2, m);
		
		clk <= 0;
		rst <= 1;

		a <= 0;
		b <= 0;
		c <= 0;
		d <= 0;

		#4 rst <= 0;		
		
		a <= 10;
		b <= 11;
		c <= 12;
		d <= 13;

		#2 rst <= 0;		
		
		a <= 20;
		b <= 21;
		c <= 22;
		d <= 23;
	end

	always #1 clk = ~clk;
	
	always #1000 $finish;   
	        
	        
endmodule
