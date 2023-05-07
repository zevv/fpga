
module system(clk, rst);

	input clk;
	input rst;
	
	wire clk;
	wire rst;

	wire [15:0] cpu_addr;
	wire [7:0] cpu_data_in;
	wire [7:0] cpu_data_out;
	wire cpu_we;

	wire [10:0] rom1_addr;
	wire [7:0] rom1_data_in;
	wire [7:0] rom1_data_out;
	wire rom1_we;
	
	
	cpu cpu(
		.clk(clk), 
		.rst(rst), 
		.addr(cpu_addr),
		.di(cpu_data_in),
		.do(cpu_data_out),
		.we(cpu_we)
	);

	rom rom1(
		.clk(clk),
		.addr(rom1_addr),
		.di(rom1_data_in),
		.do(rom1_data_out),
		.we(rom1_we)
	);
		

	assign rom1_addr = cpu_addr[9:0];
	assign rom1_data_in = cpu_data_out;
	assign cpu_data_in = rom1_data_out;
	assign rom1_we = cpu_we;

		
endmodule
	
	
	
