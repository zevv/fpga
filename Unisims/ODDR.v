//      Xilinx Proprietary Primitive Cell ODDR for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ODDR.v,v 1.2.4.6 2004/05/12 19:07:23 patrickp Exp $

`timescale 1 ps / 1 ps

module ODDR (Q, C, CE, D1, D2, R, S);
    
    output Q;
    
    input C;
    input CE;
    input D1;
    input D2;    
    tri0 GSR = glbl.GSR;
    input R;
    input S;

    parameter DDR_CLK_EDGE = "OPPOSITE_EDGE";    
    parameter INIT = 1'b0;
    parameter SRTYPE = "SYNC";

    reg q_out, qd2_posedge_int;    
    
    buf buf_c (c_in, C);
    buf buf_ce (ce_in, CE);
    buf buf_d1 (d1_in, D1);
    buf buf_d2 (d2_in, D2);    
    buf buf_gsr (gsr_in, GSR);
    buf buf_q (Q, q_out);
    buf buf_r (r_in, R);
    buf buf_s (s_in, S);    


    initial begin

	if ((INIT != 0) && (INIT != 1)) begin
	    $display("Attribute Syntax Error : The attribute INIT on ODDR instance %m is set to %d.  Legal values for this attribute are 0 or 1.", INIT);
	    $finish;
	end
	
    	if ((DDR_CLK_EDGE != "OPPOSITE_EDGE") && (DDR_CLK_EDGE != "SAME_EDGE")) begin
	    $display("Attribute Syntax Error : The attribute DDR_CLK_EDGE on ODDR instance %m is set to %s.  Legal values for this attribute are OPPOSITE_EDGE or SAME_EDGE.", DDR_CLK_EDGE);
	    $finish;
	end
	
	if ((SRTYPE != "ASYNC") && (SRTYPE != "SYNC")) begin
	    $display("Attribute Syntax Error : The attribute SRTYPE on ODDR instance %m is set to %s.  Legal values for this attribute are ASYNC or SYNC.", SRTYPE);
	    $finish;
	end

    end // initial begin
    

    always @(gsr_in or r_in or s_in) begin
	if (gsr_in == 1'b1) begin
	    assign q_out = INIT;
	    assign qd2_posedge_int = INIT;
	end
	else if (gsr_in == 1'b0) begin
	    if (r_in == 1'b1 && SRTYPE == "ASYNC") begin
		assign q_out = 1'b0;
		assign qd2_posedge_int = 1'b0;
	    end
	    else if (r_in == 1'b0 && s_in == 1'b1 && SRTYPE == "ASYNC") begin
		assign q_out = 1'b1;
		assign qd2_posedge_int = 1'b1;
	    end
	    else if ((r_in == 1'b1 || s_in == 1'b1) && SRTYPE == "SYNC") begin
		deassign q_out;
		deassign qd2_posedge_int;
	    end	    
	    else if (r_in == 1'b0 && s_in == 1'b0) begin
		deassign q_out;
		deassign qd2_posedge_int;
	    end
	end // if (gsr_in == 1'b0)
    end // always @ (gsr_in or r_in or s_in)

	    
    always @(posedge c_in) begin
 	if (r_in == 1'b1) begin
	    q_out <= 1'b0;
	    qd2_posedge_int <= 1'b0;
	end
	else if (r_in == 1'b0 && s_in == 1'b1) begin
	    q_out <= 1'b1;
	    qd2_posedge_int <= 1'b1;
	end
	else if (ce_in == 1'b1 && r_in == 1'b0 && s_in == 1'b0) begin
	    q_out <= d1_in;
	    qd2_posedge_int <= d2_in;
	end
    end // always @ (posedge c_in)
    
	
    always @(negedge c_in) begin
	if (r_in == 1'b1)
	    q_out <= 1'b0;
	else if (r_in == 1'b0 && s_in == 1'b1)
	    q_out <= 1'b1;
	else if (ce_in == 1'b1 && r_in == 1'b0 && s_in == 1'b0) begin
	    if (DDR_CLK_EDGE == "SAME_EDGE")
		q_out <= qd2_posedge_int;
	    else if (DDR_CLK_EDGE == "OPPOSITE_EDGE")
		q_out <= d2_in;
	end
    end // always @ (negedge c_in)
    
    
    specify

	(C => Q) = (100, 100);
	specparam PATHPULSE$ = 0;

    endspecify

endmodule // ODDR
