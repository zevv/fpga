// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ICAP_VIRTEX2.v,v 1.9.22.1 2003/11/18 20:41:35 wloo Exp $
/*

FUNCTION	: Special Function Cell, ICAP_VIRTEX2

*/

`timescale  100 ps / 10 ps


module ICAP_VIRTEX2 (BUSY, O, CE, CLK, I, WRITE);

    output BUSY;
    output [7:0] O;
    input  CE, CLK, WRITE;
    input  [7:0] I;

endmodule

