
module math(rst, clk, a, b, c, d, result);

	input rst;
	input clk;
	input wire [15:0] a;
	input wire [15:0] b;
	input wire [15:0] c;
	input wire [15:0] d;
	output reg [15:0] result;

	reg [32:0] ab;
	reg [32:0] cd;
	
	
	always @(posedge clk) begin
		ab <= a*b;
		cd <= c*d;
		result <= ab + cd;
	end
		

endmodule
		