// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/RAM16X1S.v,v 1.8.22.2 2003/12/05 00:34:06 wloo Exp $

/*

FUNCTION	: 16x1 Static RAM with synchronous write capability

*/

`timescale  1 ps / 1 ps


module RAM16X1S (O, A0, A1, A2, A3, D, WCLK, WE);

    parameter INIT = 16'h0000;

    output O;

    input  A0, A1, A2, A3, D, WCLK, WE;

    reg  mem [15:0];
    reg  [4:0] count;
    wire [3:0] adr;
    wire d_in, wclk_in, we_in;

    buf b_d    (d_in, D);
    buf b_wclk (wclk_in, WCLK);
    buf b_we   (we_in, WE);

    buf b_a3 (adr[3], A3);
    buf b_a2 (adr[2], A2);
    buf b_a1 (adr[1], A1);
    buf b_a0 (adr[0], A0);

    buf b_o (O, o_int);

    buf b_o_int (o_int, mem[adr]);

    initial
    begin
	for (count = 0; count < 16; count = count + 1)
	    mem[count] <= INIT[count];
    end

    always @(posedge wclk_in)
    begin
	if (we_in == 1'b1)
	    mem[adr] <= #100 d_in;
    end

    specify
	if (WE)
	    (WCLK => O) = (0, 0);

	(A3 => O) = (0, 0);
	(A2 => O) = (0, 0);
	(A1 => O) = (0, 0);
	(A0 => O) = (0, 0);
    endspecify

endmodule

