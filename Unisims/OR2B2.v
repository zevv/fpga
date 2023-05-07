// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OR2B2.v,v 1.8.22.1 2003/11/18 20:41:39 wloo Exp $

/*

FUNCTION	: 2-INPUT OR GATE

*/

`timescale  100 ps / 10 ps


module OR2B2 (O, I0, I1);

    output O;

    input  I0, I1;

    not N1 (i1_inv, I1);
    not N0 (i0_inv, I0);
    or O1 (O, i0_inv, i1_inv);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule

