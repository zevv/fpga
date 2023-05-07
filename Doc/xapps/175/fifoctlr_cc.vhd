
---------------------------------------------------------------------------
--                                                                       --
--  Module      : fifoctlr_cc.vhd                 Last Update: 12/13/99  --
--                                                                       --
--  Description : FIFO controller top level.                             --
--                Implements a 511x8 FIFO with common read/write clocks. --
--                                                                       --
--  The following VHDL code implements a 511x8 FIFO in a Spartan-II      --
--  device.  The inputs are a Clock, a Read Enable, a Write Enable,      --
--  Write Data, and a FIFO_gsr signal as an initial reset.  The outputs  --
--  are Read Data, Full, Empty, and the FIFOcount outputs, which         --
--  indicate roughly how full the FIFO is.                               --
--                                                                       --
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity fifoctlr_cc is
   port (clock_in:        IN  std_logic;
         read_enable_in:  IN  std_logic;
         write_enable_in: IN  std_logic;
         write_data_in:   IN  std_logic_vector(7 downto 0);
         fifo_gsr_in:     IN  std_logic;
         read_data_out:   OUT std_logic_vector(7 downto 0);
         full_out:        OUT std_logic;
         empty_out:       OUT std_logic;
         fifocount_out:   OUT std_logic_vector(3 downto 0));
END fifoctlr_cc;

architecture fifoctlr_cc_hdl of fifoctlr_cc is
   signal clock:                 std_logic;
   signal read_enable:           std_logic;
   signal write_enable:          std_logic;
   signal fifo_gsr:              std_logic;
   signal read_data:             std_logic_vector(7 downto 0) := "00000000";
   signal write_data:            std_logic_vector(7 downto 0);
   signal full:                  std_logic;
   signal empty:                 std_logic;
   signal read_addr:             std_logic_vector(8 downto 0) := "000000000";
   signal write_addr:            std_logic_vector(8 downto 0) := "000000000";
   signal fcounter:              std_logic_vector(8 downto 0) := "000000000";
   signal read_allow:            std_logic;
   signal write_allow:           std_logic;
   signal gnd:                   std_logic;
   signal gnd_bus:               std_logic_vector(7 downto 0);
   signal pwr:                   std_logic;
   signal read_linearfeedback:   std_logic;
   signal write_linearfeedback:  std_logic;

component BUFGP
   port (
      I: IN std_logic;  
      O: OUT std_logic);
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
   read_allow <= (read_enable AND NOT empty);
   write_allow <= (write_enable AND NOT full);
   gnd_bus <= "00000000";
   gnd <= '0';
   pwr <= '1';
   
--------------------------------------------------------------------------
--                                                                      --
-- A global buffer is instantianted to avoid skew problems.             -- 
--                                                                      --
--------------------------------------------------------------------------
 
gclk1: BUFGP port map (I => clock_in, O => clock);

--------------------------------------------------------------------------
--                                                                      --
-- Block RAM instantiation for FIFO.  Module is 512x8, of which one     -- 
-- address location is sacrificed for the overall speed of the design.  --
--                                                                      --
--------------------------------------------------------------------------

bram1: RAMB4_S8_S8 port map (ADDRA => read_addr, ADDRB => write_addr, 
                   DIB => write_data, DIA => gnd_bus, WEA => gnd, 
                   WEB => write_allow, CLKA => clock, CLKB => clock, 
                   RSTA => gnd, RSTB => gnd, ENA => read_allow, ENB => pwr, 
                   DOA => read_data);

---------------------------------------------------------------
--                                                           --
--  Empty flag is set on fifo_gsr (initial), or when on the  --
--  next clock cycle, Write Enable is low, and either the    --
--  FIFOcount is equal to 0, or it is equal to 1 and Read    --
--  Enable is high (about to go Empty).                      --
--                                                           --
---------------------------------------------------------------

proc1: PROCESS (clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      empty <= '1';
   ELSIF (clock'EVENT AND clock = '1') THEN
      IF ((fcounter(8 downto 1) = "00000000") AND (write_enable = '0') AND
         ((fcounter(0) = '0') OR (read_enable = '1'))) THEN
         empty <= '1';
      ELSE
         empty <= '0';
      END IF;
   END IF;
END PROCESS proc1;

---------------------------------------------------------------
--                                                           --
--  Full flag is set on fifo_gsr (but it is cleared on the   --
--  first valid clock edge after fifo_gsr is removed), or    --
--  when on the next clock cycle, Read Enable is low, and    --
--  either the FIFOcount is equal to 1FF (hex), or it is     --
--  equal to 1FE and the Write Enable is high (about to go   --
--  Full).                                                   --
--                                                           --
---------------------------------------------------------------

proc2: PROCESS (clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      full <= '1';
   ELSIF (clock'EVENT AND clock = '1') THEN
      IF ((fcounter(8 downto 1) = "11111111") AND (read_enable = '0') AND 
         ((fcounter(0) = '1') OR (write_enable = '1'))) THEN
         full <= '1';
      ELSE
         full <= '0';
      END IF;
   END IF;
END PROCESS proc2;

----------------------------------------------------------------
--                                                            --
--  Generation of Read and Write address pointers.  They use  --
--  LFSR counters, which are very fast.  Because of the       --
--  nature of LFSRs, one address is sacrificed.               --
--                                                            --
----------------------------------------------------------------

read_linearfeedback <=  NOT (read_addr(8) XOR read_addr(4)); 
write_linearfeedback <= NOT (write_addr(8) XOR write_addr(4));

proc3: PROCESS (clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      read_addr <= "000000000";
   ELSIF (clock'EVENT AND clock = '1') THEN
      IF (read_allow = '1') THEN
         read_addr(8) <= read_addr(7);
         read_addr(7) <= read_addr(6);
         read_addr(6) <= read_addr(5);
         read_addr(5) <= read_addr(4);
         read_addr(4) <= read_addr(3);
         read_addr(3) <= read_addr(2);
         read_addr(2) <= read_addr(1);
         read_addr(1) <= read_addr(0);
         read_addr(0) <= read_linearfeedback;
      END IF;
   END IF;
END PROCESS proc3;

proc4: PROCESS (clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      write_addr <= "000000000";
   ELSIF (clock'EVENT AND clock = '1') THEN
      IF (write_allow = '1') THEN
         write_addr(8) <= write_addr(7);
         write_addr(7) <= write_addr(6);
         write_addr(6) <= write_addr(5);
         write_addr(5) <= write_addr(4);
         write_addr(4) <= write_addr(3);
         write_addr(3) <= write_addr(2);
         write_addr(2) <= write_addr(1);
         write_addr(1) <= write_addr(0);
         write_addr(0) <= write_linearfeedback;
      END IF;
   END IF;
END PROCESS proc4;

----------------------------------------------------------------
--                                                            --
--  Generation of FIFOcount outputs.  Used to determine how   --
--  full FIFO is, based on a counter that keeps track of how  --
--  many words are in the FIFO.  Also used to generate Full   --
--  and Empty flags.  Only the upper four bits of the counter --
--  are sent outside the module.                              --
--                                                            --
----------------------------------------------------------------

proc5: PROCESS (clock, fifo_gsr)
BEGIN
   IF (fifo_gsr = '1') THEN
      fcounter <= "000000000";
   ELSIF (clock'EVENT AND clock = '1') THEN
      IF (((read_allow = '1') AND (write_allow = '0')) OR
             ((read_allow = '0') AND (write_allow = '1'))) THEN
         IF (write_allow = '1') THEN
            fcounter <= fcounter + '1';
         ELSE
            fcounter <= fcounter - '1';
         END IF;
      END IF;
   END IF;
END PROCESS proc5;

fifocount_out <= fcounter(8 downto 5);

END fifoctlr_cc_hdl;

