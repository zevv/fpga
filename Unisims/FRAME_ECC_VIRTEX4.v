//      Xilinx Proprietary Primitive Cell FRAME_ECC_VIRTEX4 for Verilog
//
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FRAME_ECC_VIRTEX4.v,v 1.1.4.4 2004/05/12 19:07:22 patrickp Exp $

`timescale  1 ps / 1 ps

module FRAME_ECC_VIRTEX4 (ERROR, SYNDROME, SYNDROMEVALID);

    output ERROR;
    output [11:0] SYNDROME;
    output SYNDROMEVALID;
    
endmodule // FRAME_ECC_VIRTEX4

