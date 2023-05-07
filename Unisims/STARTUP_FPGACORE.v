// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/STARTUP_FPGACORE.v,v 1.1.20.1 2003/11/18 20:41:40 wloo Exp $
/*

FUNCTION	: Special Function Cell, STARTUP_FPGACORE

*/

`timescale  100 ps / 10 ps


module STARTUP_FPGACORE (CLK, GSR);

    input  CLK, GSR;

    tri0 GSR;

	assign glbl.GSR = GSR;

endmodule

