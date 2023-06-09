//      Xilinx Proprietary Primitive Cell IDELAYCTRL for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/IDELAYCTRL.v,v 1.1.4.4 2004/05/12 19:07:23 patrickp Exp $

`timescale 1 ps / 1 ps 

module IDELAYCTRL (RDY, REFCLK, RST);

    output RDY;

    input REFCLK;
    input RST;

    wire refclk_in;
    wire rst_in;

    time clock_edge;
    reg [63:0] period;
    reg clock_low, clock_high;
    reg clock_posedge, clock_negedge;
    reg lost, rdy_out;

    buf b_rdy (RDY, rdy_out);
    buf b_refclk (refclk_in, REFCLK);
    buf b_rst (rst_in, RST);
    

    always @(rst_in) begin

	if (rst_in == 1'b1)
	    
	    rdy_out <= 1'b0;

	else if (rst_in == 1'b0 && lost == 0)

	    rdy_out <= 1'b1;

    end

    
    always @(posedge lost) begin

	rdy_out <= 1'b0;

    end
    
	
    initial begin
	clock_edge <= 0;
	clock_high <= 0;
	clock_low <= 0;
	lost <= 1;
	period <= 0;
    end


    always @(posedge refclk_in) begin
	clock_edge <= $time;
	if (period != 0 && (($time - clock_edge) <= (1.5 * period)))
	    period <= $time - clock_edge;
	else if (period != 0 && (($time - clock_edge) > (1.5 * period)))
	    period <= 0;
	else if ((period == 0) && (clock_edge != 0))
	    period <= $time - clock_edge;
    end
    
    always @(posedge refclk_in) begin
	clock_low <= 1'b0;
	clock_high <= 1'b1;
	if (period != 0)
	    lost <= 1'b0;
	clock_posedge <= 1'b0;
	#((period * 9.1) / 10)
	if ((clock_low != 1'b1) && (clock_posedge != 1'b1))
	    lost <= 1;
    end
    
    always @(posedge refclk_in) begin
	clock_negedge <= 1'b1;
    end
    
    always @(negedge refclk_in) begin
	clock_posedge <= 1'b1;
    end
    
    always @(negedge refclk_in) begin
	clock_high  <= 1'b0;
	clock_low   <= 1'b1;
	if (period != 0)
	    lost <= 1'b0;
	clock_negedge <= 1'b0;
	#((period * 9.1) / 10)
	if ((clock_high != 1'b1) && (clock_negedge != 1'b1))
	    lost <= 1;
    end

    specify

	(REFCLK => RDY) = (100, 100);
	specparam PATHPULSE$ = 0;
    
    endspecify

endmodule // IDELAYCTRL


