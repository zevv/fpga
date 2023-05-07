
module hot(rst, clk, o, oclk);

	input rst;
	input clk;
	output o;
	output oclk;
	
	wire o;
	wire oclk;

	wire CLK0;
	wire CLK2X;
	wire CLKFX;
	wire CLKFB;
	wire CLKIN;
	
	assign o = CLKFX;
	assign CLKIN = clk;
	assign oclk = clk;

	BUFG BUFG(CLKFB, CLK0);

  DCM DCM_inst (
      .CLK0(CLK0),     // 0 degree DCM CLK ouptput
      .CLK2X(CLK2X),   // 2X DCM CLK output
      .CLKFX(CLKFX),
      .CLKFB(CLKFB),   // DCM clock feedback
      .CLKIN(CLKIN),   // Clock input (from IBUFG, BUFG or DCM)
                        
      .RST(rst)        // DCM asynchronous reset input
   );

   defparam DCM_inst.CLKFX_DIVIDE = 6.0; 
   defparam DCM_inst.CLKFX_MULTIPLY = 2.0;
   defparam DCM_inst.CLKIN_PERIOD = 20;

endmodule
		