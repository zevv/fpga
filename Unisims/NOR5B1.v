// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/NOR5B1.v,v 1.8.22.1 2003/11/18 20:41:37 wloo Exp $

/*

FUNCTION	: 5-INPUT NOR GATE

*/

`timescale  100 ps / 10 ps


module NOR5B1 (O, I0, I1, I2, I3, I4);

    output O;

    input  I0, I1, I2, I3, I4;

    not N0 (i0_inv, I0);
    nor O1 (O, i0_inv, I1, I2, I3, I4);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
	(I4 *> O) = (0, 0);
    endspecify

endmodule

