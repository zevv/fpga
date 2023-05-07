// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDPE.v,v 1.9.22.2 2003/12/05 00:34:05 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with async preset and clock enable

*/

`timescale  1 ps / 1 ps


module FDPE (Q, C, CE, D, PRE);

    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  C, CE, D, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or PRE)
	    if (GSR)
		assign q_out = INIT;
	    else if (PRE)
		assign q_out = 1;
	    else
		deassign q_out;

	always @(posedge C)
	    if (CE)
		q_out <= D;

    specify
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
	if (!PRE && CE)
	    (posedge C => (Q +: D)) = (100, 100);
    endspecify

endmodule

