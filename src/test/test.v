
module test(i_btn, o_led);
	input [0:0] i_btn;
	output [0:0] o_led;

	assign o_led[0] = i_btn[0];
		
endmodule
