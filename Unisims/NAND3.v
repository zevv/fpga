// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/NAND3.v,v 1.8.22.1 2003/11/18 20:41:37 wloo Exp $

/*

FUNCTION	: 3-INPUT NAND GATE

*/

`timescale  100 ps / 10 ps


module NAND3 (O, I0, I1, I2);

    output O;

    input  I0, I1, I2;

    nand A1 (O, I0, I1, I2);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
	(I2 *> O) = (0, 0);
    endspecify

endmodule

