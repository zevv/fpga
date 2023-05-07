// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IBUFG_PCIX.v,v 1.9.22.1 2003/11/18 20:41:35 wloo Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IBUFG_PCIX (O, I);

    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

