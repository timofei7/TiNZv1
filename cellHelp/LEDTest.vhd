----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    14:53:46 08/18/2009 
-- Design Name: 
-- Module Name:    LEDTest - Behavioral 
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

entity LEDTest is
    Port ( Clk : in  STD_LOGIC;
           Color : in  STD_LOGIC_VECTOR (7 downto 0);
           MOSI : out  STD_LOGIC;
           SCLK : out  STD_LOGIC;
           CS : out  STD_LOGIC);
end LEDTest;

architecture Behavioral of LEDTest is
   
-- state machine for SPI bus
type state_type is (sBogus, sIdle, sInit, sWaitS, sSendInit, sSendDown, sSendM, sSendUP, sDeInit, sWaitD);	-- state machine
signal curr_state: state_type := sIdle;
signal next_state: state_type;

constant waitFinal: unsigned(14 downto 0) := "110000110101000"; -- 25,000 * 20ns = .5ms delay 
signal waitCount: unsigned(14 downto 0) := (others => '0'); --counts for the initial wait
signal waitTC : std_logic:='0'; --terminal count
signal waitReset : std_logic:='0'; --reset the wait counter

constant slowFinal: unsigned(7 downto 0) := "11111010"; --count to 250 for a rate of 100khz in for down/up of SCLK
signal slowCount: unsigned(7 downto 0) := (others => '0'); --counts for SCLK
signal slowTC : std_logic:='0'; --terminal count
signal slowReset : std_logic:='0'; --reset the wait counters

constant shiftFinal: unsigned(9 downto 0):= "1000000000"; --final count 511
signal shiftCount: unsigned(9 downto 0):= (others => '0'); --count shifts
signal shiftBit: std_logic:='0'; --shift our bits out onto MOSIs

constant testshiftFinal: unsigned(3 downto 0):= "1111";
signal testshiftCount: unsigned(3 downto 0) := "0111";
signal testTC: std_logic:='0';
signal nextval: std_logic:='0';
   
begin

MOSI <= nextval; --our datas are multiplex shifted into this register

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


testshiftCounter: --test shifter from pins
process(Clk)
   begin
      if rising_edge(Clk) then
         if testTC = '1' then
            testshiftcount <= "0111";
         elsif shiftBit = '1' then
            testshiftcount <= testshiftcount - 1;
         end if;
      end if;
end process testshiftCounter;
testTC <= '1' when testshiftcount = testshiftfinal else '0';

shiftCounter: --not really shifting just multiplexing into a 1-bit register
process(Clk)
   begin
      if rising_edge(Clk) then
         if shiftBit = '1' then
            nextval <= Color(to_integer(testshiftcount));
            shiftCount <= shiftCount + 1;
         end if;
      end if;
end process shiftCounter;

statemachine: --state machine to do all the work
process(curr_state, waitTC, shiftCount, slowTC, slowCount)
   begin
   next_state <= curr_state;
   CS <= '0'; --opposite default - this is active low but we only set it high false during sIdle
   shiftBit <= '0';
   waitReset <= '0';
   slowReset <= '0';
   SCLK <= '0';
   
   case curr_state is
      when sIdle => --base state - CS is high false
         CS <= '1';
         next_state <= sInit;
      when sInit => --resest counters to deassert cs
         CS <= '1';
         waitReset <= '1';
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
      when sSendM => --reset slow counter -- could get rid of this and init states
         SCLK <= '1'; --start the up 
         slowReset <= '1';
         next_state <= sSendUP;
      when sSendUP =>
         SCLK <= '1'; --default is 0 so here's the rising edge for the slave!
         if slowTC = '1' then
            if shiftCount = shiftFinal then --are we done shifting?
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
            next_state <= sBogus;--CHANGEME
         end if;
      when sBogus =>
         CS <= '1';
         next_state <= sBogus;
      when others => next_state <= sIdle; --CHANGEME
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

