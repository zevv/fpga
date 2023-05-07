// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/STARTUP_VIRTEX4.v,v 1.2.4.6 2004/05/12 19:07:23 patrickp Exp $
/*

FUNCTION	: Special Function Cell, STARTUP_VIRTEX4

*/

`timescale  100 ps / 10 ps


module STARTUP_VIRTEX4 (EOS, CLK, GSR, GTS, USRCCLKO, USRCCLKTS, USRDONEO, USRDONETS);

    output EOS;
    
    input CLK;
    input GSR;
    input GTS;
    input USRCCLKO;
    input USRCCLKTS;
    input USRDONEO;
    input USRDONETS;
    
    tri0 GSR, GTS;

	assign glbl.GSR = GSR;
	assign glbl.GTS = GTS;

endmodule

