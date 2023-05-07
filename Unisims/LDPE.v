// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/LDPE.v,v 1.9.22.2 2003/12/05 00:34:05 wloo Exp $

/*

FUNCTION	: D-LATCH with async preset and gate enable

*/

`timescale  1 ps / 1 ps


module LDPE (Q, D, G, GE, PRE);

    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  D, G, GE, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or PRE or D or G or GE)
	    if (GSR)
		q_out <= INIT;
	    else if (PRE)
		q_out <= 1;
	    else if (G && GE)
		q_out <= D;

    specify
	if (!PRE && G && GE)
	    (D +=> Q) = (100, 100);
	if (!PRE && GE)
	    (posedge G => (Q +: D)) = (100, 100);
	if (!PRE && G)
	    (posedge GE => (Q +: D)) = (100, 100);
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
    endspecify

endmodule

