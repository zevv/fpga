// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/KEEPER.v,v 1.8.22.1 2003/11/18 20:41:36 wloo Exp $

/*

FUNCTION	: KEEPER

*/


`timescale  100 ps / 10 ps

module KEEPER (O);

    inout O;
    reg   in;

    always @(O)
	if (O)
	    in <= 1;
	else
	    in <= 0;

    buf (pull1, pull0) B1 (O, in);

endmodule
