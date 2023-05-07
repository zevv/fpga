// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LD.v,v 1.8.22.2 2003/12/05 00:34:05 wloo Exp $

/*

FUNCTION	: D-LATCH

*/

`timescale  1 ps / 1 ps


module LD (Q, D, G);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  D, G;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or D or G)
	    if (GSR)
		q_out <= INIT;
	    else if (G)
		q_out <= D;

    specify
	if (G)
	    (D +=> Q) = (100, 100);
	(posedge G => (Q +: D)) = (100, 100);
    endspecify

endmodule

