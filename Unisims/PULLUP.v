// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/PULLUP.v,v 1.9.22.1 2003/11/18 20:41:39 wloo Exp $

/*

FUNCTION	: pullup cell

*/

`timescale  100 ps / 10 ps


module PULLUP (O);

    output O;
	pullup (A);
	buf (weak0,weak1) #(1,1) (O,A);

endmodule

