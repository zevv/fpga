//    Xilinx Proprietary Primitive Cell BUFGMUX_VIRTEX4 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/BUFGMUX_VIRTEX4.v,v 1.1.2.6 2004/05/12 19:07:22 patrickp Exp $
//

`timescale 1 ps / 1 ps 

module BUFGMUX_VIRTEX4 (O, I0, I1, S);

    output O;
    
    input  I0;
    input  I1;
    input  S;

    BUFGCTRL bufgctrl_inst (.O(O), .CE0(1'b1), .CE1(1'b1), .I0(I0), .I1(I1), .IGNORE0(1'b0), .IGNORE1(1'b0), .S0(~S), .S1(S));
    
    defparam bufgctrl_inst.INIT_OUT = 1'b0;
    defparam bufgctrl_inst.PRESELECT_I0 = "TRUE";
    defparam bufgctrl_inst.PRESELECT_I1 = "FALSE";
    
endmodule
