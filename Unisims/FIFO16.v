// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/FIFO16.v,v 1.12.4.7 2004/10/01 20:50:11 patrickp Exp $

`timescale 1 ps / 1 ps

module FIFO16 (ALMOSTEMPTY, ALMOSTFULL, DO, DOP, EMPTY, FULL, RDCOUNT, RDERR, WRCOUNT, WRERR, DI, DIP, RDCLK, RDEN, RST, WRCLK, WREN
);

    output ALMOSTEMPTY;
    output ALMOSTFULL;
    output [31:0] DO;
    output [3:0] DOP;
    output EMPTY;
    output FULL;
    output [11:0] RDCOUNT;
    output RDERR;
    output [11:0] WRCOUNT;
    output WRERR;

    input [31:0] DI;
    input [3:0] DIP;
    input RDCLK;
    input RDEN;
    input RST;
    input WRCLK;
    input WREN;

    parameter ALMOST_FULL_OFFSET = 12'h080;
    parameter ALMOST_EMPTY_OFFSET = 12'h080;
    parameter DATA_WIDTH = 36;
    parameter FIRST_WORD_FALL_THROUGH = "FALSE";

    tri0 GSR = glbl.GSR;

    reg [31:0] do_in, do_out;
    reg [3:0] dop_in, dop_out;
    reg almostempty_out, almostfull_out, empty_out, full_out, rderr_out, wrerr_out;
    reg [11:0] rdcount_out;

    wire [31:0] di_in;
    wire [3:0] dip_in;
    wire rdclk_in, rden_in, rst_in, wrclk_in, wren_in;

    reg rden_reg, wren_reg;
    reg [11:0] ae_empty;
    reg [31:0] d_w;
    reg [31:0] p_w;
    reg fwft;
    reg [16383:0] mem;
    reg [2047:0] memp;
    integer addr_limit, wr_addr, rd_addr, rd_prefetch;
    integer wr1_addr;
    reg rd_flag, rdcount_flag, rdprefetch_flag, wr_flag;
    reg wr1_flag;
    reg [3:0] almostfull_int, almostempty_int;
    reg [3:0] full_int;
    reg [3:0] empty_ram;
    reg [7:0] i, j;

    reg notifier;

    wire do_out0, do_out1, do_out2, do_out3, do_out4, do_out5, do_out6, do_out7, do_out8, do_out9, do_out10, do_out11, do_out12, do_out13, do_out14, do_out15, do_out16, do_out17, do_out18, do_out19, do_out20, do_out21, do_out22, do_out23, do_out24, do_out25, do_out26, do_out27, do_out28, do_out29, do_out30, do_out31, dop_out0, dop_out1, dop_out2, dop_out3;
    wire rdcount_out0, rdcount_out1, rdcount_out2, rdcount_out3, rdcount_out4, rdcount_out5, rdcount_out6, rdcount_out7, rdcount_out8, rdcount_out9, rdcount_out10, rdcount_out11;
    wire wrcount_out0, wrcount_out1, wrcount_out2, wrcount_out3, wrcount_out4, wrcount_out5, wrcount_out6, wrcount_out7, wrcount_out8, wrcount_out9, wrcount_out10, wrcount_out11;

    buf b_di_0 (di_in[0], DI[0]);
    buf b_di_1 (di_in[1], DI[1]);
    buf b_di_2 (di_in[2], DI[2]);
    buf b_di_3 (di_in[3], DI[3]);
    buf b_di_4 (di_in[4], DI[4]);
    buf b_di_5 (di_in[5], DI[5]);
    buf b_di_6 (di_in[6], DI[6]);
    buf b_di_7 (di_in[7], DI[7]);
    buf b_di_8 (di_in[8], DI[8]);
    buf b_di_9 (di_in[9], DI[9]);
    buf b_di_10 (di_in[10], DI[10]);
    buf b_di_11 (di_in[11], DI[11]);
    buf b_di_12 (di_in[12], DI[12]);
    buf b_di_13 (di_in[13], DI[13]);
    buf b_di_14 (di_in[14], DI[14]);
    buf b_di_15 (di_in[15], DI[15]);
    buf b_di_16 (di_in[16], DI[16]);
    buf b_di_17 (di_in[17], DI[17]);
    buf b_di_18 (di_in[18], DI[18]);
    buf b_di_19 (di_in[19], DI[19]);
    buf b_di_20 (di_in[20], DI[20]);
    buf b_di_21 (di_in[21], DI[21]);
    buf b_di_22 (di_in[22], DI[22]);
    buf b_di_23 (di_in[23], DI[23]);
    buf b_di_24 (di_in[24], DI[24]);
    buf b_di_25 (di_in[25], DI[25]);
    buf b_di_26 (di_in[26], DI[26]);
    buf b_di_27 (di_in[27], DI[27]);
    buf b_di_28 (di_in[28], DI[28]);
    buf b_di_29 (di_in[29], DI[29]);
    buf b_di_30 (di_in[30], DI[30]);
    buf b_di_31 (di_in[31], DI[31]);
    buf b_dip_0 (dip_in[0], DIP[0]);
    buf b_dip_1 (dip_in[1], DIP[1]);
    buf b_dip_2 (dip_in[2], DIP[2]);
    buf b_dip_3 (dip_in[3], DIP[3]);

    buf b_do_out0 (do_out0, do_out[0]);
    buf b_do_out1 (do_out1, do_out[1]);
    buf b_do_out2 (do_out2, do_out[2]);
    buf b_do_out3 (do_out3, do_out[3]);
    buf b_do_out4 (do_out4, do_out[4]);
    buf b_do_out5 (do_out5, do_out[5]);
    buf b_do_out6 (do_out6, do_out[6]);
    buf b_do_out7 (do_out7, do_out[7]);
    buf b_do_out8 (do_out8, do_out[8]);
    buf b_do_out9 (do_out9, do_out[9]);
    buf b_do_out10 (do_out10, do_out[10]);
    buf b_do_out11 (do_out11, do_out[11]);
    buf b_do_out12 (do_out12, do_out[12]);
    buf b_do_out13 (do_out13, do_out[13]);
    buf b_do_out14 (do_out14, do_out[14]);
    buf b_do_out15 (do_out15, do_out[15]);
    buf b_do_out16 (do_out16, do_out[16]);
    buf b_do_out17 (do_out17, do_out[17]);
    buf b_do_out18 (do_out18, do_out[18]);
    buf b_do_out19 (do_out19, do_out[19]);
    buf b_do_out20 (do_out20, do_out[20]);
    buf b_do_out21 (do_out21, do_out[21]);
    buf b_do_out22 (do_out22, do_out[22]);
    buf b_do_out23 (do_out23, do_out[23]);
    buf b_do_out24 (do_out24, do_out[24]);
    buf b_do_out25 (do_out25, do_out[25]);
    buf b_do_out26 (do_out26, do_out[26]);
    buf b_do_out27 (do_out27, do_out[27]);
    buf b_do_out28 (do_out28, do_out[28]);
    buf b_do_out29 (do_out29, do_out[29]);
    buf b_do_out30 (do_out30, do_out[30]);
    buf b_do_out31 (do_out31, do_out[31]);
    buf b_dop_out0 (dop_out0, dop_out[0]);
    buf b_dop_out1 (dop_out1, dop_out[1]);
    buf b_dop_out2 (dop_out2, dop_out[2]);
    buf b_dop_out3 (dop_out3, dop_out[3]);

    buf b_do0 (DO[0], do_out0);
    buf b_do1 (DO[1], do_out1);
    buf b_do2 (DO[2], do_out2);
    buf b_do3 (DO[3], do_out3);
    buf b_do4 (DO[4], do_out4);
    buf b_do5 (DO[5], do_out5);
    buf b_do6 (DO[6], do_out6);
    buf b_do7 (DO[7], do_out7);
    buf b_do8 (DO[8], do_out8);
    buf b_do9 (DO[9], do_out9);
    buf b_do10 (DO[10], do_out10);
    buf b_do11 (DO[11], do_out11);
    buf b_do12 (DO[12], do_out12);
    buf b_do13 (DO[13], do_out13);
    buf b_do14 (DO[14], do_out14);
    buf b_do15 (DO[15], do_out15);
    buf b_do16 (DO[16], do_out16);
    buf b_do17 (DO[17], do_out17);
    buf b_do18 (DO[18], do_out18);
    buf b_do19 (DO[19], do_out19);
    buf b_do20 (DO[20], do_out20);
    buf b_do21 (DO[21], do_out21);
    buf b_do22 (DO[22], do_out22);
    buf b_do23 (DO[23], do_out23);
    buf b_do24 (DO[24], do_out24);
    buf b_do25 (DO[25], do_out25);
    buf b_do26 (DO[26], do_out26);
    buf b_do27 (DO[27], do_out27);
    buf b_do28 (DO[28], do_out28);
    buf b_do29 (DO[29], do_out29);
    buf b_do30 (DO[30], do_out30);
    buf b_do31 (DO[31], do_out31);
    buf b_dop0 (DOP[0], dop_out0);
    buf b_dop1 (DOP[1], dop_out1);
    buf b_dop2 (DOP[2], dop_out2);
    buf b_dop3 (DOP[3], dop_out3);

    buf b_in3 (rdclk_in, RDCLK);
    buf b_in0 (rden_in, RDEN);
    buf b_in4 (rst_in, RST);
    buf b_in2 (wrclk_in, WRCLK);
    buf b_in1 (wren_in, WREN);
    buf b_in5 (gsr_in, GSR);

    buf b_out0 (ALMOSTEMPTY, almostempty_out);
    buf b_out1 (ALMOSTFULL, almostfull_out);
    buf b_out2 (EMPTY, empty_out);
    buf b_out3 (FULL, full_out);
    buf b_out4 (RDERR, rderr_out);
    buf b_out5 (WRERR, wrerr_out);

    buf b_rdcount_out0 (rdcount_out0, rdcount_out[0]);
    buf b_rdcount_out1 (rdcount_out1, rdcount_out[1]);
    buf b_rdcount_out2 (rdcount_out2, rdcount_out[2]);
    buf b_rdcount_out3 (rdcount_out3, rdcount_out[3]);
    buf b_rdcount_out4 (rdcount_out4, rdcount_out[4]);
    buf b_rdcount_out5 (rdcount_out5, rdcount_out[5]);
    buf b_rdcount_out6 (rdcount_out6, rdcount_out[6]);
    buf b_rdcount_out7 (rdcount_out7, rdcount_out[7]);
    buf b_rdcount_out8 (rdcount_out8, rdcount_out[8]);
    buf b_rdcount_out9 (rdcount_out9, rdcount_out[9]);
    buf b_rdcount_out10 (rdcount_out10, rdcount_out[10]);
    buf b_rdcount_out11 (rdcount_out11, rdcount_out[11]);
    buf b_rdcount0 (RDCOUNT[0], rdcount_out0);
    buf b_rdcount1 (RDCOUNT[1], rdcount_out1);
    buf b_rdcount2 (RDCOUNT[2], rdcount_out2);
    buf b_rdcount3 (RDCOUNT[3], rdcount_out3);
    buf b_rdcount4 (RDCOUNT[4], rdcount_out4);
    buf b_rdcount5 (RDCOUNT[5], rdcount_out5);
    buf b_rdcount6 (RDCOUNT[6], rdcount_out6);
    buf b_rdcount7 (RDCOUNT[7], rdcount_out7);
    buf b_rdcount8 (RDCOUNT[8], rdcount_out8);
    buf b_rdcount9 (RDCOUNT[9], rdcount_out9);
    buf b_rdcount10 (RDCOUNT[10], rdcount_out10);
    buf b_rdcount11 (RDCOUNT[11], rdcount_out11);
    buf b_wrcount_out0 (wrcount_out0, wr_addr[0]);
    buf b_wrcount_out1 (wrcount_out1, wr_addr[1]);
    buf b_wrcount_out2 (wrcount_out2, wr_addr[2]);
    buf b_wrcount_out3 (wrcount_out3, wr_addr[3]);
    buf b_wrcount_out4 (wrcount_out4, wr_addr[4]);
    buf b_wrcount_out5 (wrcount_out5, wr_addr[5]);
    buf b_wrcount_out6 (wrcount_out6, wr_addr[6]);
    buf b_wrcount_out7 (wrcount_out7, wr_addr[7]);
    buf b_wrcount_out8 (wrcount_out8, wr_addr[8]);
    buf b_wrcount_out9 (wrcount_out9, wr_addr[9]);
    buf b_wrcount_out10 (wrcount_out10, wr_addr[10]);
    buf b_wrcount_out11 (wrcount_out11, wr_addr[11]);
    buf b_wrcount0 (WRCOUNT[0], wrcount_out0);
    buf b_wrcount1 (WRCOUNT[1], wrcount_out1);
    buf b_wrcount2 (WRCOUNT[2], wrcount_out2);
    buf b_wrcount3 (WRCOUNT[3], wrcount_out3);
    buf b_wrcount4 (WRCOUNT[4], wrcount_out4);
    buf b_wrcount5 (WRCOUNT[5], wrcount_out5);
    buf b_wrcount6 (WRCOUNT[6], wrcount_out6);
    buf b_wrcount7 (WRCOUNT[7], wrcount_out7);
    buf b_wrcount8 (WRCOUNT[8], wrcount_out8);
    buf b_wrcount9 (WRCOUNT[9], wrcount_out9);
    buf b_wrcount10 (WRCOUNT[10], wrcount_out10);
    buf b_wrcount11 (WRCOUNT[11], wrcount_out11);

    always @(gsr_in)
	if (gsr_in == 1'b1) begin
	    assign do_out = 32'b00000000000000000000000000000000;
	    assign dop_out = 4'b0000;
	end
	else if (gsr_in == 1'b0) begin
	    deassign do_out;
	    deassign dop_out;
	end

    always @(gsr_in or rst_in)
	if (gsr_in == 1'b1 || rst_in == 1'b1) begin
	    assign almostempty_int = 4'b1111;
	    assign almostempty_out = 1'b1;
	    assign almostfull_int = 4'b0000;
	    assign almostfull_out = 1'b0;
	    assign do_in = 32'b00000000000000000000000000000000;
	    assign dop_in = 4'b0000;
	    assign empty_ram = 4'b1111;
	    assign empty_out = 1'b1;
	    assign full_int = 4'b0000;
	    assign full_out = 1'b0;
	    assign rdcount_out = 12'b0;
	    assign rderr_out = 0;
	    assign wrerr_out = 0;
	    assign rd_addr = 0;
	    assign rd_prefetch = 0;
	    assign wr_addr = 0;
	    assign wr1_addr = 0;
	    assign rdcount_flag = 0;
	    assign rd_flag = 0;
	    assign rdprefetch_flag = 0;
	    assign wr_flag = 0;
	    assign wr1_flag = 0;
	end
	else if (gsr_in == 1'b0 && rst_in == 1'b0) begin
	    deassign almostempty_int;
	    deassign almostempty_out;
	    deassign almostfull_int;
	    deassign almostfull_out;
	    deassign do_in;
	    deassign do_out;
	    deassign dop_in;
	    deassign dop_out;
	    deassign empty_ram;
	    deassign empty_out;
	    deassign full_int;
	    deassign full_out;
	    deassign rdcount_out;
	    deassign rderr_out;
	    deassign wrerr_out;
	    deassign rd_addr;
	    deassign rd_prefetch;
	    deassign wr_addr;
	    deassign wr1_addr;
	    deassign rdcount_flag;
	    deassign rd_flag;
	    deassign rdprefetch_flag;
	    deassign wr_flag;
	    deassign wr1_flag;
	end

    initial begin
	almostempty_int = 4'b1111;
	almostempty_out = 1'b1;
	almostfull_int = 4'b0000;
	almostfull_out = 1'b0;
	do_in = 32'b00000000000000000000000000000000;
	do_out = 32'b00000000000000000000000000000000;
	dop_in = 4'b0000;
	dop_out = 4'b0000;
	empty_ram = 4'b1111;
	empty_out = 1'b1;
	full_int = 4'b0000;
	full_out = 1'b0;
	rdcount_out = 12'b0;
	rderr_out = 0;
	wrerr_out = 0;

	rd_addr = 0;
	rd_prefetch = 0;
	wr_addr = 0;
	wr1_addr = 0;
	rdcount_flag = 0;
	rd_flag = 0;
	rdprefetch_flag = 0;
	wr_flag = 0;
	wr1_flag = 0;

	case (DATA_WIDTH)
	    4 : begin
		    addr_limit = 4096;
		    d_w = 4;
		    p_w = 0;
		end
	    9 : begin
		    addr_limit = 2048;
		    d_w = 8;
		    p_w = 1;
		end
	   18 : begin
		    addr_limit = 1024;
		    d_w = 16;
		    p_w = 2;
		end
	   36 : begin
		    addr_limit = 512;
		    d_w = 32;
		    p_w = 4;
		end
	   default :
		begin
		    $display("Attribute Syntax Error : The attribute DATA_WIDTH on FIFO16 instance %m is set to %d.  Legal values for this attribute are 4, 9, 18 or 36.", DATA_WIDTH);
		    $finish;
		end
	endcase

	case (FIRST_WORD_FALL_THROUGH)
	    "FALSE" : begin
		    fwft <= 0;
		    ae_empty <= ALMOST_EMPTY_OFFSET - 1;
		end
	    "TRUE"  : begin
		    fwft <= 1;
		    ae_empty <= ALMOST_EMPTY_OFFSET - 2;
		end
	    default : begin
		$display("Attribute Syntax Error : The attribute FIRST_WORD_FALL_THROUGH on FIFO16 instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", FIRST_WORD_FALL_THROUGH);
		$finish;
	      end
	endcase

	if ((fwft == 1'b0) && ((ALMOST_EMPTY_OFFSET < 5) || (ALMOST_EMPTY_OFFSET > addr_limit - 4)))
	    $display("Attribute Syntax Error : The attribute ALMOST_EMPTY_OFFSET on FIFO16 instance %m is set to %d.  Legal values for this attribute are %d to %d", ALMOST_EMPTY_OFFSET, 5, addr_limit - 4);
	if ((fwft == 1'b0) && ((ALMOST_FULL_OFFSET < 5) || (ALMOST_FULL_OFFSET > addr_limit - 4)))
	    $display("Attribute Syntax Error : The attribute ALMOST_FULL_OFFSET on FIFO16 instance %m is set to %d.  Legal values for this attribute are %d to %d", ALMOST_FULL_OFFSET, 5, addr_limit - 4);

	if ((fwft == 1'b1) && ((ALMOST_EMPTY_OFFSET < 6) || (ALMOST_EMPTY_OFFSET > addr_limit - 3)))
	    $display("Attribute Syntax Error : The attribute ALMOST_EMPTY_OFFSET on FIFO16 instance %m is set to %d.  Legal values for this attribute are %d to %d", ALMOST_EMPTY_OFFSET, 6, addr_limit - 3);
	if ((fwft == 1'b1) && ((ALMOST_FULL_OFFSET < 6) || (ALMOST_FULL_OFFSET > addr_limit - 3)))
	    $display("Attribute Syntax Error : The attribute ALMOST_FULL_OFFSET on FIFO16 instance %m is set to %d.  Legal values for this attribute are %d to %d", ALMOST_FULL_OFFSET, 6, addr_limit - 3);
    end

    always @(posedge rdclk_in) begin
	rden_reg = rden_in;
	if (fwft == 1'b0) begin
	    if ((rden_reg == 1'b1) && (rd_addr != rdcount_out)) begin
		do_out = do_in;
		dop_out = dop_in;
		rd_addr = (rd_addr + 1) % addr_limit;
		if (rd_addr == 0)
		    rd_flag = ~rd_flag;
	    end
	    if (((rd_addr == rdcount_out) && (empty_ram[3] == 1'b0)) ||
	       ((rden_reg == 1'b1) && (empty_ram[1] == 1'b0))) begin
		for (i = 0; i < d_w; i = i + 1) begin
		    do_in[i] = mem[rdcount_out * d_w + i];
		end
		for (i = 0; i < p_w; i = i + 1) begin
		    dop_in[i] = memp[rdcount_out * p_w + i];
		end
		#1;
		rdcount_out = (rdcount_out + 1) % addr_limit;
		if (rdcount_out == 0) begin
		    rdcount_flag = ~rdcount_flag;
		end
	    end
	end

	if (fwft == 1'b1) begin
	    if ((rden_reg == 1'b1) && (rd_addr != rd_prefetch)) begin
		rd_prefetch = (rd_prefetch + 1) % addr_limit;
		if (rd_prefetch == 0)
		    rdprefetch_flag = ~rdprefetch_flag;
	    end
	    if ((rd_prefetch == rd_addr) && (rd_addr != rdcount_out)) begin
		do_out = do_in;
		dop_out = dop_in;
		rd_addr = (rd_addr + 1) % addr_limit;
		if (rd_addr == 0)
		    rd_flag = ~rd_flag;
	    end
	    if (((rd_addr == rdcount_out) && (empty_ram[3] == 1'b0)) ||
	       ((rden_reg == 1'b1) && (empty_ram[1] == 1'b0)) ||
	       ((rden_reg == 1'b0) && (empty_ram[1] == 1'b0) && (rd_addr == rdcount_out))) begin
		for (i = 0; i < d_w; i = i + 1) begin
		    do_in[i] = mem[rdcount_out * d_w + i];
		end
		for (i = 0; i < p_w; i = i + 1) begin
		    dop_in[i] = memp[rdcount_out * p_w + i];
		end
		#1;
		rdcount_out = (rdcount_out + 1) % addr_limit;
		if (rdcount_out == 0)
		    rdcount_flag = ~rdcount_flag;
	    end
	end

	rderr_out = (rden_reg == 1'b1) && (empty_out == 1'b1);

	almostempty_out = almostempty_int[3];
	if ((((rdcount_out + ae_empty) >= wr_addr) && (rdcount_flag == wr_flag)) || (((rdcount_out + ae_empty) >= (wr_addr + addr_limit)) && (rdcount_flag != wr_flag))) begin
	    almostempty_int[3] = 1'b1;
	    almostempty_int[2] = 1'b1;
	    almostempty_int[1] = 1'b1;
	    almostempty_int[0] = 1'b1;
	end
	else if (almostempty_int[2] == 1'b0) begin
	    almostempty_int[3] = almostempty_int[0];
	    almostempty_int[0] = 1'b0;
	end

	if ((((rdcount_out + addr_limit) > (wr_addr + ALMOST_FULL_OFFSET)) && (rdcount_flag == wr_flag)) || ((rdcount_out > (wr_addr + ALMOST_FULL_OFFSET)) && (rdcount_flag != wr_flag))) begin
	    if (((rden_reg == 1'b1) && (empty_out == 1'b0)) || ((((rd_addr + 1) % addr_limit) == rdcount_out) && (almostfull_int[1] == 1'b1))) begin
		almostfull_int[2] = almostfull_int[1];
		almostfull_int[1] = 1'b0;
	    end
	end
	else begin
	    almostfull_int[2] = 1'b1;
	    almostfull_int[1] = 1'b1;
	end

	if (fwft == 1'b0) begin
	    if ((rdcount_out == rd_addr) && (rdcount_flag == rd_flag)) begin
		empty_out = 1'b1;
	    end
	    else begin
		empty_out = 1'b0;
	    end
	end
	else if (fwft == 1'b1) begin
	    if ((rd_prefetch == rd_addr) && (rdprefetch_flag == rd_flag)) begin
		empty_out = 1'b1;
	    end
	    else begin
		empty_out = 1'b0;
	    end
	end

	if ((rdcount_out == wr_addr) && (rdcount_flag == wr_flag)) begin
	    empty_ram[2] = 1'b1;
	    empty_ram[1] = 1'b1;
	    empty_ram[0] = 1'b1;
	end
	else begin
	    empty_ram[2] = empty_ram[1];
	    empty_ram[1] = empty_ram[0];
	    empty_ram[0] = 1'b0;
	end

	if ((rdcount_out == wr1_addr) && (rdcount_flag == wr1_flag)) begin
	    empty_ram[3] = 1'b1;
	end
	else begin
	    empty_ram[3] = 1'b0;
	end

	wr1_addr = wr_addr;
	wr1_flag = wr_flag;
    end

    always @(posedge wrclk_in) begin
	wren_reg = wren_in;
	if (wren_reg == 1'b1 && (full_int[1] == 1'b0)) begin
	    for (j = 0; j < d_w; j = j + 1) begin
		mem[wr_addr * d_w + j] = di_in[j];
	    end
	    for (j = 0; j < p_w; j = j + 1) begin
		memp[wr_addr * p_w + j] = dip_in[j];
	    end
	    #1;
	    wr_addr = (wr_addr + 1) % addr_limit;
	    if (wr_addr == 0)
		wr_flag = ~wr_flag;
	end
	wrerr_out = (wren_reg == 1'b1) && (full_int[1] == 1'b1);

	almostfull_out = almostfull_int[3];
	if ((((rdcount_out + addr_limit) <= (wr_addr + ALMOST_FULL_OFFSET)) && (rdcount_flag == wr_flag)) || ((rdcount_out <= (wr_addr + ALMOST_FULL_OFFSET)) && (rdcount_flag != wr_flag))) begin
	    almostfull_int[3] = 1'b1;
	    almostfull_int[2] = 1'b1;
	    almostfull_int[1] = 1'b1;
	    almostfull_int[0] = 1'b1;
	end
	else if (almostfull_int[2] == 1'b0) begin
	    almostfull_int[3] = almostfull_int[0];
	    almostfull_int[0] = 1'b0;
	end

	if ((((rdcount_out + ae_empty) < wr_addr) && (rdcount_flag == wr_flag)) || (((rdcount_out + ae_empty) < (wr_addr + addr_limit)) && (rdcount_flag != wr_flag))) begin
	    if (wren_reg == 1'b1) begin
		almostempty_int[2] = almostempty_int[1];
		almostempty_int[1] = 1'b0;
	    end
	end
	else begin
	    almostempty_int[2] = 1'b1;
	    almostempty_int[1] = 1'b1;
	end

	full_out = full_int[1];
	if ((rdcount_out == wr_addr) && (rdcount_flag != wr_flag)) begin
	    full_int[1] = 1'b1;
	    full_int[0] = 1'b1;
	end
	else begin
	    full_int[1] = full_int[0];
	    full_int[0] = 0;
	end
    end

    always @(notifier) begin
	do_out <= 32'bx;
	dop_out <= 4'bx;
    end

    specify
	specparam PATHPULSE$ = 0;

	(RDCLK => ALMOSTEMPTY) = (100:100:100, 100:100:100);
	(RDCLK => DOP[0]) = (100:100:100, 100:100:100);
	(RDCLK => DOP[1]) = (100:100:100, 100:100:100);
	(RDCLK => DOP[2]) = (100:100:100, 100:100:100);
	(RDCLK => DOP[3]) = (100:100:100, 100:100:100);
	(RDCLK => DO[0]) = (100:100:100, 100:100:100);
	(RDCLK => DO[10]) = (100:100:100, 100:100:100);
	(RDCLK => DO[11]) = (100:100:100, 100:100:100);
	(RDCLK => DO[12]) = (100:100:100, 100:100:100);
	(RDCLK => DO[13]) = (100:100:100, 100:100:100);
	(RDCLK => DO[14]) = (100:100:100, 100:100:100);
	(RDCLK => DO[15]) = (100:100:100, 100:100:100);
	(RDCLK => DO[16]) = (100:100:100, 100:100:100);
	(RDCLK => DO[17]) = (100:100:100, 100:100:100);
	(RDCLK => DO[18]) = (100:100:100, 100:100:100);
	(RDCLK => DO[19]) = (100:100:100, 100:100:100);
	(RDCLK => DO[1]) = (100:100:100, 100:100:100);
	(RDCLK => DO[20]) = (100:100:100, 100:100:100);
	(RDCLK => DO[21]) = (100:100:100, 100:100:100);
	(RDCLK => DO[22]) = (100:100:100, 100:100:100);
	(RDCLK => DO[23]) = (100:100:100, 100:100:100);
	(RDCLK => DO[24]) = (100:100:100, 100:100:100);
	(RDCLK => DO[25]) = (100:100:100, 100:100:100);
	(RDCLK => DO[26]) = (100:100:100, 100:100:100);
	(RDCLK => DO[27]) = (100:100:100, 100:100:100);
	(RDCLK => DO[28]) = (100:100:100, 100:100:100);
	(RDCLK => DO[29]) = (100:100:100, 100:100:100);
	(RDCLK => DO[2]) = (100:100:100, 100:100:100);
	(RDCLK => DO[30]) = (100:100:100, 100:100:100);
	(RDCLK => DO[31]) = (100:100:100, 100:100:100);
	(RDCLK => DO[3]) = (100:100:100, 100:100:100);
	(RDCLK => DO[4]) = (100:100:100, 100:100:100);
	(RDCLK => DO[5]) = (100:100:100, 100:100:100);
	(RDCLK => DO[6]) = (100:100:100, 100:100:100);
	(RDCLK => DO[7]) = (100:100:100, 100:100:100);
	(RDCLK => DO[8]) = (100:100:100, 100:100:100);
	(RDCLK => DO[9]) = (100:100:100, 100:100:100);
	(RDCLK => EMPTY) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[0]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[10]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[11]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[1]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[2]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[3]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[4]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[5]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[6]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[7]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[8]) = (100:100:100, 100:100:100);
	(RDCLK => RDCOUNT[9]) = (100:100:100, 100:100:100);
	(RDCLK => RDERR) = (100:100:100, 100:100:100);
	(WRCLK => ALMOSTFULL) = (100:100:100, 100:100:100);
	(WRCLK => FULL) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[0]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[10]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[11]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[1]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[2]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[3]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[4]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[5]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[6]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[7]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[8]) = (100:100:100, 100:100:100);
	(WRCLK => WRCOUNT[9]) = (100:100:100, 100:100:100);
	(WRCLK => WRERR) = (100:100:100, 100:100:100);
    endspecify

endmodule
