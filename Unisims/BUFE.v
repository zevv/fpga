// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/BUFE.v,v 1.9.22.1 2003/11/18 20:41:33 wloo Exp $

/*

FUNCTION	: TRI-STATE BUFFER

*/

`timescale  100 ps / 10 ps


module BUFE (O, E, I);

    output O;

    input  E, I;

	bufif1 B1 (O, I, E);

    specify
	(I  *> O)  = (0, 0);
	(E  *> O)  = (0, 0);
    endspecify

endmodule

