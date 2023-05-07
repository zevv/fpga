// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/SRLC16E.v,v 1.9.22.4 2003/12/11 23:00:58 wloo Exp $

/*

FUNCTION	: 16 bit Shift Register LUT with Carry and Clock Enable

*/

`timescale  1 ps / 1 ps


module SRLC16E (Q, Q15, A0, A1, A2, A3, CE, CLK, D);

    parameter INIT = 16'h0000;

    output Q, Q15;

    input  A0, A1, A2, A3, CE, CLK, D;

    reg  [5:0]  count;
    reg  [15:0] data;
    wire [3:0]  addr;
    wire	q_int;

    buf b_a3 (addr[3], A3);
    buf b_a2 (addr[2], A2);
    buf b_a1 (addr[1], A1);
    buf b_a0 (addr[0], A0);

    buf b_q_int (q_int, data[addr]);
    buf b_q (Q, q_int);
    buf b_q15_int (q15_int, data[15]);
    buf b_q15 (Q15, q15_int);

    initial begin
	while (CLK === 1'bx)
	    #200;
	for (count = 0; count < 16; count = count + 1)
	    data[count] <= #100 INIT[count];
    end

    always @(posedge CLK) begin
	if (CE == 1'b1) begin
	    {data[15:0]} <= #100 {data[14:0], D};
	end
    end

    specify
	if (CE)
	    (CLK => Q) = (0, 0);
	if (CE)
	    (CLK => Q15) = (0, 0);
    endspecify

endmodule

