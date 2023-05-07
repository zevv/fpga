// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FDRSE_1.v,v 1.8.22.2 2003/12/05 00:34:05 wloo Exp $

/*

FUNCTION	: D-FLIP-FLOP with sync reset, sync set and clock enable

*/

`timescale  1 ps / 1 ps


module FDRSE_1 (Q, C, CE, D, R, S);

    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CE, D, R, S;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(negedge C)
	    if (R)
		q_out <= 0;
	    else if (S)
		q_out <= 1;
	    else if (CE)
		q_out <= D;

    specify
	if (R)
	    (negedge C => (Q +: 1'b0)) = (100, 100);
	if (!R && S)
	    (negedge C => (Q +: 1'b1)) = (100, 100);
	if (!R && !S && CE)
	    (negedge C => (Q +: D)) = (100, 100);
    endspecify

endmodule

