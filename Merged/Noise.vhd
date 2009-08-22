----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    03:08:36 08/22/2009 
-- Design Name: 
-- Module Name:    Noise - Behavioral 
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

entity Noise is
    GENERIC (countfinal : integer:= 25000);   --12500 for 200hz, 25000 for 1000hz,  12207 for 2048hz LOUDEST, 6250 for 4000hz
    Port ( Clk : in  STD_LOGIC;
           NoiseON : in  STD_LOGIC;
           SIGOUT : out  STD_LOGIC);
end Noise;

architecture Behavioral of Noise is


signal countCE: std_logic:='0';
signal countReset: std_logic:='0';

signal count: unsigned(31 downto 0):= (others => '0'); --big enough for lots of values of countfinal

-- state machine for sound
type state_type is (sIdle, sResetUP, sUP, sResetDown, sDOWN);	-- state machine
signal curr_state: state_type := sIdle;
signal next_state: state_type;



begin


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

