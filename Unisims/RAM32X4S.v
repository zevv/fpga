// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/RAM32X4S.v,v 1.8.22.2 2003/12/05 00:34:06 wloo Exp $

/*

FUNCTION	: 32x4 Static RAM with synchronous write capability

*/

`timescale  1 ps / 1 ps


module RAM32X4S (O0, O1, O2, O3, A0, A1, A2, A3, A4, D0, D1, D2, D3, WCLK, WE);

    parameter INIT_00 = 32'h00000000;
    parameter INIT_01 = 32'h00000000;
    parameter INIT_02 = 32'h00000000;
    parameter INIT_03 = 32'h00000000;

    output O0, O1, O2, O3;

    input  A0, A1, A2, A3, A4, D0, D1, D2, D3, WCLK, WE;

    reg  mem [128:0];
    reg  [8:0] count;
    wire [4:0] adr;
    wire [3:0] d_in, o_out;
    wire wclk_in, we_in;

    buf b_d0   (d_in[0], D0);
    buf b_d1   (d_in[1], D1);
    buf b_d2   (d_in[2], D2);
    buf b_d3   (d_in[3], D3);
    buf b_wclk (wclk_in, WCLK);
    buf b_we   (we_in, WE);

    buf b_a4 (adr[4], A4);
    buf b_a3 (adr[3], A3);
    buf b_a2 (adr[2], A2);
    buf b_a1 (adr[1], A1);
    buf b_a0 (adr[0], A0);

    buf b_o0 (O0, o_out[0]);
    buf b_o1 (O1, o_out[1]);
    buf b_o2 (O2, o_out[2]);
    buf b_o3 (O3, o_out[3]);

    buf b_o_out0 (o_out[0], mem[adr + 32 * 0]);
    buf b_o_out1 (o_out[1], mem[adr + 32 * 1]);
    buf b_o_out2 (o_out[2], mem[adr + 32 * 2]);
    buf b_o_out3 (o_out[3], mem[adr + 32 * 3]);

    initial begin
	for (count = 0; count < 32; count = count + 1) begin
	    mem[count + 32 * 0] <= INIT_00[count];
	    mem[count + 32 * 1] <= INIT_01[count];
	    mem[count + 32 * 2] <= INIT_02[count];
	    mem[count + 32 * 3] <= INIT_03[count];
	end
    end

    always @(posedge wclk_in) begin
	if (we_in == 1'b1) begin
	    mem[adr + 32 * 0] <= #100 d_in[0];
	    mem[adr + 32 * 1] <= #100 d_in[1];
	    mem[adr + 32 * 2] <= #100 d_in[2];
	    mem[adr + 32 * 3] <= #100 d_in[3];
	end
    end

    specify
	if (WE)
	    (WCLK => O0) = (0, 0);
	if (WE)
	    (WCLK => O1) = (0, 0);
	if (WE)
	    (WCLK => O2) = (0, 0);
	if (WE)
	    (WCLK => O3) = (0, 0);

	(A4 => O0) = (0, 0);
	(A3 => O0) = (0, 0);
	(A2 => O0) = (0, 0);
	(A1 => O0) = (0, 0);
	(A0 => O0) = (0, 0);
	(A4 => O1) = (0, 0);
	(A3 => O1) = (0, 0);
	(A2 => O1) = (0, 0);
	(A1 => O1) = (0, 0);
	(A0 => O1) = (0, 0);
	(A4 => O2) = (0, 0);
	(A3 => O2) = (0, 0);
	(A2 => O2) = (0, 0);
	(A1 => O2) = (0, 0);
	(A0 => O2) = (0, 0);
	(A4 => O3) = (0, 0);
	(A3 => O3) = (0, 0);
	(A2 => O3) = (0, 0);
	(A1 => O3) = (0, 0);
	(A0 => O3) = (0, 0);
    endspecify

endmodule

