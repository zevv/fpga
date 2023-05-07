// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/GT_XAUI_4.v,v 1.15.6.1 2003/11/18 20:41:34 wloo Exp $
//**************************************************************
//  Copyright (c) 2002 Xilinx Inc.  All Rights Reserved
//  File Name    : GT_XAUI_4.v
//  Module Name  : GT_XAUI_4
//  Function     : Gigabit Transceiver
//  Site         : GT
//  Spec Version : 1.2
//  Generated by : write_verilog
//**************************************************************

`timescale 1 ps / 1 ps 

module GT_XAUI_4 (
	CHBONDDONE,
	CHBONDO,
	CONFIGOUT,
	RXBUFSTATUS,
	RXCHARISCOMMA,
	RXCHARISK,
	RXCHECKINGCRC,
	RXCLKCORCNT,
	RXCOMMADET,
	RXCRCERR,
	RXDATA,
	RXDISPERR,
	RXLOSSOFSYNC,
	RXNOTINTABLE,
	RXREALIGN,
	RXRECCLK,
	RXRUNDISP,
	TXBUFERR,
	TXKERR,
	TXN,
	TXP,
	TXRUNDISP,

	BREFCLK,
	BREFCLK2,
	CHBONDI,
	CONFIGENABLE,
	CONFIGIN,
	ENCHANSYNC,
	ENMCOMMAALIGN,
	ENPCOMMAALIGN,
	LOOPBACK,
	POWERDOWN,
	REFCLK,
	REFCLK2,
	REFCLKSEL,
	RXN,
	RXP,
	RXPOLARITY,
	RXRESET,
	RXUSRCLK,
	RXUSRCLK2,
	TXBYPASS8B10B,
	TXCHARDISPMODE,
	TXCHARDISPVAL,
	TXCHARISK,
	TXDATA,
	TXFORCECRCERR,
	TXINHIBIT,
	TXPOLARITY,
	TXRESET,
	TXUSRCLK,
	TXUSRCLK2
);

parameter CHAN_BOND_MODE = "OFF";
parameter CHAN_BOND_ONE_SHOT = "FALSE";
parameter CLK_COR_INSERT_IDLE_FLAG = "FALSE";
parameter CLK_COR_KEEP_IDLE = "FALSE";
parameter CLK_COR_REPEAT_WAIT = 1;
parameter CRC_END_OF_PKT = "K29_7";
parameter CRC_FORMAT = "USER_MODE";
parameter CRC_START_OF_PKT = "K27_7";
parameter REF_CLK_V_SEL = 0;
parameter RX_CRC_USE = "FALSE";
parameter RX_LOS_INVALID_INCR = 1;
parameter RX_LOS_THRESHOLD = 4;
parameter RX_LOSS_OF_SYNC_FSM = "TRUE";
parameter SERDES_10B = "FALSE";
parameter TERMINATION_IMP = 50;
parameter TX_CRC_FORCE_VALUE = 8'b11010110;
parameter TX_CRC_USE = "FALSE";
parameter TX_DIFF_CTRL = 500;
parameter TX_PREEMPHASIS = 0;

output CHBONDDONE;
output [3:0] CHBONDO;
output CONFIGOUT;
output [1:0] RXBUFSTATUS;
output [3:0] RXCHARISCOMMA;
output [3:0] RXCHARISK;
output RXCHECKINGCRC;
output [2:0] RXCLKCORCNT;
output RXCOMMADET;
output RXCRCERR;
output [31:0] RXDATA;
output [3:0] RXDISPERR;
output [1:0] RXLOSSOFSYNC;
output [3:0] RXNOTINTABLE;
output RXREALIGN;
output RXRECCLK;
output [3:0] RXRUNDISP;
output TXBUFERR;
output [3:0] TXKERR;
output TXN;
output TXP;
output [3:0] TXRUNDISP;

input BREFCLK;
input BREFCLK2;
input [3:0] CHBONDI;
input CONFIGENABLE;
input CONFIGIN;
input ENCHANSYNC;
input ENMCOMMAALIGN;
input ENPCOMMAALIGN;
input [1:0] LOOPBACK;
input POWERDOWN;
input REFCLK;
input REFCLK2;
input REFCLKSEL;
input RXN;
input RXP;
input RXPOLARITY;
input RXRESET;
input RXUSRCLK;
input RXUSRCLK2;
input [3:0] TXBYPASS8B10B;
input [3:0] TXCHARDISPMODE;
input [3:0] TXCHARDISPVAL;
input [3:0] TXCHARISK;
input [31:0] TXDATA;
input TXFORCECRCERR;
input TXINHIBIT;
input TXPOLARITY;
input TXRESET;
input TXUSRCLK;
input TXUSRCLK2;


GT gt_1 (
	.CHBONDDONE (CHBONDDONE),
	.CHBONDO (CHBONDO),
	.CONFIGOUT (CONFIGOUT),
	.RXBUFSTATUS (RXBUFSTATUS),
	.RXCHARISCOMMA (RXCHARISCOMMA),
	.RXCHARISK (RXCHARISK),
	.RXCHECKINGCRC (RXCHECKINGCRC),
	.RXCLKCORCNT (RXCLKCORCNT),
	.RXCOMMADET (RXCOMMADET),
	.RXCRCERR (RXCRCERR),
	.RXDATA (RXDATA),
	.RXDISPERR (RXDISPERR),
	.RXLOSSOFSYNC (RXLOSSOFSYNC),
	.RXNOTINTABLE (RXNOTINTABLE),
	.RXREALIGN (RXREALIGN),
	.RXRECCLK (RXRECCLK),
	.RXRUNDISP (RXRUNDISP),
	.TXBUFERR (TXBUFERR),
	.TXKERR (TXKERR),
	.TXN (TXN),
	.TXP (TXP),
	.TXRUNDISP (TXRUNDISP),
	.BREFCLK (BREFCLK),
	.BREFCLK2 (BREFCLK2),
	.CHBONDI (CHBONDI),
	.CONFIGENABLE (CONFIGENABLE),
	.CONFIGIN (CONFIGIN),
	.ENCHANSYNC (ENCHANSYNC),
	.ENMCOMMAALIGN (ENMCOMMAALIGN),
	.ENPCOMMAALIGN (ENPCOMMAALIGN),
	.LOOPBACK (LOOPBACK),
	.POWERDOWN (POWERDOWN),
	.REFCLK (REFCLK),
	.REFCLK2 (REFCLK2),
	.REFCLKSEL (REFCLKSEL),
	.RXN (RXN),
	.RXP (RXP),
	.RXPOLARITY (RXPOLARITY),
	.RXRESET (RXRESET),
	.RXUSRCLK (RXUSRCLK),
	.RXUSRCLK2 (RXUSRCLK2),
	.TXBYPASS8B10B (TXBYPASS8B10B),
	.TXCHARDISPMODE (TXCHARDISPMODE),
	.TXCHARDISPVAL (TXCHARDISPVAL),
	.TXCHARISK (TXCHARISK),
	.TXDATA (TXDATA),
	.TXFORCECRCERR (TXFORCECRCERR),
	.TXINHIBIT (TXINHIBIT),
	.TXPOLARITY (TXPOLARITY),
	.TXRESET (TXRESET),
	.TXUSRCLK (TXUSRCLK),
	.TXUSRCLK2 (TXUSRCLK2)
);

defparam gt_1.ALIGN_COMMA_MSB = "FALSE";
defparam gt_1.CHAN_BOND_LIMIT = 16;
defparam gt_1.CHAN_BOND_MODE = CHAN_BOND_MODE;
defparam gt_1.CHAN_BOND_OFFSET = 8;
defparam gt_1.CHAN_BOND_ONE_SHOT = CHAN_BOND_ONE_SHOT;
defparam gt_1.CHAN_BOND_SEQ_1_1 = 11'b00101111100;
defparam gt_1.CHAN_BOND_SEQ_1_2 = 11'b00000000000;
defparam gt_1.CHAN_BOND_SEQ_1_3 = 11'b00000000000;
defparam gt_1.CHAN_BOND_SEQ_1_4 = 11'b00000000000;
defparam gt_1.CHAN_BOND_SEQ_2_1 = 11'b00000000000;
defparam gt_1.CHAN_BOND_SEQ_2_2 = 11'b00000000000;
defparam gt_1.CHAN_BOND_SEQ_2_3 = 11'b00000000000;
defparam gt_1.CHAN_BOND_SEQ_2_4 = 11'b00000000000;
defparam gt_1.CHAN_BOND_SEQ_2_USE = "FALSE";
defparam gt_1.CHAN_BOND_SEQ_LEN = 1;
defparam gt_1.CHAN_BOND_WAIT = 8;
defparam gt_1.CLK_COR_INSERT_IDLE_FLAG = CLK_COR_INSERT_IDLE_FLAG;
defparam gt_1.CLK_COR_KEEP_IDLE = CLK_COR_KEEP_IDLE;
defparam gt_1.CLK_COR_REPEAT_WAIT = CLK_COR_REPEAT_WAIT;
defparam gt_1.CLK_COR_SEQ_1_1 = 11'b00100011100;
defparam gt_1.CLK_COR_SEQ_1_2 = 11'b00000000000;
defparam gt_1.CLK_COR_SEQ_1_3 = 11'b00000000000;
defparam gt_1.CLK_COR_SEQ_1_4 = 11'b00000000000;
defparam gt_1.CLK_COR_SEQ_2_1 = 11'b00000000000;
defparam gt_1.CLK_COR_SEQ_2_2 = 11'b00000000000;
defparam gt_1.CLK_COR_SEQ_2_3 = 11'b00000000000;
defparam gt_1.CLK_COR_SEQ_2_4 = 11'b00000000000;
defparam gt_1.CLK_COR_SEQ_2_USE = "FALSE";
defparam gt_1.CLK_COR_SEQ_LEN = 1;
defparam gt_1.CLK_CORRECT_USE = "TRUE";
defparam gt_1.COMMA_10B_MASK = 10'b1111111000;
defparam gt_1.CRC_END_OF_PKT = CRC_END_OF_PKT;
defparam gt_1.CRC_FORMAT = CRC_FORMAT;
defparam gt_1.CRC_START_OF_PKT = CRC_START_OF_PKT;
defparam gt_1.DEC_MCOMMA_DETECT = "TRUE";
defparam gt_1.DEC_PCOMMA_DETECT = "TRUE";
defparam gt_1.DEC_VALID_COMMA_ONLY = "TRUE";
defparam gt_1.MCOMMA_10B_VALUE = 10'b1100000000;
defparam gt_1.MCOMMA_DETECT = "TRUE";
defparam gt_1.PCOMMA_10B_VALUE = 10'b0011111000;
defparam gt_1.PCOMMA_DETECT = "TRUE";
defparam gt_1.REF_CLK_V_SEL = REF_CLK_V_SEL;
defparam gt_1.RX_BUFFER_USE = "TRUE";
defparam gt_1.RX_CRC_USE = RX_CRC_USE;
defparam gt_1.RX_DATA_WIDTH = 4;
defparam gt_1.RX_DECODE_USE = "TRUE";
defparam gt_1.RX_LOS_INVALID_INCR = RX_LOS_INVALID_INCR;
defparam gt_1.RX_LOS_THRESHOLD = RX_LOS_THRESHOLD;
defparam gt_1.RX_LOSS_OF_SYNC_FSM = RX_LOSS_OF_SYNC_FSM;
defparam gt_1.SERDES_10B = SERDES_10B;
defparam gt_1.TERMINATION_IMP = TERMINATION_IMP;
defparam gt_1.TX_BUFFER_USE = "TRUE";
defparam gt_1.TX_CRC_FORCE_VALUE = TX_CRC_FORCE_VALUE;
defparam gt_1.TX_CRC_USE = TX_CRC_USE;
defparam gt_1.TX_DATA_WIDTH = 4;
defparam gt_1.TX_DIFF_CTRL = TX_DIFF_CTRL;
defparam gt_1.TX_PREEMPHASIS = TX_PREEMPHASIS;

endmodule
