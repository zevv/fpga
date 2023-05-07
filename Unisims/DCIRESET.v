// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/DCIRESET.v,v 1.3.4.5 2004/08/27 00:26:31 wloo Exp $

`timescale 1 ps / 1 ps 

module DCIRESET (LOCKED, RST);

    output LOCKED;
    input  RST;

    reg    LOCKED;

    always @(RST) begin

	if (RST)
	    LOCKED <= 1'b0;
	else if (!RST)
	    LOCKED <= #100000 1'b1;

    end
    
endmodule
