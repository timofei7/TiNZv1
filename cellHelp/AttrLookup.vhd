----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS32
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    19:23:27 08/10/2009 
-- Design Name: 
-- Module Name:    AttrLookup - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:   is a lookup to match a color and an enable bit with a type of object on the board
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


entity AttrLookup is
    Port ( Clk : in STD_LOGIC;
           Ident : in  STD_LOGIC_VECTOR (5 downto 0);
           rstPU : in  STD_LOGIC;
           disablePU : in  STD_LOGIC;
           isEN : out  STD_LOGIC;
           color : out  STD_LOGIC_VECTOR (7 downto 0));
end AttrLookup;

architecture Behavioral of AttrLookup is
     type rom_type is array (64-1 downto 0) of std_logic_vector (8 downto 0); --leaves space for lots of types
     signal Attrs : rom_type;
     
     constant enemy1Color : std_logic_vector(7 downto 0) := "11100000";  --bright red enemies
     constant enemy2Color : std_logic_vector(7 downto 0) := "10000000";  --dark red enemies
     constant enemy3Color : std_logic_vector(7 downto 0) := "10000010";  --dark purplish enemies
     constant pu1Color : std_logic_vector(7 downto 0) := "10010011"; --light blue pups
     constant pu2Color : std_logic_vector(7 downto 0) := "00000010"; --bright blue pups
     constant pu3Color : std_logic_vector(7 downto 0) := "00000011"; --brighter blue pups
     constant emptyColor : std_logic_vector(7 downto 0) := "00000000"; --blanks
begin


process(Clk)
begin
   if rising_edge(Clk) then
      if rstPU = '1' then
         Attrs(0) <= '1' & emptyColor;  --the types we start with add more here plenty of room
         Attrs(1) <= '1' & enemy1Color;
         Attrs(2) <= '1' & enemy2Color;
         Attrs(3) <= '1' & enemy3Color;
         Attrs(10) <= '1' & pu1Color;
         Attrs(11) <= '1' & pu2Color;
         Attrs(12) <= '1' & pu3Color;
      elsif disablePU = '1' then
         Attrs(to_integer(unsigned(Ident)))(8) <= '0';
      end if;
   end if;
end process;



Read:
process(Ident)
begin
   isEN <= Attrs(to_integer(unsigned(Ident)))(8);
   color <= Attrs(to_integer(unsigned(Ident)))(7 downto 0);
end process Read;

end Behavioral;

