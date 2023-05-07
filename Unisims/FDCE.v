// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDCE.v,v 1.9.22.2 2003/12/05 00:34:05 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with async clear and clock enable

*/

`timescale  1 ps / 1 ps


module FDCE (Q, C, CE, CLR, D);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CE, CLR, D;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or CLR)
	    if (GSR)
		assign q_out = INIT;
	    else if (CLR)
		assign q_out = 0;
	    else
		deassign q_out;

	always @(posedge C)
	    if (CE)
		q_out <= D;

    specify
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
	if (!CLR && CE)
	    (posedge C => (Q +: D)) = (100, 100);
    endspecify

endmodule

