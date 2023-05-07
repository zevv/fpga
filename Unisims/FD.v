// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FD.v,v 1.8.22.2 2003/12/05 00:34:05 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP

*/

`timescale  1 ps / 1 ps


module FD (Q, C, D);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, D;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(posedge C)
	    q_out <= D;

    specify
	(posedge C => (Q +: D)) = (100, 100);
    endspecify

endmodule

