// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ICAP_VIRTEX4.v,v 1.1.6.6 2004/05/12 19:07:23 patrickp Exp $
/*

FUNCTION	: Special Function Cell, ICAP_VIRTEX4

*/

`timescale  100 ps / 10 ps


module ICAP_VIRTEX4 (BUSY, O, CE, CLK, I, WRITE);

    output BUSY;
    output [31:0] O;

    input  CE, CLK, WRITE;
    input  [31:0] I;

    parameter ICAP_WIDTH = "X8";
    
endmodule

