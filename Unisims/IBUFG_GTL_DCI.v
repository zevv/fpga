// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IBUFG_GTL_DCI.v,v 1.8.22.1 2003/11/18 20:41:35 wloo Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IBUFG_GTL_DCI (O, I);

    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

