// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/NAND2B1.v,v 1.8.22.1 2003/11/18 20:41:37 wloo Exp $

/*

FUNCTION	: 2-INPUT NAND GATE

*/

`timescale  100 ps / 10 ps


module NAND2B1 (O, I0, I1);

    output O;

    input  I0, I1;

    not N0 (i0_inv, I0);
    nand A1 (O, i0_inv, I1);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule

