// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/AND2.v,v 1.8.22.1 2003/11/18 20:41:33 wloo Exp $

/*

FUNCTION	: 2-INPUT AND GATE

*/

`timescale  100 ps / 10 ps


module AND2 (O, I0, I1);

    output O;

    input  I0, I1;

    and A1 (O, I0, I1);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule

