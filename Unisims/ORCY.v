// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ORCY.v,v 1.8.22.1 2003/11/18 20:41:39 wloo Exp $

/*

FUNCTION	: OR for carry logic

*/

`timescale  100 ps / 10 ps


module ORCY (O, CI, I);

    output O;

    input  CI, I;

	or X1 (O, CI, I);

    specify
	(CI *> O) = (0, 0);
	(I *> O) = (0, 0);
    endspecify

endmodule

