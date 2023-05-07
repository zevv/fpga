// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/MUXCY.v,v 1.8.22.1 2003/11/18 20:41:37 wloo Exp $

/*

FUNCTION	: 2 to 1 Multiplexer for Carry Logic

*/

`timescale  100 ps / 10 ps


module MUXCY (O, CI, DI, S);

    output O;
    reg    o_out;

    input  CI, DI, S;

    buf B1 (O, o_out);

	always @(CI or DI or S) begin
	    if (S)
		o_out <= CI;
	    else
		o_out <= DI;
	end

    specify
	(CI => O) = (0, 0);
	(DI => O) = (0, 0);
	(S  => O) = (0, 0);
    endspecify

endmodule

