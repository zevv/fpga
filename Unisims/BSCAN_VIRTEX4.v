// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/BSCAN_VIRTEX4.v,v 1.1.6.6 2004/05/12 19:07:22 patrickp Exp $

/*

FUNCTION	: BSCAN_VIRTEX4 dummy simulation module

*/

`timescale  100 ps / 10 ps


module BSCAN_VIRTEX4 (CAPTURE, DRCK, RESET, SEL, SHIFT, TDI, UPDATE, TDO);

    output CAPTURE, DRCK, RESET, SEL, SHIFT, TDI, UPDATE;
    
    input TDO;

    parameter JTAG_CHAIN = 1;
    
    pulldown (DRCK);
    pulldown (RESET);
    pulldown (SEL);
    pulldown (SHIFT);
    pulldown (TDI);
    pulldown (UPDATE);

    initial begin
	
	if ((JTAG_CHAIN != 1) && (JTAG_CHAIN != 2) && (JTAG_CHAIN != 3) && (JTAG_CHAIN != 4)) begin
            $display("Attribute Syntax Error : The attribute JTAG_CHAIN on BSCAN_VIRTEX4 instance %m is set to %d.  Legal values for this attribute are 1, 2, 3 or 4.", JTAG_CHAIN);
            $finish;
        end
	
    end
    
    specify
	(TDO *> DRCK) = (0,0);
	(TDO *> RESET) = (0,0);
	(TDO *> SEL) = (0,0);
	(TDO *> SHIFT) = (0,0);
	(TDO *> TDI) = (0,0);
	(TDO *> UPDATE) = (0,0);
    endspecify

endmodule

