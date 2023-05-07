

module sim_test;

        reg a;
        reg i1, i2;
        wire b;

	test test(a, b, i1, i2);
		 
	initial begin
		$dumpfile("test.vcd");
		$dumpvars(2, test);

		a <= 0;
		i1 <= 1;
		i2 <= 0;
		
		#1 a<= 0;
		#2 a<= 1;
		#3 a<= 0;
		
	end

	always #10 $finish;
	
	

endmodule

