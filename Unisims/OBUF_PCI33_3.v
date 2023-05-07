// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUF_PCI33_3.v,v 1.8.22.1 2003/11/18 20:41:39 wloo Exp $

/*

FUNCTION	: OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUF_PCI33_3 (O, I);

    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    bufif0 B1 (O, I, GTS);

    specify
	(I *> O) = (0, 0);
    endspecify

endmodule

