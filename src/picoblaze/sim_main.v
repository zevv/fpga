
module sim_main();

reg		reset;
reg		clk;
wire [7:0]	out_port;
reg GSR;
	
	assign glbl.GSR = GSR;

	initial begin
                $dumpfile("sim_main.vcd");
                $dumpvars(2, sim_main);	
	
		clk <= 0;
		reset <= 1;
		#5 reset <= 0;
	end

        always #1 clk = ~clk;
	always #101 $finish;

	always @(posedge clk)
		$display("%s", main.processor.kcpsm3_opcode);

        
	main main(
		.clk(clk),
		.reset(reset),
		.out_port(out_port)
	);
        
endmodule