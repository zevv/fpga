// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/AND3B2.v,v 1.8.22.1 2003/11/18 20:41:33 wloo Exp $

/*

FUNCTION	: 3-INPUT AND GATE

*/

`timescale  100 ps / 10 ps


module AND3B2 (O, I0, I1, I2);

    output O;

    input  I0, I1, I2;

    not N1 (i1_inv, I1);
    not N0 (i0_inv, I0);
    and A1 (O, i0_inv, i1_inv, I2);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
    endspecify

endmodule

