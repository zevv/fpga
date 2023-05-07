// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDCP.v,v 1.9.22.2 2003/12/05 00:34:05 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with async clear, async preset

*/

`timescale  1 ps / 1 ps


module FDCP (Q, C, CLR, D, PRE);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CLR, D, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or CLR or PRE)
	    if (GSR)
		assign q_out = INIT;
	    else if (CLR)
		assign q_out = 0;
	    else if (PRE)
		assign q_out = 1;
	    else
		deassign q_out;

	always @(posedge C)
	    q_out <= D;

    specify
	(posedge CLR => (Q +: 1'b0)) = (0, 0);
	if (!CLR)
	(posedge PRE => (Q +: 1'b1)) = (0, 0);
	if (!CLR && !PRE)
	    (posedge C => (Q +: D)) = (100, 100);
    endspecify

endmodule

