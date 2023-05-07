// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/BUFIO.v,v 1.1.4.4 2004/05/12 19:07:22 patrickp Exp $

/*

FUNCTION	: BUFFER

*/

`timescale  100 ps / 10 ps


module BUFIO (O, I);

    output O;
    
    input  I;
    
    buf B1 (O, I);

endmodule

