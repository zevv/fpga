// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/INV.v,v 1.8.22.1 2003/11/18 20:41:35 wloo Exp $

/*

FUNCTION	: INVERTER

*/

`timescale  100 ps / 10 ps


module INV (O, I);

    output O;

    input  I;

	not N1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

