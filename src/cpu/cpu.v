
`define STATE_FETCH_INSTR	8'b00000001
`define STATE_EXEC_INSTR	8'b00000010
`define STATE_FETCH_IMM		8'b00000100

module cpu(clk, rst, addr, di, do, we);

	input clk;
	input rst;
	output [15:0] addr;
	input [7:0] di;
	output [7:0] do;
	output we;

	wire clk;
	wire rst;
	reg [15:0] addr = 0;
	wire [7:0] di;
	reg [7:0] do = 0;
	reg we = 0;

	reg [7:0] state = `STATE_FETCH_INSTR;
	reg [15:0] pc = 0;
	reg [15:0] pc_next = 0;
	reg [7:0] instr;
	
	reg [7:0] imm;
	
	
	wire [3:0] opcode;
	
	
	assign opcode = instr[7:4];
	
	
	
	always @(posedge clk) begin
		
		if(state == `STATE_FETCH_INSTR) begin
			addr <= pc;
			
			state <= `STATE_EXEC_INSTR;
			pc_next <= pc + 1;
		end
		
		if(state == `STATE_EXEC_INSTR) begin
			instr <= di;
			$display("instr %x", instr);
			
			state <= `STATE_FETCH_INSTR;
		end
		
		if(state == `STATE_FETCH_IMM) begin
			imm <= di;
			$display("imm %x", imm);
			
			state <= `STATE_FETCH_INSTR;
		end
		
		pc <= pc_next;
	end
			
endmodule
	
	
	
