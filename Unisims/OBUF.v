// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/OBUF.v,v 1.12.2.3 2004/06/02 22:04:26 patrickp Exp $

/*

FUNCTION	: OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps


module OBUF (O, I);

    parameter CAPACITANCE = "DONT_CARE";
    parameter DRIVE = 12;
    parameter IOSTANDARD = "DEFAULT";
    parameter SLEW = "SLOW";
   
    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    bufif0 B1 (O, I, GTS);

    initial begin
	
        case (CAPACITANCE)

            "LOW", "NORMAL", "DONT_CARE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute CAPACITANCE on OBUF instance %m is set to %s.  Legal values for this attribute are DONT_CARE, LOW or NORMAL.", CAPACITANCE);
                          $finish;
                      end

        endcase

    end
    
endmodule




