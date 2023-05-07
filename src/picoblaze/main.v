
module main(clk, reset, out_port);
input		clk;
input		reset;
output [7:0]	out_port;

wire [9:0] 	address;
wire [17:0] 	instruction;
wire [7:0] 	port_id;
wire [7:0] 	out_port;
wire [7:0] 	in_port;
wire  		write_strobe;
wire  		read_strobe;
reg  		interrupt;
wire  		interrupt_ack;
wire  		reset;
wire		clk;

        
        assign in_port = 8'd0;
        
        code c(
        	.address(address),
        	.instruction(instruction),
        	.clk(clk) 
        );
        
	kcpsm3 processor
	(	.address(address),
		.instruction(instruction),
		.port_id(port_id),
		.write_strobe(write_strobe),
		.out_port(out_port),
    		.read_strobe(read_strobe),
    		.in_port(in_port),
    		.interrupt(interrupt),
    		.interrupt_ack(interrupt_ack),
    		.reset(reset),
    		.clk(clk)
    	);

endmodule