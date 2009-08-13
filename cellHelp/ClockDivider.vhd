----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    21:40:57 08/12/2009 
-- Design Name: 
-- Module Name:    ClockDivider - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    This is a nice generic clock divider, instantiate it, set div to your numeric divider val and off you go!
--                 notice this does not work for a Div of 0 or 1. 
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


entity ClockDivider is
    GENERIC (DIV : integer := 2); --just send a number like 25 for 1hz etc.. 
    Port ( 
           Clk : in  STD_LOGIC;
           slowCE : out  STD_LOGIC);
end ClockDivider;

architecture Behavioral of ClockDivider is

constant MAXCLKDIV: integer := 2**DIV-1; -- max count of clock divider, 1...11
signal clkdivcount:  unsigned(DIV-1 downto 0) := (others => '0'); -- clock divider count value
signal TC: std_logic; -- slow clock enable for framecounter

begin

ClockDivider:
process(Clk)
   begin 
      if rising_edge(Clk) then 
         if TC = '1' then
            clkdivcount <= (others => '0');
         else 
            clkdivcount <= clkdivcount+1;
         end if;
      end if;
end process ClockDivider; 
TC <= '1' when clkdivcount = MAXCLKDIV else '0';
slowCE <= TC;



end Behavioral;

