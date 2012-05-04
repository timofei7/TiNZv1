----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009
-- 
-- Create Date:    03:08:36 08/22/2009 
-- Module Name:    Noise - Behavioral
-- Project Name: 	 TINZ (This Is Not Zelda)
--
-- Description:   this generates a square wave output varied by the input frequence it is given
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Noise is
    Port ( Clk : in  STD_LOGIC;
           NoiseON : in  STD_LOGIC;
           FreqCount : in std_logic_vector(16 downto 0);
           SIGOUT : out  STD_LOGIC);
end Noise;

architecture Behavioral of Noise is


signal countCE: std_logic:='0';
signal countReset: std_logic:='0';

signal count: unsigned(16 downto 0):= (others => '0'); --big enough for lots of values of countfinal
signal countfinal: unsigned(16 downto 0):= (others => '0');

-- state machine for sound
type state_type is (sIdle, sResetUP, sUP, sResetDown, sDOWN);	-- state machine
signal curr_state: state_type := sIdle;
signal next_state: state_type;



begin

countfinal <= unsigned(FreqCount);

--counter for square wave
process(Clk)
   begin
      if rising_edge(Clk) then
         if countReset = '1' then
            count <= (others => '0');
         else
            count <= count + 1;
         end if;
      end if;
end process;
countCE <= '1' when count = countfinal else '0';

         
         


statemachine: --state machine to do all the work
process(curr_state, NoiseON, countCE)
   begin
   next_state <= curr_state;
   SIGOUT <= '0';
   countReset <= '0';

   case curr_state is
      when sIdle => --do nothing
         countReset <= '1';
         if NoiseON = '1' then
            next_state <= sResetUP;
         end if;
      when sResetUP =>
         next_state <= sUP; --just take up a clock cycle to be even;
      when sUP =>
         SIGOUT <= '1';
         if countCE = '1' then
            next_state <= sResetDown;
         end if;
      when sResetDOwn =>
         countReset <= '1';
         next_state <= sDown;
      when sDown =>
         if countCE = '1' then
            next_state <= sIdle;
         end if;
      when others => next_state <= sIdle;
   end case;
end process statemachine;


statechanger:
process (Clk)
begin
	if rising_edge(Clk) then 
      if NoiseON = '1' then
         curr_state <= next_state;
      else
         curr_state <= sIdle;
      end if;
	end if;
end process statechanger;


end Behavioral;

