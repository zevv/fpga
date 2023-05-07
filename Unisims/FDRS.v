// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDRS.v,v 1.8.22.2 2003/12/05 00:34:05 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with sync reset, sync set

*/

`timescale  1 ps / 1 ps


module FDRS (Q, C, D, R, S);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, D, R, S;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(posedge C)
	    if (R)
		q_out <= 0;
	    else if (S)
		q_out <= 1;
	    else
		q_out <= D;

    specify
	if (R)
	    (posedge C => (Q +: 1'b0)) = (100, 100);
	if (!R && S)
	    (posedge C => (Q +: 1'b1)) = (100, 100);
	if (!R && !S)
	    (posedge C => (Q +: D)) = (100, 100);
    endspecify

endmodule

