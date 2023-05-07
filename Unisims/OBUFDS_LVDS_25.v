// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUFDS_LVDS_25.v,v 1.8.22.1 2003/11/18 20:41:37 wloo Exp $

/*

FUNCTION	: OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUFDS_LVDS_25 (O, OB, I);

    output O, OB;

    input  I;

    tri0 GTS = glbl.GTS;

	bufif0 B1 (O, I, GTS);
	notif0 N1 (OB, I, GTS);

    specify
	(I *> O) = (0, 0);
	(I *> OB) = (0, 0);
    endspecify

endmodule


