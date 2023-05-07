// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/RAM16X8S.v,v 1.8.22.2 2003/12/05 00:34:06 wloo Exp $

/*

FUNCTION	: 16x8 Static RAM with synchronous write capability

*/

`timescale  1 ps / 1 ps


module RAM16X8S (O, A0, A1, A2, A3, D, WCLK, WE);

    parameter INIT_00 = 16'h0000;
    parameter INIT_01 = 16'h0000;
    parameter INIT_02 = 16'h0000;
    parameter INIT_03 = 16'h0000;
    parameter INIT_04 = 16'h0000;
    parameter INIT_05 = 16'h0000;
    parameter INIT_06 = 16'h0000;
    parameter INIT_07 = 16'h0000;

    output [7:0] O;

    input  A0, A1, A2, A3, WCLK, WE;
    input [7:0] D;

    reg  mem [128:0];
    reg  [8:0] count;
    wire [3:0] adr;
    wire [7:0] d_in, o_out;
    wire wclk_in, we_in;

    buf b_d0   (d_in[0], D[0]);
    buf b_d1   (d_in[1], D[1]);
    buf b_d2   (d_in[2], D[2]);
    buf b_d3   (d_in[3], D[3]);
    buf b_d4   (d_in[4], D[4]);
    buf b_d5   (d_in[5], D[5]);
    buf b_d6   (d_in[6], D[6]);
    buf b_d7   (d_in[7], D[7]);
    buf b_wclk (wclk_in, WCLK);
    buf b_we   (we_in, WE);

    buf b_a3 (adr[3], A3);
    buf b_a2 (adr[2], A2);
    buf b_a1 (adr[1], A1);
    buf b_a0 (adr[0], A0);

    buf b_o0 (O[0], o_out[0]);
    buf b_o1 (O[1], o_out[1]);
    buf b_o2 (O[2], o_out[2]);
    buf b_o3 (O[3], o_out[3]);
    buf b_o4 (O[4], o_out[4]);
    buf b_o5 (O[5], o_out[5]);
    buf b_o6 (O[6], o_out[6]);
    buf b_o7 (O[7], o_out[7]);

    buf b_o_out0 (o_out[0], mem[adr + 16 * 0]);
    buf b_o_out1 (o_out[1], mem[adr + 16 * 1]);
    buf b_o_out2 (o_out[2], mem[adr + 16 * 2]);
    buf b_o_out3 (o_out[3], mem[adr + 16 * 3]);
    buf b_o_out4 (o_out[4], mem[adr + 16 * 4]);
    buf b_o_out5 (o_out[5], mem[adr + 16 * 5]);
    buf b_o_out6 (o_out[6], mem[adr + 16 * 6]);
    buf b_o_out7 (o_out[7], mem[adr + 16 * 7]);

    initial begin
	for (count = 0; count < 16; count = count + 1) begin
	    mem[count + 16 * 0] <= INIT_00[count];
	    mem[count + 16 * 1] <= INIT_01[count];
	    mem[count + 16 * 2] <= INIT_02[count];
	    mem[count + 16 * 3] <= INIT_03[count];
	    mem[count + 16 * 4] <= INIT_04[count];
	    mem[count + 16 * 5] <= INIT_05[count];
	    mem[count + 16 * 6] <= INIT_06[count];
	    mem[count + 16 * 7] <= INIT_07[count];
	end
    end

    always @(posedge wclk_in) begin
	if (we_in == 1'b1) begin
	    mem[adr + 16 * 0] <= #100 d_in[0];
	    mem[adr + 16 * 1] <= #100 d_in[1];
	    mem[adr + 16 * 2] <= #100 d_in[2];
	    mem[adr + 16 * 3] <= #100 d_in[3];
	    mem[adr + 16 * 4] <= #100 d_in[4];
	    mem[adr + 16 * 5] <= #100 d_in[5];
	    mem[adr + 16 * 6] <= #100 d_in[6];
	    mem[adr + 16 * 7] <= #100 d_in[7];
	end
    end

    specify
	if (WE)
	    (WCLK => O[0]) = (0, 0);
	if (WE)
	    (WCLK => O[1]) = (0, 0);
	if (WE)
	    (WCLK => O[2]) = (0, 0);
	if (WE)
	    (WCLK => O[3]) = (0, 0);
	if (WE)
	    (WCLK => O[4]) = (0, 0);
	if (WE)
	    (WCLK => O[5]) = (0, 0);
	if (WE)
	    (WCLK => O[6]) = (0, 0);
	if (WE)
	    (WCLK => O[7]) = (0, 0);

	(A3 => O[0]) = (0, 0);
	(A2 => O[0]) = (0, 0);
	(A1 => O[0]) = (0, 0);
	(A0 => O[0]) = (0, 0);
	(A3 => O[1]) = (0, 0);
	(A2 => O[1]) = (0, 0);
	(A1 => O[1]) = (0, 0);
	(A0 => O[1]) = (0, 0);
	(A3 => O[2]) = (0, 0);
	(A2 => O[2]) = (0, 0);
	(A1 => O[2]) = (0, 0);
	(A0 => O[2]) = (0, 0);
	(A3 => O[3]) = (0, 0);
	(A2 => O[3]) = (0, 0);
	(A1 => O[3]) = (0, 0);
	(A0 => O[3]) = (0, 0);
	(A3 => O[4]) = (0, 0);
	(A2 => O[4]) = (0, 0);
	(A1 => O[4]) = (0, 0);
	(A0 => O[4]) = (0, 0);
	(A3 => O[5]) = (0, 0);
	(A2 => O[5]) = (0, 0);
	(A1 => O[5]) = (0, 0);
	(A0 => O[5]) = (0, 0);
	(A3 => O[6]) = (0, 0);
	(A2 => O[6]) = (0, 0);
	(A1 => O[6]) = (0, 0);
	(A0 => O[6]) = (0, 0);
	(A3 => O[7]) = (0, 0);
	(A2 => O[7]) = (0, 0);
	(A1 => O[7]) = (0, 0);
	(A0 => O[7]) = (0, 0);
    endspecify

endmodule

