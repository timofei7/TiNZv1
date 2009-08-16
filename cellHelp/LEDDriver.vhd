----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    13:17:46 08/15/2009 
-- Design Name: 
-- Module Name:    LEDDriver - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity LEDDriver is
    Port ( Clk : in  STD_LOGIC;
           Data: in STD_LOGIC;
           GoDisplay : in  STD_LOGIC;
           MISO : in  STD_LOGIC;
           MOSI : out  STD_LOGIC;
           SCLK : out  STD_LOGIC;
           CS : out  STD_LOGIC);
end LEDDriver;

architecture Behavioral of LEDDriver is

COMPONENT ClockDivider
GENERIC (DIV : integer := 2); --just send a number like 25 for 1hz etc.. 
PORT(
   Clk : IN std_logic;          
   slowCE : OUT std_logic
   );
END COMPONENT;


constant teststring: std_logic_vector(511 downto 0) := ("00000000011011110100101011111111100000001110000001100011111000110001000000011100100100001111110000000001000000110000101000011111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
   );
signal shiftreg: std_logic_vector(511 downto 0) := ("00000000011011110100101011111111100000001110000001100011111000110001000000011100100100001111110000000001000000110000101000011111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
   );
signal slowCE: std_logic :='0';   

-- state machine for SPI bus
--type state_type is (sIdle, sInit, sWaitS, sSend, sDeInit, sWaitD);	-- state machine
type state_type is (sIdle, sInit, sWaitS, sSend);	-- state machine
signal curr_state, next_state: state_type;

--constant waitFinal: unsigned(14 downto 0) := "110000110101000"; -- 25,000 * 20ns = .5ms delay 
constant waitFinal: unsigned(14 downto 0) := "000000000000100"; -- FOR TESTING
signal waitCounter: unsigned(14 downto 0) := (others => '0'); --counts for the initial wait
signal waitTC : std_logic:='0'; --terminal count
signal waitTCreg : std_logic:='0'; --register it cause it only lasts one clock cycle not long enough
signal waitReset : std_logic:='0'; --reset the wait counter

constant shiftFinal: unsigned(8 downto 0):= "111111111"; --final count 511
signal shiftCounter: unsigned(8 downto 0):= (others => '0'); --count shifts
signal shiftTC: std_logic:='0'; --terminal count for shifting all 512 bits

signal shiftBit: std_logic:='0'; --shift our bits out onto MOSI
signal godisp: std_logic:='0'; --we register GoDisplay since it is only on for a short clock cycle
   
begin


spclkdiv: ClockDivider PORT MAP(
		Clk => Clk,
		slowCE => slowCE
	);
   
SCLK <= slowCE; --send the clock out on the SCLK pin

MOSI <= shiftreg(0); --we shift out datas from this shift register

waitCount: --15bit up counter to enable .5ms pause
process(Clk)
   begin
      if rising_edge(Clk) then
         if waitReset = '1' then
            waitCounter <= (others => '0');
         else
            waitCounter <= waitCounter + 1;
         end if;
      end if;
end process waitCount;
waitTC <= '1' when waitCounter = waitFinal else '0';

waitreg: --register the terminal counter of wait count cause otherwise it goes by too fast
process(Clk)
   begin
      if rising_edge(Clk) then
         if waitTC = '1' then
            waittcreg <= '1';
         elsif waitReset = '1' then
            waittcreg <= '0';
         end if;
      end if;
end process waitreg;

godispreg: --register godisplay input otherwise the 1 clock pulse goes by too fast
process(Clk)
   begin
      if rising_edge(Clk) then
         if GoDisplay = '1' then
            godisp <= '1';
         elsif shiftTC = '1' then
            godisp <= '0';
         end if;
      end if;
end process godispreg;



shiftbits: --output shift register! --perhaps combine with DISPLAY output shift register
process(Clk)
   begin
      if rising_edge(Clk) and slowCE = '1' then --do i need slowCE here
         if shiftBit = '1' then
            shiftreg <=  DATA & shiftreg(511 downto 1); 
            shiftCounter <= shiftCounter + 1;
         elsif shiftTC = '1' then
            shiftreg <= teststring;
            shiftCounter <= (others => '0');
         end if;
      end if;
end process shiftbits;
shiftTC <= '1' when shiftCounter = shiftFinal else '0';


statemachine: --state machine to do all the work
process(curr_state, godisp, waitTCreg, shiftTC)
   begin
   next_state <= curr_state;
   CS <= '1';
   shiftBit <= '0';
   waitReset <= '0';
   
   case curr_state is
      when sIdle =>
         if godisp = '1' then
            next_state <= sInit;
         end if;
      when sInit =>
         CS <= '0';
         waitReset <= '1';
         next_state <= sWaitS;
      when sWaitS =>
         CS <= '0'; --active low about to send data
         if waitTCreg = '1' then
            next_state <= sSend;
         end if;
      when sSend =>
         waitReset <= '1';
         CS <= '0';
         if shiftTC = '1' then
            next_state <= sIdle;
         else
            shiftBit <= '1';
         end if;
--      when sDeInit => --NOT SURE WE NEED DELAY AT END TRY WITHOUT IT
--         CS <= '0';
--         waitReset <= '1';
--         next_state <= sWaitD;
--      when sWaitD =>
--         CS <= '0';
--         if waitTCreg = '1' then
--            next_state <= sIdle;
--         end if;
      when others => next_state <= sIdle;
   end case;
end process statemachine;


statechanger:
process (Clk)
begin
	if rising_edge(Clk) and slowCE = '1' then --slow us down to at most 125khz
		curr_state <= next_state;
	end if;
end process statechanger;


end Behavioral;

