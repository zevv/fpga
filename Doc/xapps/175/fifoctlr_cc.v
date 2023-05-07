
/***********************************************************************\
*                                                                       *
*  Module      : fifoctlr_cc.v                   Last Update: 12/13/99  *
*                                                                       *
*  Description : FIFO controller top level.                             *
*                Implements a 511x8 FIFO with common read/write clocks. *
*                                                                       *
*  The following Verilog code implements a 511x8 FIFO in a Spartan-II   *
*  device.  The inputs are a Clock, a Read Enable, a Write Enable,      *
*  Write Data, and a FIFO_gsr signal as an initial reset.  The outputs  *
*  are Read Data, Full, Empty, and the FIFOcount outputs, which         *
*  indicate roughly how full the FIFO is.                               *
*                                                                       *
\***********************************************************************/

`timescale 1ns / 10ps

`define DATA_WIDTH 7:0
`define ADDR_WIDTH 8:0

module fifoctlr_cc (clock_in, read_enable_in, write_enable_in, 
                    write_data_in, fifo_gsr_in, read_data_out, 
                    full_out, empty_out, fifocount_out );

input clock_in, read_enable_in, write_enable_in, fifo_gsr_in;
input  [`DATA_WIDTH] write_data_in;
output [`DATA_WIDTH] read_data_out;
output full_out, empty_out;
output [3:0] fifocount_out;

wire read_enable = read_enable_in;
wire write_enable = write_enable_in;
wire fifo_gsr = fifo_gsr_in;
wire [`DATA_WIDTH] write_data = write_data_in;
wire [`DATA_WIDTH] read_data;
assign read_data_out = read_data;
reg full, empty;
assign full_out = full;
assign empty_out = empty;

reg [`ADDR_WIDTH] read_addr, write_addr, fcounter;

wire read_allow, write_allow;

assign read_allow = (read_enable && ! empty);
assign write_allow = (write_enable && ! full);

wire gnd = 0;
wire pwr = 1;

/**********************************************************************\
*                                                                      *
* A global buffer is instantianted to avoid skew problems.             * 
*                                                                      *
\**********************************************************************/
 
BUFGP gclk1 (.I(clock_in), .O(clock));

/**********************************************************************\
*                                                                      *
* Block RAM instantiation for FIFO.  Module is 512x8, of which one     * 
* address location is sacrificed for the overall speed of the design.  *
*                                                                      *
\**********************************************************************/

RAMB4_S8_S8 bram1 ( .ADDRA(read_addr), .ADDRB(write_addr), .DIB(write_data), 
                    .DIA({gnd, gnd, gnd, gnd, gnd, gnd, gnd, gnd}), 
                    .WEA(gnd), .WEB(write_allow), .CLKA(clock), 
                    .CLKB(clock), .RSTA(gnd), .RSTB(gnd), 
                    .ENA(read_allow), .ENB(pwr), .DOA(read_data) );

/***********************************************************\
*                                                           *
*  Empty flag is set on fifo_gsr (initial), or when on the  *
*  next clock cycle, Write Enable is low, and either the    *
*  FIFOcount is equal to 0, or it is equal to 1 and Read    *
*  Enable is high (about to go Empty).                      *
*                                                           *
\***********************************************************/

always @(posedge clock or posedge fifo_gsr)
   if (fifo_gsr) empty <= 1;
   else empty <= (! write_enable && (fcounter[8:1] == 8'h0) && 
                  ((fcounter[0] == 0) || read_enable));

/***********************************************************\
*                                                           *
*  Full flag is set on fifo_gsr (but it is cleared on the   *
*  first valid clock edge after fifo_gsr is removed), or    *
*  when on the next clock cycle, Read Enable is low, and    *
*  either the FIFOcount is equal to 1FF (hex), or it is     *
*  equal to 1FE and the Write Enable is high (about to go   *
*  Full).                                                   *
*                                                           *
\***********************************************************/

always @(posedge clock or posedge fifo_gsr)
   if (fifo_gsr) full <= 1;
   else full <= (! read_enable && (fcounter[8:1] == 8'hFF) && 
                 ((fcounter[0] == 1) || write_enable));

/************************************************************\
*                                                            *
*  Generation of Read and Write address pointers.  They use  *
*  LFSR counters, which are very fast.  Because of the       *
*  nature of LFSRs, one address is sacrificed.               *
*                                                            *
\************************************************************/

wire read_linearfeedback, write_linearfeedback;

assign read_linearfeedback =  ! (read_addr[8] ^ read_addr[4]); 
assign write_linearfeedback = ! (write_addr[8] ^ write_addr[4]);

always @(posedge clock or posedge fifo_gsr)
   if (fifo_gsr) read_addr <= 'h0;
   else if (read_allow)
      read_addr <= { read_addr[7], read_addr[6], read_addr[5], 
                     read_addr[4], read_addr[3], read_addr[2], 
                     read_addr[1], read_addr[0], read_linearfeedback };

always @(posedge clock or posedge fifo_gsr)
   if (fifo_gsr) write_addr <= 'h0;
   else if (write_allow)
      write_addr <= { write_addr[7], write_addr[6], write_addr[5], 
                      write_addr[4], write_addr[3], write_addr[2], 
                      write_addr[1], write_addr[0], write_linearfeedback };

/************************************************************\
*                                                            *
*  Generation of FIFOcount outputs.  Used to determine how   *
*  full FIFO is, based on a counter that keeps track of how  *
*  many words are in the FIFO.  Also used to generate Full   *
*  and Empty flags.  Only the upper four bits of the counter *
*  are sent outside the module.                              *
*                                                            *
\************************************************************/

always @(posedge clock or posedge fifo_gsr)
   if (fifo_gsr) fcounter <= 'h0;
   else if ((! read_allow && write_allow) || (read_allow && ! write_allow))
      begin
         if (write_allow)      fcounter <= fcounter + 1;
         else                  fcounter <= fcounter - 1;
      end

assign fifocount_out = fcounter[8:5];

endmodule


