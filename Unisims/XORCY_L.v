// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/XORCY_L.v,v 1.8.22.1 2003/11/18 20:41:40 wloo Exp $

/*

FUNCTION	: XOR for carry logic

*/

`timescale  100 ps / 10 ps


module XORCY_L (LO, CI, LI);

    output LO;

    input  CI, LI;

	xor X1 (LO, CI, LI);

    specify
	  (CI *> LO) = (0, 0);
	  (LI *> LO) = (0, 0);
    endspecify

endmodule

