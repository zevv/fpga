// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/DCM_BASE.v,v 1.6.2.10 2004/08/09 16:23:21 patrickp Exp $
//**************************************************************
//  Copyright (c) 2002 Xilinx Inc.  All Rights Reserved
//  File Name    : DCM_BASE.v
//  Module Name  : DCM_BASE
//  Site         : DCM_ADV
//  Spec Version : 2.4
//  Generated by : write_verilog
//**************************************************************

`timescale 1 ps / 1 ps 

module DCM_BASE (
	CLK0,
	CLK180,
	CLK270,
	CLK2X,
	CLK2X180,
	CLK90,
	CLKDV,
	CLKFX,
	CLKFX180,
	LOCKED,
	CLKFB,
	CLKIN,
	RST
);

parameter CLKDV_DIVIDE = 2.0;
parameter CLKFX_DIVIDE = 1;
parameter CLKFX_MULTIPLY = 4;
parameter CLKIN_DIVIDE_BY_2 = "FALSE";
parameter CLKIN_PERIOD = 10.0;
parameter CLKOUT_PHASE_SHIFT = "NONE";
parameter CLK_FEEDBACK = "1X";
parameter DCM_PERFORMANCE_MODE = "MAX_SPEED";
parameter DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
parameter DFS_FREQUENCY_MODE = "LOW";
parameter DLL_FREQUENCY_MODE = "LOW";
parameter DUTY_CYCLE_CORRECTION = "TRUE";
parameter FACTORY_JF = 16'hC080;
parameter PHASE_SHIFT = 0;
parameter STARTUP_WAIT = "FALSE";


output CLK0;
output CLK180;
output CLK270;
output CLK2X180;
output CLK2X;
output CLK90;
output CLKDV;
output CLKFX180;
output CLKFX;
output LOCKED;

input CLKFB;
input CLKIN;
input RST;

wire OPEN_DRDY;
wire OPEN_PSDONE;
wire [15:0] OPEN_DO;

initial
begin
   if (CLKOUT_PHASE_SHIFT != "NONE" && CLKOUT_PHASE_SHIFT != "FIXED")
     begin
     $display(" Attribute Syntax Error :The attribute CLKOUT_PHASE_SHIFT on DCM_BASE instance %m is set to %s.  Legal values for this attribute is NONE or FIXED", CLKOUT_PHASE_SHIFT);
        $finish;
     end

   if (CLK_FEEDBACK != "NONE" && CLK_FEEDBACK != "1X")
        begin
            $display("Attribute Syntax Error : The attribute CLK_FEEDBACK on DCM_BASE instance %m is set to %s.  Legal values for this attribute are NONE or 1X.", CLK_FEEDBACK);
            $finish;
        end

end


DCM_ADV dcm_adv_1 (
	.CLK0 (CLK0),
	.CLK180 (CLK180),
	.CLK270 (CLK270),
	.CLK2X (CLK2X),
	.CLK2X180 (CLK2X180),
	.CLK90 (CLK90),
	.CLKDV (CLKDV),
	.CLKFB (CLKFB),
	.CLKFX (CLKFX),
	.CLKFX180 (CLKFX180),
	.CLKIN (CLKIN),
	.DO (OPEN_DO),
	.DRDY (OPEN_DRDY),
	.LOCKED (LOCKED),
        .DADDR (7'b0000000),
        .DCLK (1'b0),
        .DEN (1'b0),
        .DI (16'h0000),
        .DWE (1'b0),
	.PSDONE (OPEN_PSDONE),
        .PSCLK (1'b0),
        .PSEN (1'b0),
        .PSINCDEC (1'b0),
	.RST (RST)
);

defparam dcm_adv_1.CLKDV_DIVIDE = CLKDV_DIVIDE;
defparam dcm_adv_1.CLKFX_DIVIDE = CLKFX_DIVIDE;
defparam dcm_adv_1.CLKFX_MULTIPLY = CLKFX_MULTIPLY;
defparam dcm_adv_1.CLKIN_DIVIDE_BY_2 = CLKIN_DIVIDE_BY_2;
defparam dcm_adv_1.CLKIN_PERIOD = CLKIN_PERIOD;
defparam dcm_adv_1.CLKOUT_PHASE_SHIFT = CLKOUT_PHASE_SHIFT;
defparam dcm_adv_1.CLK_FEEDBACK = CLK_FEEDBACK;
defparam dcm_adv_1.DCM_PERFORMANCE_MODE = DCM_PERFORMANCE_MODE;
defparam dcm_adv_1.DESKEW_ADJUST = DESKEW_ADJUST;
defparam dcm_adv_1.DFS_FREQUENCY_MODE = DFS_FREQUENCY_MODE;
defparam dcm_adv_1.DLL_FREQUENCY_MODE = DLL_FREQUENCY_MODE;
defparam dcm_adv_1.DUTY_CYCLE_CORRECTION = DUTY_CYCLE_CORRECTION;
defparam dcm_adv_1.FACTORY_JF = FACTORY_JF;
defparam dcm_adv_1.PHASE_SHIFT = PHASE_SHIFT;
defparam dcm_adv_1.STARTUP_WAIT = STARTUP_WAIT;

endmodule
