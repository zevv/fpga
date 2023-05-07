// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ROM64X1.v,v 1.8.22.1 2003/11/18 20:41:40 wloo Exp $

/*

FUNCTION	: ROM 64x1

*/

`timescale  100 ps / 10 ps


module ROM64X1 (O, A0, A1, A2, A3, A4, A5);

    parameter INIT = 64'h0000000000000000;

    output O;

    input  A0, A1, A2, A3, A4, A5;

    wire dout;
    wire [5:0] adr;

    reg mem [0:63];
    reg  [15:0] count;

    buf b0 (adr[5], A5);
    buf b1 (adr[4], A4);
    buf b2 (adr[3], A3);
    buf b3 (adr[2], A2);
    buf b4 (adr[1], A1);
    buf b5 (adr[0], A0);
    buf b6 (O, dout);

    initial begin
	for(count = 0; count < 64; count = count + 1)
	    mem[count] = INIT[count];
    end

    assign dout = mem[adr];

    specify
	(A5 => O) = (0, 0);
	(A4 => O) = (0, 0);
	(A3 => O) = (0, 0);
	(A2 => O) = (0, 0);
	(A1 => O) = (0, 0);
	(A0 => O) = (0, 0);
    endspecify

endmodule

