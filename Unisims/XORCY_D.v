// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/XORCY_D.v,v 1.9.22.1 2003/11/18 20:41:40 wloo Exp $

/*

FUNCTION	: XOR for carry logic

*/

`timescale  100 ps / 10 ps


module XORCY_D (LO, O, CI, LI);

    output LO, O;

    input  CI, LI;

	xor X1 (O, CI, LI);
	xor X2 (LO, CI, LI);

    specify
	(CI *> O) = (0, 0);
	(LI *> O) = (0, 0);
	(CI *> LO) = (0, 0);
	(LI *> LO) = (0, 0);
    endspecify

endmodule

