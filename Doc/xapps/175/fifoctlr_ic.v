
/***********************************************************************\
*                                                                       *
*  Module      : fifoctlr_ic.v                   Last Update: 12/13/99  *
*                                                                       *
*  Description : FIFO controller top level.                             *
*                Implements a 511x8 FIFO with independent read/write    *
*                clocks.                                                *
*                                                                       *
*  The following Verilog code implements a 511x8 FIFO in a Spartan-II   *
*  device.  The inputs are a Read Clock and Read Enable, a Write Clock  * 
*  and Write Enable, Write Data, and a FIFO_gsr signal as an initial    *
*  reset.  The outputs are Read Data, Full, Empty, and the FIFOstatus   *
*  outputs, which indicate roughly how full the FIFO is.                *
*                                                                       *
\***********************************************************************/

`timescale 1ns / 10ps

`define DATA_WIDTH 7:0
`define ADDR_WIDTH 8:0

module fifoctlr_ic (read_clock_in, write_clock_in, read_enable_in, 
                    write_enable_in, fifo_gsr_in, write_data_in, 
                    read_data_out, fifostatus_out, full_out, 
                    empty_out);

input read_clock_in, write_clock_in;
input read_enable_in, write_enable_in;
input fifo_gsr_in;
input  [`DATA_WIDTH] write_data_in;
output [`DATA_WIDTH] read_data_out;
output [4:0] fifostatus_out;
output full_out, empty_out;

wire read_enable = read_enable_in;
wire write_enable = write_enable_in;
wire fifo_gsr = fifo_gsr_in;
wire [`DATA_WIDTH] write_data = write_data_in;
wire [`DATA_WIDTH] read_data;
assign read_data_out = read_data;
reg [4:0] fifostatus;
assign fifostatus_out = fifostatus;
reg full, empty;
assign full_out = full;
assign empty_out = empty;

reg [`ADDR_WIDTH] read_addr, write_addr;
reg [`ADDR_WIDTH] write_addrgray, write_nextgray;
reg [`ADDR_WIDTH] read_addrgray, read_nextgray, read_lastgray;

wire read_allow, write_allow;

wire [`ADDR_WIDTH] ecomp, aecomp, fcomp, afcomp;
wire [`ADDR_WIDTH] emuxcyo, aemuxcyo, fmuxcyo, afmuxcyo;

wire emptyg, almostemptyg, fullg, almostfullg;
wire tempo1, tempo2, tempo3, tempo4;
wire ecin, fcin, aecin, afcin;

wire gnd = 0;
wire pwr = 1;

/**********************************************************************\
*                                                                      *
* Global input clock buffers are instantianted for both the read_clock *
* and the write_clock, to avoid skew problems.                         *
*                                                                      *
\**********************************************************************/

BUFGP gclkread (.I(read_clock_in), .O(read_clock));
BUFGP gclkwrite (.I(write_clock_in), .O(write_clock));

/**********************************************************************\
*                                                                      *
* Block RAM instantiation for FIFO.  Module is 512x8, of which one     *
* address location is sacrificed for the overall speed of the design.  *
*                                                                      *
\**********************************************************************/

RAMB4_S8_S8 bram1 ( .ADDRA(read_addr), .ADDRB(write_addr), .DIB(write_data), 
                    .DIA({gnd, gnd, gnd, gnd, gnd, gnd, gnd, gnd}), 
                    .WEA(gnd), .WEB(write_allow), .CLKA(read_clock), 
                    .CLKB(write_clock), .RSTA(gnd), .RSTB(gnd), 
                    .ENA(read_allow), .ENB(pwr), .DOA(read_data) );

/***********************************************************\
*                                                           *
*  Empty flag is set on fifo_gsr (initial), or when gray    *
*  code counters are equal, or when there is one word in    *
*  the FIFO, and a Read operation is about to be performed. *
*                                                           *
\***********************************************************/

always @(posedge read_clock or posedge fifo_gsr)
   if (fifo_gsr) empty <= 'b1;
   else empty <= (emptyg || (almostemptyg && read_enable && ! empty));

/***********************************************************\
*                                                           *
*  Full flag is set on fifo_gsr (initial, but it is cleared *
*  on the first valid write_clock edge after fifo_gsr is    *
*  de-asserted), or when Gray-code counters are one away    *
*  from being equal (the Write Gray-code address is equal   *
*  to the Last Read Gray-code address), or when the Next    *
*  Write Gray-code address is equal to the Last Read Gray-  *
*  code address, and a Write operation is about to be       *
*  performed.                                               *
*                                                           *
\***********************************************************/

always @(posedge write_clock or posedge fifo_gsr)
   if (fifo_gsr) full <= 'b1;
   else full <= (fullg || (almostfullg && write_enable && ! full));

/************************************************************\
*                                                            *
*  Generation of Read address pointers.  The primary one is  *
*  binary (read_addr), and the Gray-code derivatives are     *
*  generated via pipelining the binary-to-Gray-code result.  *
*  The initial values are important, so they're in sequence. *
*  Grey-code addresses are used so that the registered       *
*  Full and Empty flags are always clean, and never in an    *
*  unknown state due to the asynchonous relationship of the  *
*  Read and Write clocks.  In the worst case scenario, Full  *
*  and Empty would simply stay active one cycle longer, but  *
*  it would not generate an error or give false values.      *
*                                                            *
\************************************************************/

always @(posedge read_clock or posedge fifo_gsr)
   if (fifo_gsr) read_addr <= 'h0;
   else if (read_allow) read_addr <= read_addr + 1;

always @(posedge read_clock or posedge fifo_gsr)
   if (fifo_gsr) read_nextgray <= 9'b100000000;
   else if (read_allow) 
      read_nextgray <= { read_addr[8], (read_addr[8] ^ read_addr[7]), 
           (read_addr[7] ^ read_addr[6]), (read_addr[6] ^ read_addr[5]),
           (read_addr[5] ^ read_addr[4]), (read_addr[4] ^ read_addr[3]),
           (read_addr[3] ^ read_addr[2]), (read_addr[2] ^ read_addr[1]),
           (read_addr[1] ^ read_addr[0]) };

always @(posedge read_clock or posedge fifo_gsr)
   if (fifo_gsr) read_addrgray <= 9'b100000001;
   else if (read_allow) read_addrgray <= read_nextgray;

always @(posedge read_clock or posedge fifo_gsr)
   if (fifo_gsr) read_lastgray <= 9'b100000011;
   else if (read_allow) read_lastgray <= read_addrgray;

/************************************************************\
*                                                            *
*  Generation of Write address pointers.  Identical copy of  *
*  read pointer generation above, except for names.          *
*                                                            *
\************************************************************/

always @(posedge write_clock or posedge fifo_gsr)
   if (fifo_gsr) write_addr <= 'h0;
   else if (write_allow) write_addr <= write_addr + 1;

always @(posedge write_clock or posedge fifo_gsr)
   if (fifo_gsr) write_nextgray <= 9'b100000000;
   else if (write_allow) 
      write_nextgray <= { write_addr[8], (write_addr[8] ^ write_addr[7]), 
           (write_addr[7] ^ write_addr[6]), (write_addr[6] ^ write_addr[5]),
           (write_addr[5] ^ write_addr[4]), (write_addr[4] ^ write_addr[3]),
           (write_addr[3] ^ write_addr[2]), (write_addr[2] ^ write_addr[1]),
           (write_addr[1] ^ write_addr[0]) };

always @(posedge write_clock or posedge fifo_gsr)
   if (fifo_gsr) write_addrgray <= 9'b100000001;
   else if (write_allow) write_addrgray <= write_nextgray;

/************************************************************\
*                                                            *
*  Generation of FIFOstatus outputs.  Used to determine how  *
*  full FIFO is, based on how far the Write pointer is ahead *
*  of the Read pointer.  Additional precision can be gained  *
*  by using additional (top) bits of Gray-code addresses.    *
*                                                            *
\************************************************************/

always @(posedge write_clock or posedge fifo_gsr)  
// for 0 to 1/4 full (quads equal)
   if (fifo_gsr) fifostatus[0] <= 'b1;
   else fifostatus[0] <= (read_addrgray[8:7] == write_addrgray[8:7]) && 
                         ! (fifostatus[3] || fifostatus[4]);

always @(posedge write_clock or posedge fifo_gsr)  
// for 1 byte to 1/2 full  (quad 1 ahead)
   if (fifo_gsr) fifostatus[1] <= 'b0;
   else fifostatus[1] <= 
        ((read_addrgray[8:7]=='b00)&&(write_addrgray[8:7]=='b01)) ||
        ((read_addrgray[8:7]=='b01)&&(write_addrgray[8:7]=='b11)) ||
        ((read_addrgray[8:7]=='b11)&&(write_addrgray[8:7]=='b10)) ||
        ((read_addrgray[8:7]=='b10)&&(write_addrgray[8:7]=='b00));

always @(posedge write_clock or posedge fifo_gsr)  
// for 1/4 to 3/4 full (quad 2 ahead)
   if (fifo_gsr) fifostatus[2] <= 'b0;
   else fifostatus[2] <= 
        ((read_addrgray[8:7]=='b00)&&(write_addrgray[8:7]=='b11)) ||
        ((read_addrgray[8:7]=='b01)&&(write_addrgray[8:7]=='b10)) ||
        ((read_addrgray[8:7]=='b11)&&(write_addrgray[8:7]=='b00)) ||
        ((read_addrgray[8:7]=='b10)&&(write_addrgray[8:7]=='b01));

always @(posedge write_clock or posedge fifo_gsr)  
// for 1/2 to full (quad 3 ahead)
   if (fifo_gsr) fifostatus[3] <= 'b0;
   else fifostatus[3] <= 
        ((read_addrgray[8:7]=='b00)&&(write_addrgray[8:7]=='b10)) ||
        ((read_addrgray[8:7]=='b01)&&(write_addrgray[8:7]=='b00)) ||
        ((read_addrgray[8:7]=='b11)&&(write_addrgray[8:7]=='b01)) ||
        ((read_addrgray[8:7]=='b10)&&(write_addrgray[8:7]=='b11));

always @(posedge write_clock or posedge fifo_gsr)  
// for 3/4 to full (quad 4 ahead/equal)
   if (fifo_gsr) fifostatus[4] <= 'b0;
   else fifostatus[4] <= (read_addrgray[8:7] == write_addrgray[8:7]) && 
                         (fifostatus[3] || fifostatus[4]);
     
/************************************************************\
*                                                            *
*  Allow flags determine whether FIFO control logic can      *
*  operate.  If read_enable is driven high, and the FIFO is  *
*  not Empty, then Reads are allowed.  Similarly, if the     *
*  write_enable signal is high, and the FIFO is not Full,    *
*  then Writes are allowed.                                  *
*                                                            *
\************************************************************/

assign read_allow = (read_enable && ! empty);
assign write_allow = (write_enable && ! full);

/************************************************************\
*                                                            *
*  The four conditions decoded with special carry logic are  *
*  Empty, AlmostEmpty, Full, and AlmostFull.  These are      *
*  used to determine the next state of the Full/Empty        *
*  flags.  Carry logic is used for optimal speed.            *
*                                                            *
*  When the Write/Read Gray-code addresses are equal, the    *
*  FIFO is Empty, and emptyg (combinatorial) is asserted.    *
*  When the Write Gray-code address is equal to the Next     *
*  Read Gray-code address (1 word in the FIFO), then the     *
*  FIFO potentially could be going Empty (if read_enable is  *
*  asserted, which is used in the logic that generates the   *
*  registered version of Empty).                             *
*                                                            *
*  Similarly, when the Write Gray-code address is equal to   *
*  the Last Read Gray-code address, the FIFO is full.  To    *
*  have utilized the full address space (512 addresses)      *
*  would have required extra logic to determine Full/Empty   *
*  on equal addresses, and this would have slowed down the   *
*  overall performance.  Lastly, when the Next Write Gray-   *
*  code address is equal to the Last Read Gray-code address  *
*  the FIFO is Almost Full, with only one word left, and     *
*  it is conditional on write_enable being asserted.         *
*                                                            *
\************************************************************/

assign ecomp[0] = (write_addrgray[0] == read_addrgray[0]);
assign ecomp[1] = (write_addrgray[1] == read_addrgray[1]);
assign ecomp[2] = (write_addrgray[2] == read_addrgray[2]);
assign ecomp[3] = (write_addrgray[3] == read_addrgray[3]);
assign ecomp[4] = (write_addrgray[4] == read_addrgray[4]);
assign ecomp[5] = (write_addrgray[5] == read_addrgray[5]);
assign ecomp[6] = (write_addrgray[6] == read_addrgray[6]);
assign ecomp[7] = (write_addrgray[7] == read_addrgray[7]);
assign ecomp[8] = (write_addrgray[8] == read_addrgray[8]);

MUXCY_L emuxcyi (.DI(pwr), .CI(pwr),        .S(pwr),      .LO(ecin));
MUXCY_L emuxcy0 (.DI(gnd), .CI(ecin),       .S(ecomp[0]), .LO(emuxcyo[0]));
MUXCY_L emuxcy1 (.DI(gnd), .CI(emuxcyo[0]), .S(ecomp[1]), .LO(emuxcyo[1]));
MUXCY_L emuxcy2 (.DI(gnd), .CI(emuxcyo[1]), .S(ecomp[2]), .LO(emuxcyo[2]));
MUXCY_L emuxcy3 (.DI(gnd), .CI(emuxcyo[2]), .S(ecomp[3]), .LO(emuxcyo[3]));
MUXCY_L emuxcy4 (.DI(gnd), .CI(emuxcyo[3]), .S(ecomp[4]), .LO(emuxcyo[4]));
MUXCY_L emuxcy5 (.DI(gnd), .CI(emuxcyo[4]), .S(ecomp[5]), .LO(emuxcyo[5]));
MUXCY_L emuxcy6 (.DI(gnd), .CI(emuxcyo[5]), .S(ecomp[6]), .LO(emuxcyo[6]));
MUXCY_L emuxcy7 (.DI(gnd), .CI(emuxcyo[6]), .S(ecomp[7]), .LO(emuxcyo[7]));
MUXCY_L emuxcy8 (.DI(gnd), .CI(emuxcyo[7]), .S(ecomp[8]), .LO(emptyg));

assign aecomp[0] = (write_addrgray[0] == read_nextgray[0]);
assign aecomp[1] = (write_addrgray[1] == read_nextgray[1]);
assign aecomp[2] = (write_addrgray[2] == read_nextgray[2]);
assign aecomp[3] = (write_addrgray[3] == read_nextgray[3]);
assign aecomp[4] = (write_addrgray[4] == read_nextgray[4]);
assign aecomp[5] = (write_addrgray[5] == read_nextgray[5]);
assign aecomp[6] = (write_addrgray[6] == read_nextgray[6]);
assign aecomp[7] = (write_addrgray[7] == read_nextgray[7]);
assign aecomp[8] = (write_addrgray[8] == read_nextgray[8]);

MUXCY_L aemuxcyi (.DI(pwr), .CI(pwr),         .S(pwr),       .LO(aecin));
MUXCY_L aemuxcy0 (.DI(gnd), .CI(aecin),       .S(aecomp[0]), .LO(aemuxcyo[0]));
MUXCY_L aemuxcy1 (.DI(gnd), .CI(aemuxcyo[0]), .S(aecomp[1]), .LO(aemuxcyo[1]));
MUXCY_L aemuxcy2 (.DI(gnd), .CI(aemuxcyo[1]), .S(aecomp[2]), .LO(aemuxcyo[2]));
MUXCY_L aemuxcy3 (.DI(gnd), .CI(aemuxcyo[2]), .S(aecomp[3]), .LO(aemuxcyo[3]));
MUXCY_L aemuxcy4 (.DI(gnd), .CI(aemuxcyo[3]), .S(aecomp[4]), .LO(aemuxcyo[4]));
MUXCY_L aemuxcy5 (.DI(gnd), .CI(aemuxcyo[4]), .S(aecomp[5]), .LO(aemuxcyo[5]));
MUXCY_L aemuxcy6 (.DI(gnd), .CI(aemuxcyo[5]), .S(aecomp[6]), .LO(aemuxcyo[6]));
MUXCY_L aemuxcy7 (.DI(gnd), .CI(aemuxcyo[6]), .S(aecomp[7]), .LO(aemuxcyo[7]));
MUXCY_L aemuxcy8 (.DI(gnd), .CI(aemuxcyo[7]), .S(aecomp[8]), .LO(almostemptyg));

assign fcomp[0] = (write_addrgray[0] == read_lastgray[0]);
assign fcomp[1] = (write_addrgray[1] == read_lastgray[1]);
assign fcomp[2] = (write_addrgray[2] == read_lastgray[2]);
assign fcomp[3] = (write_addrgray[3] == read_lastgray[3]);
assign fcomp[4] = (write_addrgray[4] == read_lastgray[4]);
assign fcomp[5] = (write_addrgray[5] == read_lastgray[5]);
assign fcomp[6] = (write_addrgray[6] == read_lastgray[6]);
assign fcomp[7] = (write_addrgray[7] == read_lastgray[7]);
assign fcomp[8] = (write_addrgray[8] == read_lastgray[8]);

MUXCY_L fmuxcyi (.DI(pwr), .CI(pwr),        .S(pwr),      .LO(fcin));
MUXCY_L fmuxcy0 (.DI(gnd), .CI(fcin),       .S(fcomp[0]), .LO(fmuxcyo[0]));
MUXCY_L fmuxcy1 (.DI(gnd), .CI(fmuxcyo[0]), .S(fcomp[1]), .LO(fmuxcyo[1]));
MUXCY_L fmuxcy2 (.DI(gnd), .CI(fmuxcyo[1]), .S(fcomp[2]), .LO(fmuxcyo[2]));
MUXCY_L fmuxcy3 (.DI(gnd), .CI(fmuxcyo[2]), .S(fcomp[3]), .LO(fmuxcyo[3]));
MUXCY_L fmuxcy4 (.DI(gnd), .CI(fmuxcyo[3]), .S(fcomp[4]), .LO(fmuxcyo[4]));
MUXCY_L fmuxcy5 (.DI(gnd), .CI(fmuxcyo[4]), .S(fcomp[5]), .LO(fmuxcyo[5]));
MUXCY_L fmuxcy6 (.DI(gnd), .CI(fmuxcyo[5]), .S(fcomp[6]), .LO(fmuxcyo[6]));
MUXCY_L fmuxcy7 (.DI(gnd), .CI(fmuxcyo[6]), .S(fcomp[7]), .LO(fmuxcyo[7]));
MUXCY_L fmuxcy8 (.DI(gnd), .CI(fmuxcyo[7]), .S(fcomp[8]), .LO(fullg));

assign afcomp[0] = (write_nextgray[0] == read_lastgray[0]);
assign afcomp[1] = (write_nextgray[1] == read_lastgray[1]);
assign afcomp[2] = (write_nextgray[2] == read_lastgray[2]);
assign afcomp[3] = (write_nextgray[3] == read_lastgray[3]);
assign afcomp[4] = (write_nextgray[4] == read_lastgray[4]);
assign afcomp[5] = (write_nextgray[5] == read_lastgray[5]);
assign afcomp[6] = (write_nextgray[6] == read_lastgray[6]);
assign afcomp[7] = (write_nextgray[7] == read_lastgray[7]);
assign afcomp[8] = (write_nextgray[8] == read_lastgray[8]);

MUXCY_L afmuxcyi (.DI(pwr), .CI(pwr),         .S(pwr),       .LO(afcin));
MUXCY_L afmuxcy0 (.DI(gnd), .CI(afcin),       .S(afcomp[0]), .LO(afmuxcyo[0]));
MUXCY_L afmuxcy1 (.DI(gnd), .CI(afmuxcyo[0]), .S(afcomp[1]), .LO(afmuxcyo[1]));
MUXCY_L afmuxcy2 (.DI(gnd), .CI(afmuxcyo[1]), .S(afcomp[2]), .LO(afmuxcyo[2]));
MUXCY_L afmuxcy3 (.DI(gnd), .CI(afmuxcyo[2]), .S(afcomp[3]), .LO(afmuxcyo[3]));
MUXCY_L afmuxcy4 (.DI(gnd), .CI(afmuxcyo[3]), .S(afcomp[4]), .LO(afmuxcyo[4]));
MUXCY_L afmuxcy5 (.DI(gnd), .CI(afmuxcyo[4]), .S(afcomp[5]), .LO(afmuxcyo[5]));
MUXCY_L afmuxcy6 (.DI(gnd), .CI(afmuxcyo[5]), .S(afcomp[6]), .LO(afmuxcyo[6]));
MUXCY_L afmuxcy7 (.DI(gnd), .CI(afmuxcyo[6]), .S(afcomp[7]), .LO(afmuxcyo[7]));
MUXCY_L afmuxcy8 (.DI(gnd), .CI(afmuxcyo[7]), .S(afcomp[8]), .LO(almostfullg));

endmodule

