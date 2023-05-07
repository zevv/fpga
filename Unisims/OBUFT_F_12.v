// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUFT_F_12.v,v 1.8.22.1 2003/11/18 20:41:37 wloo Exp $

/*

FUNCTION	: TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUFT_F_12 (O, I, T);

    output O;

    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 T1 (O, I, ts);

    specify
	(I *> O) = (0, 0);
	(T *> O) = (0, 0);
    endspecify

endmodule

