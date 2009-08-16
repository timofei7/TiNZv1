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

constant teststring: std_logic_vector(511 downto 0) := ("00000000011011110100101011111111100000001110000001100011111000110001000000011100100100001111110000000001000000110000101000011111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
   );
signal shiftreg: std_logic_vector(511 downto 0) := ("00000000011011110100101011111111100000001110000001100011111000110001000000011100100100001111110000000001000000110000101000011111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
   );
   
-- state machine for SPI bus
type state_type is (sIdle, sInit, sWaitS, sSendInit, sSendDown, sSendM, sSendUP, sDeInit, sWaitD);	-- state machine
signal curr_state, next_state: state_type;

--constant waitFinal: unsigned(14 downto 0) := "110000110101000"; -- 25,000 * 20ns = .5ms delay 
constant waitFinal: unsigned(14 downto 0) := "000000000000100"; -- FOR TESTING
signal waitCount: unsigned(14 downto 0) := (others => '0'); --counts for the initial wait
signal waitTC : std_logic:='0'; --terminal count
signal waitReset : std_logic:='0'; --reset the wait counter

constant slowFinal: unsigned(7 downto 0) := "11111010"; --count to 250 for a rate of 100khz in for down/up of SCLK
signal slowCount: unsigned(7 downto 0) := (others => '0'); --counts for SCLK
signal slowTC : std_logic:='0'; --terminal count
signal slowReset : std_logic:='0'; --reset the wait counters

constant shiftFinal: unsigned(8 downto 0):= "111111111"; --final count 511
signal shiftCount: unsigned(8 downto 0):= (others => '0'); --count shifts
signal shiftReset: std_logic:='0'; --reset shift counter
signal shiftBit: std_logic:='0'; --shift our bits out onto MOSIs

signal slowSCLK : std_logic:='0'; --internal slow SCLK signal
   
begin

SCLK <= slowSCLK;
MOSI <= shiftreg(0); --we shift out datas from this shift register

waitCounter: --15bit up counter to enable .5ms pause
process(Clk)
   begin
      if rising_edge(Clk) then
         if waitReset = '1' then
            waitCount <= (others => '0');
         else
            waitCount <= waitCount + 1;
         end if;
      end if;
end process waitCounter;
waitTC <= '1' when waitCount = waitFinal else '0';


slowCounter: --15bit up counter to enable .5ms pause
process(Clk)
   begin
      if rising_edge(Clk) then
         if slowReset = '1' then
            slowCount <= (others => '0');
         else
            slowCount <= slowCount + 1;
         end if;
      end if;
end process slowCounter;
slowTC <= '1' when slowCount = slowFinal else '0';


shiftCounter: --output shift register! --perhaps combine with DISPLAY output shift register
process(Clk)
   begin
      if rising_edge(Clk) then
         if shiftReset = '1' then
            shiftreg <= teststring;
            shiftCount <= (others => '0');
         elsif shiftBit = '1' then
            shiftreg <=  DATA & shiftreg(511 downto 1); --what DATA?!? huh
            shiftCount <= shiftCount + 1;
         end if;
      end if;
end process shiftCounter;

statemachine: --state machine to do all the work
process(curr_state, GoDisplay, waitTC, shiftCount, slowTC, slowCount)
   begin
   next_state <= curr_state;
   CS <= '0'; --opposite default - this is active low but we only set it high false during sIdle
   shiftBit <= '0';
   waitReset <= '0';
   slowReset <= '0';
   slowSCLK <= '0';
   shiftReset <= '0';
   
   case curr_state is
      when sIdle => --base state - CS is high false
         CS <= '1';
         if GoDisplay = '1' then
            next_state <= sInit;
         end if;
      when sInit => --resest counters to deassert cs and be ready for shifting
         CS <= '1';
         waitReset <= '1';
         shiftReset <= '1';
         next_state <= sWaitS;
      when sWaitS => --wait for .5ms after deasserting cs
         if waitTC = '1' then
            next_state <= sSendInit;
         end if;
      when sSendInit => --reset counts to initialize sending cycle
         slowReset <= '1';
         shiftbit <= '1';
         next_state <= sSendDown;
      when sSendDown => --keep SCLK low for half an SCLK cycle
         if slowTC = '1' then
            next_state <= sSendM;
         end if;
      when sSendM => --reset slow counter
         slowReset <= '1';
         next_state <= sSendUP;
      when sSendUP =>
         slowSCLK <= '1'; --default is 0 so here's the rising edge for the slave!
         if slowTC = '1' then
            if slowCount = slowFinal then --are we done shifting?
               next_state <= sDeInit;
            else
               next_state <= sSendInit;
            end if;
         end if;
      when sDeInit => --NOT SURE WE NEED DELAY AT END --this is for CS to stay low for a little extra
         waitReset <= '1';
         next_state <= sWaitD;
      when sWaitD => --wait for .5ms to denable cs
         if waitTC = '1' then
            next_state <= sIdle;
         end if;
      when others => next_state <= sIdle;
   end case;
end process statemachine;


statechanger:
process (Clk)
begin
	if rising_edge(Clk) then --slow us down to at most 125khz
		curr_state <= next_state;
	end if;
end process statechanger;


end Behavioral;

