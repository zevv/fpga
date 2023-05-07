
`timescale 1 ns / 1 ns

module sim_i2c();

	reg i_clk;
	reg i_scl;
	reg i_sda;
	wire active;
	
	i2c i2c (i_clk, i_scl, i_sda, active);

	initial begin
	
		$dumpfile("i2c.vcd");
		$dumpvars(1, i2c);
		
		i_clk <= 0;
		i_scl <= 1;
		i_sda <= 1;
		
		
		#15 i_sda <= 0;
		#30 i_sda <= 1;
		#20 i_sda <= 0;
		#60 i_sda <= 1;
		#20 i_sda <= 0;
//		#70 i_sda <= 1;
	
	end
	
	initial begin
		#20 i_scl <= 0;
		
		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;


		
		#10 i_scl <= 1;		// Ack
		#10 i_scl <= 0;




		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;

		#10 i_scl <= 1;
		#10 i_scl <= 0;



		#10 i_scl <= 1;		// Ack
		#10 i_scl <= 0;


		#10 i_scl <= 1;

	end

	always #1 i_clk = ~i_clk;
	always #1000 $finish;
	

endmodule

