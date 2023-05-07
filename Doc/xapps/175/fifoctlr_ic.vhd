
---------------------------------------------------------------------------
--                                                                       --
--  Module      : fifoctlr_ic.vhd                 Last Update: 12/13/99  --
--                                                                       --
--  Description : FIFO controller top level.                             --
--                Implements a 511x8 FIFO with independent read/write    --
--                clocks.                                                --
--                                                                       --
--  The following VHDL code implements a 511x8 FIFO in a Spartan-II      --
--  device.  The inputs are a Read Clock and Read Enable, a Write Clock  -- 
--  and Write Enable, Write Data, and a FIFO_gsr signal as an initial    --
--  reset.  The outputs are Read Data, Full, Empty, and the FIFOstatus   --
--  outputs, which indicate roughly how full the FIFO is.                --
--                                                                       --
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity fifoctlr_ic is
   port (read_clock_in:   IN  std_logic;
         write_clock_in:  IN  std_logic;
         read_enable_in:  IN  std_logic;
         write_enable_in: IN  std_logic;
         fifo_gsr_in:     IN  std_logic;
         write_data_in:   IN  std_logic_vector(7 downto 0);
         read_data_out:   OUT std_logic_vector(7 downto 0);
         full_out:        OUT std_logic;
         empty_out:       OUT std_logic;
         fifostatus_out:  OUT std_logic_vector(4 downto 0));
END fifoctlr_ic;

architecture fifoctlr_ic_hdl of fifoctlr_ic is
   signal read_clock:            std_logic;
   signal write_clock:           std_logic;
   signal read_enable:           std_logic;
   signal write_enable:          std_logic;
   signal fifo_gsr:              std_logic;
   signal read_data:             std_logic_vector(7 downto 0);
   signal write_data:            std_logic_vector(7 downto 0);
   signal full:                  std_logic;
   signal empty:                 std_logic;
   signal read_addr:             std_logic_vector(8 downto 0);
   signal read_addrgray:         std_logic_vector(8 downto 0);
   signal read_nextgray:         std_logic_vector(8 downto 0);
   signal read_lastgray:         std_logic_vector(8 downto 0);
   signal write_addr:            std_logic_vector(8 downto 0);
   signal write_addrgray:        std_logic_vector(8 downto 0);
   signal write_nextgray:        std_logic_vector(8 downto 0);
   signal fifostatus:            std_logic_vector(4 downto 0);
   signal read_allow:            std_logic;
   signal write_allow:           std_logic;
   signal ecomp:                 std_logic_vector(8 downto 0);
   signal aecomp:                std_logic_vector(8 downto 0);
   signal fcomp:                 std_logic_vector(8 downto 0);
   signal afcomp:                std_logic_vector(8 downto 0);
   signal emuxcyo:               std_logic_vector(8 downto 0);
   signal aemuxcyo:              std_logic_vector(8 downto 0);
   signal fmuxcyo:               std_logic_vector(8 downto 0);
   signal afmuxcyo:              std_logic_vector(8 downto 0);
   signal emptyg:                std_logic;
   signal almostemptyg:          std_logic;
   signal fullg:                 std_logic;
   signal almostfullg:           std_logic;
   signal ecin:                  std_logic;
   signal aecin:                 std_logic;
   signal fcin:                  std_logic;
   signal afcin:                 std_logic;
   signal gnd:                   std_logic;
   signal gnd_bus:               std_logic_vector(7 downto 0);
   signal pwr:                   std_logic;
 
component BUFGP
   port (
      I: IN std_logic;
      O: OUT std_logic);
END component;
 
component MUXCY_L
   port (
      DI:  IN std_logic;
      CI:  IN std_logic;
      S:   IN std_logic;
      LO: OUT std_logic);
END component;
 
component RAMB4_S8_S8
   port (
      ADDRA: IN std_logic_vector(8 downto 0);
      ADDRB: IN std_logic_vector(8 downto 0);
      DIA:   IN std_logic_vector(7 downto 0);
      DIB:   IN std_logic_vector(7 downto 0);
      WEA:   IN std_logic;
      WEB:   IN std_logic;
      CLKA:  IN std_logic;
      CLKB:  IN std_logic;
      RSTA:  IN std_logic;
      RSTB:  IN std_logic;
      ENA:   IN std_logic;
      ENB:   IN std_logic;
      DOA:   OUT std_logic_vector(7 downto 0);
      DOB:   OUT std_logic_vector(7 downto 0));
END component;
 
BEGIN
   read_enable <= read_enable_in;
   write_enable <= write_enable_in;
   fifo_gsr <= fifo_gsr_in;
   write_data <= write_data_in;
   read_data_out <= read_data;
   full_out <= full;
   empty_out <= empty;
   fifostatus_out <= fifostatus;
   gnd_bus <= "00000000";
   gnd <= '0';
   pwr <= '1';

----------------------------------------------------------------
--                                                            --
--  Allow flags determine whether FIFO control logic can      --
--  operate.  If read_enable is driven high, and the FIFO is  --
--  not Empty, then Reads are allowed.  Similarly, if the     --
--  write_enable signal is high, and the FIFO is not Full,    --
--  then Writes are allowed.                                  --
--                                                            --
----------------------------------------------------------------

read_allow <= (read_enable AND NOT empty);
write_allow <= (write_enable AND NOT full);

--------------------------------------------------------------------------
--                                                                      --
-- Global input clock buffers are instantianted for both the read_clock --
-- and the write_clock, to avoid skew problems.                         --
--                                                                      --
--------------------------------------------------------------------------

gclk1: BUFGP port map (I => read_clock_in, O => read_clock);
gclk2: BUFGP port map (I => write_clock_in, O => write_clock);

--------------------------------------------------------------------------
--                                                                      --
-- Block RAM instantiation for FIFO.  Module is 512x8, of which one     --
-- address location is sacrificed for the overall speed of the design.  --
--                                                                      --
--------------------------------------------------------------------------

bram1: RAMB4_S8_S8 port map (ADDRA => read_addr, ADDRB => write_addr,
                   DIB => write_data, DIA => gnd_bus, WEA => gnd,
                   WEB => write_allow, CLKA => read_clock, CLKB => write_clock,
                   RSTA => gnd, RSTB => gnd, ENA => read_allow, ENB => pwr,
                   DOA => read_data);
 
---------------------------------------------------------------
--                                                           --
--  Empty flag is set on fifo_gsr (initial), or when gray    --
--  code counters are equal, or when there is one word in    --
--  the FIFO, and a Read operation is about to be performed. --
--                                                           --
---------------------------------------------------------------

proc1: PROCESS (read_clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      empty <= '1';
   ELSIF (read_clock'EVENT AND read_clock = '1') THEN
      IF ((emptyg = '1') OR ((almostemptyg = '1') AND (read_enable = '1') AND
          (empty = '0'))) THEN
         empty <= '1';
      ELSE
         empty <= '0';
      END IF;
   END IF;
END PROCESS proc1;
 
---------------------------------------------------------------
--                                                           --
--  Full flag is set on fifo_gsr (initial, but it is cleared --
--  on the first valid write_clock edge after fifo_gsr is    --
--  de-asserted), or when Gray-code counters are one away    --
--  from being equal (the Write Gray-code address is equal   --
--  to the Last Read Gray-code address), or when the Next    --
--  Write Gray-code address is equal to the Last Read Gray-  --
--  code address, and a Write operation is about to be       --
--  performed.                                               --
--                                                           --
---------------------------------------------------------------

proc2: PROCESS (write_clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      full <= '1';
   ELSIF (write_clock'EVENT AND write_clock = '1') THEN
      IF ((fullg = '1') OR ((almostfullg = '1') AND (write_enable = '1') AND 
          (full = '0'))) THEN
         full <= '1';
      ELSE
         full <= '0';
      END IF;
   END IF;
END PROCESS proc2;
 
----------------------------------------------------------------
--                                                            --
--  Generation of Read address pointers.  The primary one is  --
--  binary (read_addr), and the Gray-code derivatives are     --
--  generated via pipelining the binary-to-Gray-code result.  --
--  The initial values are important, so they're in sequence. --
--  Grey-code addresses are used so that the registered       --
--  Full and Empty flags are always clean, and never in an    --
--  unknown state due to the asynchonous relationship of the  --
--  Read and Write clocks.  In the worst case scenario, Full  --
--  and Empty would simply stay active one cycle longer, but  --
--  it would not generate an error or give false values.      --
--                                                            --
----------------------------------------------------------------

proc3: PROCESS (read_clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      read_addr <= "000000000";
   ELSIF (read_clock'EVENT AND read_clock = '1') THEN
      IF (read_allow = '1') THEN
         read_addr <= read_addr + 1;
      END IF;
   END IF;
END PROCESS proc3;
 
proc4: PROCESS (read_clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      read_nextgray <= "100000000";
   ELSIF (read_clock'EVENT AND read_clock = '1') THEN
      IF (read_allow = '1') THEN
         read_nextgray(8) <= read_addr(8);
         read_nextgray(7) <= read_addr(8) XOR read_addr(7);
         read_nextgray(6) <= read_addr(7) XOR read_addr(6);
         read_nextgray(5) <= read_addr(6) XOR read_addr(5);
         read_nextgray(4) <= read_addr(5) XOR read_addr(4);
         read_nextgray(3) <= read_addr(4) XOR read_addr(3);
         read_nextgray(2) <= read_addr(3) XOR read_addr(2);
         read_nextgray(1) <= read_addr(2) XOR read_addr(1);
         read_nextgray(0) <= read_addr(1) XOR read_addr(0);
      END IF;
   END IF;
END PROCESS proc4;
 
proc5: PROCESS (read_clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      read_addrgray <= "100000001";
   ELSIF (read_clock'EVENT AND read_clock = '1') THEN
      IF (read_allow = '1') THEN
         read_addrgray <= read_nextgray;
      END IF;
   END IF;
END PROCESS proc5;
 
proc6: PROCESS (read_clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      read_lastgray <= "100000011";
   ELSIF (read_clock'EVENT AND read_clock = '1') THEN
      IF (read_allow = '1') THEN
         read_lastgray <= read_addrgray;
      END IF;
   END IF;
END PROCESS proc6;
 
----------------------------------------------------------------
--                                                            --
--  Generation of Write address pointers.  Identical copy of  --
--  read pointer generation above, except for names.          --
--                                                            --
----------------------------------------------------------------

proc7: PROCESS (write_clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      write_addr <= "000000000";
   ELSIF (write_clock'EVENT AND write_clock = '1') THEN
      IF (write_allow = '1') THEN
         write_addr <= write_addr + 1;
      END IF;
   END IF;
END PROCESS proc7;
 
proc8: PROCESS (write_clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      write_nextgray <= "100000000";
   ELSIF (write_clock'EVENT AND write_clock = '1') THEN
      IF (write_allow = '1') THEN
         write_nextgray(8) <= write_addr(8);
         write_nextgray(7) <= write_addr(8) XOR write_addr(7);
         write_nextgray(6) <= write_addr(7) XOR write_addr(6);
         write_nextgray(5) <= write_addr(6) XOR write_addr(5);
         write_nextgray(4) <= write_addr(5) XOR write_addr(4);
         write_nextgray(3) <= write_addr(4) XOR write_addr(3);
         write_nextgray(2) <= write_addr(3) XOR write_addr(2);
         write_nextgray(1) <= write_addr(2) XOR write_addr(1);
         write_nextgray(0) <= write_addr(1) XOR write_addr(0);
      END IF;
   END IF;
END PROCESS proc8;
 
proc9: PROCESS (write_clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      write_addrgray <= "100000001";
   ELSIF (write_clock'EVENT AND write_clock = '1') THEN
      IF (write_allow = '1') THEN
         write_addrgray <= write_nextgray;
      END IF;
   END IF;
END PROCESS proc9;
 
----------------------------------------------------------------
--                                                            --
--  Generation of FIFOstatus outputs.  Used to determine how  --
--  full FIFO is, based on how far the Write pointer is ahead --
--  of the Read pointer.  Additional precision can be gained  --
--  by using additional (top) bits of Gray-code addresses.    --
--                                                            --
----------------------------------------------------------------

proc10: PROCESS (write_clock, fifo_gsr)
-- for empty to 1/4 full  (quads are equal)
BEGIN
   IF (fifo_gsr = '1') THEN
      fifostatus(0) <= '1';
   ELSIF (write_clock'EVENT AND write_clock = '1') THEN
      IF ((read_addrgray(8 downto 7) = write_addrgray(8 downto 7)) 
         AND (fifostatus(3) = '0') AND (fifostatus(4) = '0')) THEN
         fifostatus(0) <= '1';
      ELSE
         fifostatus(0) <= '0';
      END IF;
   END IF;
END PROCESS proc10;
 
proc11: PROCESS (write_clock, fifo_gsr)
-- for 1 byte to 1/2 full  (quad 1 ahead)
BEGIN
   IF (fifo_gsr = '1') THEN
      fifostatus(1) <= '0';
   ELSIF (write_clock'EVENT AND write_clock = '1') THEN
      IF ((read_addrgray(8 downto 7)="00" AND write_addrgray(8 downto 7)="01")
        OR (read_addrgray(8 downto 7)="01" AND write_addrgray(8 downto 7)="11")
        OR (read_addrgray(8 downto 7)="11" AND write_addrgray(8 downto 7)="10")
        OR (read_addrgray(8 downto 7)="10" AND write_addrgray(8 downto 7)="00"))
        THEN
           fifostatus(1) <= '1';
      ELSE
           fifostatus(1) <= '0';
      END IF;
   END IF;
END PROCESS proc11;
 
proc12: PROCESS (write_clock, fifo_gsr)
-- for 1/4 to 3/4 full (quad 2 ahead)
BEGIN
   IF (fifo_gsr = '1') THEN
      fifostatus(2) <= '0';
   ELSIF (write_clock'EVENT AND write_clock = '1') THEN
      IF ((read_addrgray(8 downto 7)="00" AND write_addrgray(8 downto 7)="11")
        OR (read_addrgray(8 downto 7)="01" AND write_addrgray(8 downto 7)="10")
        OR (read_addrgray(8 downto 7)="11" AND write_addrgray(8 downto 7)="00")
        OR (read_addrgray(8 downto 7)="10" AND write_addrgray(8 downto 7)="01"))
        THEN
           fifostatus(2) <= '1';
      ELSE
           fifostatus(2) <= '0';
      END IF;
   END IF;
END PROCESS proc12;
 
proc13: PROCESS (write_clock, fifo_gsr)
-- for 1/2 to full (quad 3 ahead)
BEGIN
   IF (fifo_gsr = '1') THEN
      fifostatus(3) <= '0';
   ELSIF (write_clock'EVENT AND write_clock = '1') THEN
      IF ((read_addrgray(8 downto 7)="00" AND write_addrgray(8 downto 7)="10")
        OR (read_addrgray(8 downto 7)="01" AND write_addrgray(8 downto 7)="00")
        OR (read_addrgray(8 downto 7)="11" AND write_addrgray(8 downto 7)="01")
        OR (read_addrgray(8 downto 7)="10" AND write_addrgray(8 downto 7)="11"))
        THEN
           fifostatus(3) <= '1';
      ELSE
           fifostatus(3) <= '0';
      END IF;
   END IF;
END PROCESS proc13;
 
proc14: PROCESS (write_clock, fifo_gsr)
-- for 3/4 to full (quad 4 ahead/equal)
BEGIN
   IF (fifo_gsr = '1') THEN
      fifostatus(4) <= '0';
   ELSIF (write_clock'EVENT AND write_clock = '1') THEN
      IF ((read_addrgray(8 downto 7) = write_addrgray(8 downto 7))
         AND ((fifostatus(3) = '1') OR (fifostatus(4) = '1'))) THEN
         fifostatus(4) <= '1';
      ELSE
         fifostatus(4) <= '0';
      END IF;
   END IF;
END PROCESS proc14;
 
----------------------------------------------------------------
--                                                            --
--  The four conditions decoded with special carry logic are  --
--  Empty, AlmostEmpty, Full, and AlmostFull.  These are      --
--  used to determine the next state of the Full/Empty        --
--  flags.  Carry logic is used for optimal speed.            --
--                                                            --
--  When the Write/Read Gray-code addresses are equal, the    --
--  FIFO is Empty, and emptyg (combinatorial) is asserted.    --
--  When the Write Gray-code address is equal to the Next     --
--  Read Gray-code address (1 word in the FIFO), then the     --
--  FIFO potentially could be going Empty (if read_enable is  --
--  asserted, which is used in the logic that generates the   --
--  registered version of Empty).                             --
--                                                            --
--  Similarly, when the Write Gray-code address is equal to   --
--  the Last Read Gray-code address, the FIFO is full.  To    --
--  have utilized the full address space (512 addresses)      --
--  would have required extra logic to determine Full/Empty   --
--  on equal addresses, and this would have slowed down the   --
--  overall performance.  Lastly, when the Next Write Gray-   --
--  code address is equal to the Last Read Gray-code address  --
--  the FIFO is Almost Full, with only one word left, and     --
--  it is conditional on write_enable being asserted.         --
--                                                            --
----------------------------------------------------------------

ecomp(0) <= NOT (write_addrgray(0) XOR read_addrgray(0));
ecomp(1) <= NOT (write_addrgray(1) XOR read_addrgray(1));
ecomp(2) <= NOT (write_addrgray(2) XOR read_addrgray(2));
ecomp(3) <= NOT (write_addrgray(3) XOR read_addrgray(3));
ecomp(4) <= NOT (write_addrgray(4) XOR read_addrgray(4));
ecomp(5) <= NOT (write_addrgray(5) XOR read_addrgray(5));
ecomp(6) <= NOT (write_addrgray(6) XOR read_addrgray(6));
ecomp(7) <= NOT (write_addrgray(7) XOR read_addrgray(7));
ecomp(8) <= NOT (write_addrgray(8) XOR read_addrgray(8));

emuxcyi: MUXCY_L port map (DI=>pwr,CI=>pwr,       S=>pwr,     LO=>ecin);
emuxcy0: MUXCY_L port map (DI=>gnd,CI=>ecin,      S=>ecomp(0),LO=>emuxcyo(0));
emuxcy1: MUXCY_L port map (DI=>gnd,CI=>emuxcyo(0),S=>ecomp(1),LO=>emuxcyo(1));
emuxcy2: MUXCY_L port map (DI=>gnd,CI=>emuxcyo(1),S=>ecomp(2),LO=>emuxcyo(2));
emuxcy3: MUXCY_L port map (DI=>gnd,CI=>emuxcyo(2),S=>ecomp(3),LO=>emuxcyo(3));
emuxcy4: MUXCY_L port map (DI=>gnd,CI=>emuxcyo(3),S=>ecomp(4),LO=>emuxcyo(4));
emuxcy5: MUXCY_L port map (DI=>gnd,CI=>emuxcyo(4),S=>ecomp(5),LO=>emuxcyo(5));
emuxcy6: MUXCY_L port map (DI=>gnd,CI=>emuxcyo(5),S=>ecomp(6),LO=>emuxcyo(6));
emuxcy7: MUXCY_L port map (DI=>gnd,CI=>emuxcyo(6),S=>ecomp(7),LO=>emuxcyo(7));
emuxcy8: MUXCY_L port map (DI=>gnd,CI=>emuxcyo(7),S=>ecomp(8),LO=>emptyg);

aecomp(0) <= NOT (write_addrgray(0) XOR read_nextgray(0));
aecomp(1) <= NOT (write_addrgray(1) XOR read_nextgray(1));
aecomp(2) <= NOT (write_addrgray(2) XOR read_nextgray(2));
aecomp(3) <= NOT (write_addrgray(3) XOR read_nextgray(3));
aecomp(4) <= NOT (write_addrgray(4) XOR read_nextgray(4));
aecomp(5) <= NOT (write_addrgray(5) XOR read_nextgray(5));
aecomp(6) <= NOT (write_addrgray(6) XOR read_nextgray(6));
aecomp(7) <= NOT (write_addrgray(7) XOR read_nextgray(7));
aecomp(8) <= NOT (write_addrgray(8) XOR read_nextgray(8));

aemuxcyi: MUXCY_L port map (DI=>pwr,CI=>pwr,        S=>pwr,      LO=>aecin);
aemuxcy0: MUXCY_L port map (DI=>gnd,CI=>aecin,      S=>aecomp(0),LO=>aemuxcyo(0));
aemuxcy1: MUXCY_L port map (DI=>gnd,CI=>aemuxcyo(0),S=>aecomp(1),LO=>aemuxcyo(1));
aemuxcy2: MUXCY_L port map (DI=>gnd,CI=>aemuxcyo(1),S=>aecomp(2),LO=>aemuxcyo(2));
aemuxcy3: MUXCY_L port map (DI=>gnd,CI=>aemuxcyo(2),S=>aecomp(3),LO=>aemuxcyo(3));
aemuxcy4: MUXCY_L port map (DI=>gnd,CI=>aemuxcyo(3),S=>aecomp(4),LO=>aemuxcyo(4));
aemuxcy5: MUXCY_L port map (DI=>gnd,CI=>aemuxcyo(4),S=>aecomp(5),LO=>aemuxcyo(5));
aemuxcy6: MUXCY_L port map (DI=>gnd,CI=>aemuxcyo(5),S=>aecomp(6),LO=>aemuxcyo(6));
aemuxcy7: MUXCY_L port map (DI=>gnd,CI=>aemuxcyo(6),S=>aecomp(7),LO=>aemuxcyo(7));
aemuxcy8: MUXCY_L port map (DI=>gnd,CI=>aemuxcyo(7),S=>aecomp(8),LO=>almostemptyg);

fcomp(0) <= NOT (write_addrgray(0) XOR read_lastgray(0));
fcomp(1) <= NOT (write_addrgray(1) XOR read_lastgray(1));
fcomp(2) <= NOT (write_addrgray(2) XOR read_lastgray(2));
fcomp(3) <= NOT (write_addrgray(3) XOR read_lastgray(3));
fcomp(4) <= NOT (write_addrgray(4) XOR read_lastgray(4));
fcomp(5) <= NOT (write_addrgray(5) XOR read_lastgray(5));
fcomp(6) <= NOT (write_addrgray(6) XOR read_lastgray(6));
fcomp(7) <= NOT (write_addrgray(7) XOR read_lastgray(7));
fcomp(8) <= NOT (write_addrgray(8) XOR read_lastgray(8));

fmuxcyi: MUXCY_L port map (DI=>pwr,CI=>pwr,       S=>pwr,     LO=>fcin);
fmuxcy0: MUXCY_L port map (DI=>gnd,CI=>fcin,      S=>fcomp(0),LO=>fmuxcyo(0));
fmuxcy1: MUXCY_L port map (DI=>gnd,CI=>fmuxcyo(0),S=>fcomp(1),LO=>fmuxcyo(1));
fmuxcy2: MUXCY_L port map (DI=>gnd,CI=>fmuxcyo(1),S=>fcomp(2),LO=>fmuxcyo(2));
fmuxcy3: MUXCY_L port map (DI=>gnd,CI=>fmuxcyo(2),S=>fcomp(3),LO=>fmuxcyo(3));
fmuxcy4: MUXCY_L port map (DI=>gnd,CI=>fmuxcyo(3),S=>fcomp(4),LO=>fmuxcyo(4));
fmuxcy5: MUXCY_L port map (DI=>gnd,CI=>fmuxcyo(4),S=>fcomp(5),LO=>fmuxcyo(5));
fmuxcy6: MUXCY_L port map (DI=>gnd,CI=>fmuxcyo(5),S=>fcomp(6),LO=>fmuxcyo(6));
fmuxcy7: MUXCY_L port map (DI=>gnd,CI=>fmuxcyo(6),S=>fcomp(7),LO=>fmuxcyo(7));
fmuxcy8: MUXCY_L port map (DI=>gnd,CI=>fmuxcyo(7),S=>fcomp(8),LO=>fullg);

afcomp(0) <= NOT (write_nextgray(0) XOR read_lastgray(0));
afcomp(1) <= NOT (write_nextgray(1) XOR read_lastgray(1));
afcomp(2) <= NOT (write_nextgray(2) XOR read_lastgray(2));
afcomp(3) <= NOT (write_nextgray(3) XOR read_lastgray(3));
afcomp(4) <= NOT (write_nextgray(4) XOR read_lastgray(4));
afcomp(5) <= NOT (write_nextgray(5) XOR read_lastgray(5));
afcomp(6) <= NOT (write_nextgray(6) XOR read_lastgray(6));
afcomp(7) <= NOT (write_nextgray(7) XOR read_lastgray(7));
afcomp(8) <= NOT (write_nextgray(8) XOR read_lastgray(8));

afmuxcyi: MUXCY_L port map (DI=>pwr,CI=>pwr,        S=>pwr,      LO=>afcin);
afmuxcy0: MUXCY_L port map (DI=>gnd,CI=>afcin,      S=>afcomp(0),LO=>afmuxcyo(0));
afmuxcy1: MUXCY_L port map (DI=>gnd,CI=>afmuxcyo(0),S=>afcomp(1),LO=>afmuxcyo(1));
afmuxcy2: MUXCY_L port map (DI=>gnd,CI=>afmuxcyo(1),S=>afcomp(2),LO=>afmuxcyo(2));
afmuxcy3: MUXCY_L port map (DI=>gnd,CI=>afmuxcyo(2),S=>afcomp(3),LO=>afmuxcyo(3));
afmuxcy4: MUXCY_L port map (DI=>gnd,CI=>afmuxcyo(3),S=>afcomp(4),LO=>afmuxcyo(4));
afmuxcy5: MUXCY_L port map (DI=>gnd,CI=>afmuxcyo(4),S=>afcomp(5),LO=>afmuxcyo(5));
afmuxcy6: MUXCY_L port map (DI=>gnd,CI=>afmuxcyo(5),S=>afcomp(6),LO=>afmuxcyo(6));
afmuxcy7: MUXCY_L port map (DI=>gnd,CI=>afmuxcyo(6),S=>afcomp(7),LO=>afmuxcyo(7));
afmuxcy8: MUXCY_L port map (DI=>gnd,CI=>afmuxcyo(7),S=>afcomp(8),LO=>almostfullg);

END fifoctlr_ic_hdl;

