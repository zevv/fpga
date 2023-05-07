// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/XORCY.v,v 1.8.22.1 2003/11/18 20:41:40 wloo Exp $

/*

FUNCTION	: XOR for carry logic

*/

`timescale  100 ps / 10 ps


module XORCY (O, CI, LI);

    output O;

    input  CI, LI;

	xor X1 (O, CI, LI);

    specify
	(CI *> O) = (0, 0);
	(LI *> O) = (0, 0);
    endspecify

endmodule

