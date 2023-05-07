// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/Attic/RAMB32_S64_ECC.v,v 1.1.2.1 2004/05/12 20:53:45 patrickp Exp $
//**************************************************************
//  Copyright (c) 2002 Xilinx Inc.  All Rights Reserved
//  File Name    : RAMB32_S64_ECC.v
//  Module Name  : RAMB32_S64_ECC
//  Site         : RAMB32_S64_ECC
//  Spec Version : 1.3
//  Generated by : write_verilog
//**************************************************************

`timescale 1 ps / 1 ps

module RAMB32_S64_ECC (
 DO,
 STATUS,

 DI,
 RDADDR,
 RDCLK,
 RDEN,
 SSR,
 WRADDR,
 WRCLK,
 WREN
);

output [1:0] STATUS;
output [63:0] DO;

input RDCLK;
input RDEN;
input SSR;
input WRCLK;
input WREN;
input [63:0] DI;
input [8:0]  RDADDR;
input [8:0]  WRADDR;

tri0 GSR = glbl.GSR;

reg [63:0]   DO;
wire [31:0]  do_ram16low;
wire [31:0]  do_ram16up;
wire [3:0]   dopa_ram16low;
wire [3:0]   dopa_ram16up;

reg [31:0]   DIB_up;
reg [31:0]   DIB_low;
reg [3:0]    DIPB_up;
reg [3:0]    DIPB_low;

wire [31:0]  DOB_low_open;
wire [3:0]   DOPB_low_open;
wire         CASCADEOUTA_low_open;
wire         CASCADEOUTB_low_open;
wire [31:0]  DOB_up_open;
wire [3:0]   DOPB_up_open;
wire         CASCADEOUTA_up_open;
wire         CASCADEOUTB_up_open;


always @(do_ram16low or  do_ram16up  or dopa_ram16low or dopa_ram16up)

  begin
     DO[13:0] <= do_ram16low[13:0];
     DO[14] <= dopa_ram16low[1];
     DO[15] <= dopa_ram16low[3];
     DO[29:16] <= do_ram16low[29:16];
     DO[30] <= dopa_ram16low[0];
     DO[31] <= dopa_ram16low[2];

     DO[32] <= dopa_ram16up[0];
     DO[33] <= dopa_ram16up[2];
     DO[47:34] <= do_ram16up[15:2];
     DO[48] <= dopa_ram16up[1];
     DO[49] <= dopa_ram16up[3];
     DO[63:50] <= do_ram16up[31:18];
  end

always @(DI)
  begin
     DIB_low [13:0] <=  DI[13:0];
     DIB_low [15:14] <= 2'b00;
     DIPB_low[1]    <=  DI[14];
     DIPB_low[3]    <=  DI[15];
     DIB_low[29:16] <=  DI[29:16];
     DIB_low[31:30] <= 2'b00;
     DIPB_low[0]    <=  DI[30];
     DIPB_low[2]    <=  DI[31];

     DIPB_up[0]     <=  DI[32];
     DIPB_up[2]     <=  DI[33];
     DIB_up[15:2]   <=  DI[47:34];
     DIB_up[1:0]     <= 2'b00;
     DIPB_up[1]     <=  DI[48];
     DIPB_up[3]     <=  DI[49];
     DIB_up[17:16]  <= 2'b00;
     DIB_up[31:18]  <=  DI[63:50];
  end


  assign STATUS = 2'b00;

  RAMB16      ramb16_low (
//    .ADDRA ({RDADDR, 6'b000000}),
//    .ADDRB ({WRADDR, 6'b111111}),
    .ADDRA ({1'b0, RDADDR, 5'b00000}),
    .ADDRB ({1'b0, WRADDR, 5'b00000}),
    .DIA   (32'b0),
    .DIB   (DIB_low),
    .DIPA  (4'b0),
    .DIPB  (DIPB_low),
    .ENA   (RDEN),
    .ENB   (WREN),
    .WEA   (4'b0),
    .WEB   (4'b1111),
    .SSRA  (SSR),
    .SSRB  (1'b0),
    .CLKA  (RDCLK),
    .CLKB  (WRCLK),
    .REGCEA (1'b0),
    .REGCEB (1'b0),
    .CASCADEINA (1'b0),
    .CASCADEINB (1'b0),
    .DOA   (do_ram16low),
    .DOB   (DOB_low_open),
    .DOPA  (dopa_ram16low),
    .DOPB  (DOPB_low_open),
    .CASCADEOUTA (CASCADEOUTA_low_open),
    .CASCADEOUTB (CASCADEOUTB_low_open)
    );

defparam ramb16_low.READ_WIDTH_A = 36;
defparam ramb16_low.WRITE_WIDTH_A = 36;
defparam ramb16_low.READ_WIDTH_B = 36;
defparam ramb16_low.WRITE_WIDTH_B = 36;
defparam ramb16_low.WRITE_MODE_A = "NO_CHANGE";
defparam ramb16_low.WRITE_MODE_B = "NO_CHANGE";
defparam ramb16_low.INIT_A = 36'b0;
defparam ramb16_low.SRVAL_A = 36'b0;
defparam ramb16_low.INIT_B = 36'b0;
defparam ramb16_low.SRVAL_B = 36'b0;
defparam ramb16_low.DOA_REG = 0;
defparam ramb16_low.DOB_REG = 0;
defparam ramb16_low.INVERT_CLK_DOA_REG = "FALSE";
defparam ramb16_low.INVERT_CLK_DOB_REG = "FALSE";
defparam ramb16_low.RAM_EXTENSION_A = "NONE";
defparam ramb16_low.RAM_EXTENSION_B = "NONE";
//defparam ramb16_low.EN_ECC_WRITE" = "TRUE";
//defparam ramb16_low.EN_ECC_READ" = "TRUE";

  RAMB16      ramb16_up (
//    .ADDRA ({RDADDR, 6'b000000}),
//    .ADDRB ({WRADDR, 6'b111111}),
    .ADDRA ({1'b0, RDADDR, 5'b00000}),
    .ADDRB ({1'b0, WRADDR, 5'b00000}),
    .DIA   (32'b0),
    .DIB   (DIB_up),
    .DIPA  (4'b0),
    .DIPB  (DIPB_up),
    .ENA   (RDEN),
    .ENB   (WREN),
    .WEA   (4'b0),
    .WEB   (4'b1111),
    .SSRA  (SSR),
    .SSRB  (1'b0),
    .CLKA  (RDCLK),
    .CLKB  (WRCLK),
    .REGCEA (1'b0),
    .REGCEB (1'b0),
    .CASCADEINA (1'b0),
    .CASCADEINB (1'b0),
    .DOA   (do_ram16up),
    .DOB   (DOB_up_open),
    .DOPA  (dopa_ram16up),
    .DOPB  (DOPB_up_open),
    .CASCADEOUTA (CASCADEOUTA_up_open),
    .CASCADEOUTB (CASCADEOUTB_up_open)

    );

defparam ramb16_up.READ_WIDTH_A = 36;
defparam ramb16_up.WRITE_WIDTH_A = 36;
defparam ramb16_up.READ_WIDTH_B = 36;
defparam ramb16_up.WRITE_WIDTH_B = 36;
defparam ramb16_up.WRITE_MODE_A = "NO_CHANGE";
defparam ramb16_up.WRITE_MODE_B = "NO_CHANGE";
defparam ramb16_up.INIT_A = 36'b0;
defparam ramb16_up.SRVAL_A = 36'b0;
defparam ramb16_up.INIT_B = 36'b0;
defparam ramb16_up.SRVAL_B = 36'b0;
defparam ramb16_up.DOA_REG = 0;
defparam ramb16_up.DOB_REG = 0;
defparam ramb16_up.INVERT_CLK_DOA_REG = "FALSE";
defparam ramb16_up.INVERT_CLK_DOB_REG = "FALSE";
defparam ramb16_up.RAM_EXTENSION_A = "NONE";
defparam ramb16_up.RAM_EXTENSION_B = "NONE";
//defparam ramb16_up.EN_ECC_WRITE" = "TRUE";
//defparam ramb16_up.EN_ECC_READ" = "TRUE";
endmodule