
module display(i_clk, i_value, o_disp_an, o_disp_seg);

	input i_clk;
	input [15:0] i_value;
	output [3:0] o_disp_an;
	output [7:0] o_disp_seg;
	
	reg [3:0] o_disp_an;
	reg [7:0] o_disp_seg;
	reg [1:0] annr = 0;
	reg [3:0] val;
	reg [10:0] count;
	
	always @(posedge i_clk) begin

		count = count + 1;
		if(count == 0) annr = annr + 1;
		
		case(annr)
			0: o_disp_an = 4'b1110;
			1: o_disp_an = 4'b1101;
			2: o_disp_an = 4'b1011;
			3: o_disp_an = 4'b0111;
		endcase

		case(annr)
			0: val = i_value[3:0];
			1: val = i_value[7:4];
			2: val = i_value[11:8];
			3: val = i_value[15:12];
		endcase
		
		case(val)
			4'h0: o_disp_seg = 8'b00000011;
			4'h1: o_disp_seg = 8'b10011111;
			4'h2: o_disp_seg = 8'b00100101;
			4'h3: o_disp_seg = 8'b00001101;
			4'h4: o_disp_seg = 8'b10011001;
			4'h5: o_disp_seg = 8'b01001001;
			4'h6: o_disp_seg = 8'b01000001;
			4'h7: o_disp_seg = 8'b00011111;
			4'h8: o_disp_seg = 8'b00000001;
			4'h9: o_disp_seg = 8'b00001001;
			4'ha: o_disp_seg = 8'b00010001;
			4'hb: o_disp_seg = 8'b11000001;
			4'hc: o_disp_seg = 8'b01100011;
			4'hd: o_disp_seg = 8'b10000101;
			4'he: o_disp_seg = 8'b01100001;
			4'hf: o_disp_seg = 8'b01110001;
		endcase
	
	end
	

endmodule

