// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/NAND5.v,v 1.8.22.1 2003/11/18 20:41:37 wloo Exp $

/*

FUNCTION	: 5-INPUT NAND GATE

*/

`timescale  100 ps / 10 ps


module NAND5 (O, I0, I1, I2, I3, I4);

    output O;

    input  I0, I1, I2, I3, I4;

    nand A1 (O, I0, I1, I2, I3, I4);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
	(I3 *> O) = (0, 0);
	(I4 *> O) = (0, 0);
    endspecify

endmodule

