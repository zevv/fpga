// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/PULLDOWN.v,v 1.9.22.1 2003/11/18 20:41:39 wloo Exp $

/*

FUNCTION	: pulldown cell

*/

`timescale  100 ps / 10 ps


module PULLDOWN (O);

    output O;

	pulldown (A);
	buf (weak0,weak1) #(1,1) (O,A);

endmodule

