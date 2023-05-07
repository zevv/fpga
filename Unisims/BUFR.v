//      Xilinx Proprietary Primitive Cell BUFR for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/BUFR.v,v 1.2.4.7 2004/05/12 19:07:22 patrickp Exp $

`timescale  1 ps / 1 ps

module BUFR (O, CE, CLR, I);

    output O;

    input CE;
    input CLR;
    tri0 GSR = glbl.GSR;
    input I;

    parameter BUFR_DIVIDE = "BYPASS";
    
    integer count, period_toggle, half_period_toggle;    
    reg first_rise, half_period_done;
    reg o_out, o_out_divide;
    reg ce_enable1, ce_enable2, ce_enable3, ce_enable4;
    
    buf buf_i (i_in, I);
    buf buf_ce (ce_in, CE);
    buf buf_clr (clr_in, CLR);
    buf buf_gsr (gsr_in, GSR);    
    buf buf_o (O, o_out);

    
    initial begin
	case (BUFR_DIVIDE)
	    "BYPASS" : period_toggle = 0;
	    "1" : begin 
		    period_toggle = 1;
		    half_period_toggle = 1;
	          end
	    "2" : begin 
		    period_toggle = 2;
		    half_period_toggle = 2;
	          end
	    "3" : begin 
		    period_toggle = 4;
		    half_period_toggle = 2;
	          end
	    "4" : begin
		    period_toggle = 4;
		    half_period_toggle = 4;
		  end
	    "5" : begin 
		    period_toggle = 6;
		    half_period_toggle = 4;
		  end
	    "6" : begin 
		    period_toggle = 6;
		    half_period_toggle = 6;
		  end
	    "7" : begin 
		    period_toggle = 8;
		    half_period_toggle = 6;
		  end
	    "8" : begin 
		    period_toggle = 8;
		    half_period_toggle = 8;
	          end
	    default : begin 
		          $display("Attribute Syntax Error : The attribute BUFR_DIVIDE on BUFR instance %m is set to %s.  Legal values for this attribute are BYPASS, 1, 2, 3, 4, 5, 6, 7 or 8.", BUFR_DIVIDE);
	                  $finish;
	    end
	endcase // case(BUFR_DIVIDE)
    end // initial begin
    

    always @(gsr_in or clr_in)
	if (gsr_in == 1'b1 || clr_in == 1'b1) begin
	    assign o_out_divide = 1'b0;
	    assign count = 0;
	    assign first_rise = 1'b1;
	    assign half_period_done = 1'b0;
	    if (gsr_in == 1'b1) begin
		assign ce_enable1 = 1'b0;
		assign ce_enable2 = 1'b0;
		assign ce_enable3 = 1'b0;
		assign ce_enable4 = 1'b0;
	    end	    
	end	
	else if (gsr_in == 1'b0 || clr_in == 1'b0) begin
	    deassign o_out_divide;	    
	    deassign count;
	    deassign first_rise;
	    deassign half_period_done;
	    if (gsr_in == 1'b0) begin
		deassign ce_enable1;
		deassign ce_enable2;
		deassign ce_enable3;
		deassign ce_enable4;
	    end    
	end
    

    always @(negedge i_in) begin
	ce_enable1 <= ce_in;
	ce_enable2 <= ce_enable1;
	ce_enable3 <= ce_enable2;
	ce_enable4 <= ce_enable3;
    end

    
    always @(i_in)
        if (ce_enable4 == 1'b1) begin
	    if (i_in == 1'b1 && first_rise == 1'b1) begin
		o_out_divide = 1'b1;
		first_rise = 1'b0;
	    end
	    else if (count == half_period_toggle && half_period_done == 1'b0) begin
		o_out_divide = ~o_out_divide;
		half_period_done = 1'b1;
	        count = 0;	
	    end
	    else if (count == period_toggle && half_period_done == 1'b1) begin
		o_out_divide = ~o_out_divide;
		half_period_done = 1'b0;
	        count = 0;
	    end

            if (first_rise == 1'b0)
		count = count + 1;
	end // if (ce_in == 1'b1)
    

    always @(o_out_divide or i_in)
	if (period_toggle == 0)
	    o_out = i_in;
	else
	    o_out = o_out_divide;


    
endmodule // BUFR
