// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/JTAGPPC.v,v 1.3.22.2 2004/06/09 23:17:43 patrickp Exp $

/*

		: JTAG for PPC

*/

`timescale  100 ps / 10 ps

module JTAGPPC (TCK, TDIPPC, TMS, TDOPPC, TDOTSPPC);

output TCK;
output TDIPPC;
output TMS;

input TDOPPC;
input TDOTSPPC;

	assign TCK = 1'b1;
	assign TDIPPC = 1'b1;
	assign TMS = 1'b1;
endmodule
