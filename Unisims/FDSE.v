// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDSE.v,v 1.8.22.2 2003/12/05 00:34:05 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with sync set and clock enable

*/

`timescale  1 ps / 1 ps


module FDSE (Q, C, CE, D, S);

    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  C, CE, D, S;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(posedge C)
	    if (S)
		q_out <= 1;
	    else if (CE)
		q_out <= D;

    specify
	if (S)
	    (posedge C => (Q +: 1'b1)) = (100, 100);
	if (!S && CE)
	    (posedge C => (Q +: D)) = (100, 100);
    endspecify

endmodule

