// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LDP_1.v,v 1.9.22.2 2003/12/05 00:34:05 wloo Exp $

/*

FUNCTION	: D-LATCH with async preset

*/

`timescale  1 ps / 1 ps


module LDP_1 (Q, D, G, PRE);

    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  D, G, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or PRE or D or G)
	    if (GSR)
		q_out <= INIT;
	    else if (PRE)
		q_out <= 1;
	    else if (!G)
		q_out <= D;

    specify
	if (!PRE && !G)
	    (D +=> Q) = (100, 100);
	if (!PRE)
	    (negedge G => (Q +: D)) = (100, 100);
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
    endspecify

endmodule

