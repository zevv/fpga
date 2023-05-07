// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IOBUF_SSTL3_II_DCI.v,v 1.7.22.1 2003/11/18 20:41:36 wloo Exp $

/*

FUNCTION	: INPUT TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module IOBUF_SSTL3_II_DCI (O, IO, I, T);

    output O;

    inout  IO;

    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 T1 (IO, I, ts);

    buf B1 (O, IO);

    specify
	(IO *> O) = (0, 0);
	(I *> IO) = (0, 0);
	(T *> IO) = (0, 0);
    endspecify

endmodule

