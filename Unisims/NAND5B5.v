// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/NAND5B5.v,v 1.8.22.1 2003/11/18 20:41:37 wloo Exp $

/*

FUNCTION	: 5-INPUT NAND GATE

*/

`timescale  100 ps / 10 ps


module NAND5B5 (O, I0, I1, I2, I3, I4);

    output O;

    input  I0, I1, I2, I3, I4;

    not N4 (i4_inv, I4);
    not N3 (i3_inv, I3);
    not N2 (i2_inv, I2);
    not N1 (i1_inv, I1);
    not N0 (i0_inv, I0);
    nand A1 (O, i0_inv, i1_inv, i2_inv, i3_inv, i4_inv);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
	(I4 *> O) = (0, 0);
    endspecify

endmodule

