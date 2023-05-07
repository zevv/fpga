// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/MULT_AND.v,v 1.8.22.1 2003/11/18 20:41:37 wloo Exp $

/*

FUNCTION	: 2-INPUT AND

*/

`timescale  100 ps / 10 ps


module MULT_AND (LO, I0, I1);

    output LO;

    input  I0, I1;

    and A1 (LO, I0, I1);

    specify
	(I0 *> LO) = (0, 0);
	(I1 *> LO) = (0, 0);
    endspecify

endmodule

