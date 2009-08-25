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
           WriteAddr : in  STD_LOGIC_VECTOR (3 downto 0);
           ReadColor : in STD_LOGIC_VECTOR(3 downto 0);
           ReadEnabled : in STD_LOGIC_VECTOR(3 downto 0);
           RstPU : in  STD_LOGIC;
           DisablePU : in  STD_LOGIC;
           Color : out STD_LOGIC_VECTOR(7 downto 0);
           WIN: out std_logic;
           Enabled : out STD_LOGIC);
end AttrLookup;

architecture Behavioral of AttrLookup is
     constant enemy1Color : std_logic_vector(7 downto 0) := "11100000";  --red enemies
     constant enemy2Color : std_logic_vector(7 downto 0) := "11111100";  --yellow enemies
     constant enemy3Color : std_logic_vector(7 downto 0) := "11101000";  --orange enemies
     constant pu1Color : std_logic_vector(7 downto 0) := "00000011"; --pure blue pups
     constant pu2Color : std_logic_vector(7 downto 0) := "00000010"; --darker blue pups
     constant pu3Color : std_logic_vector(7 downto 0) := "00000001"; --dark blue pups
     constant emptyColor : std_logic_vector(7 downto 0) := "00000000"; --blanks
     constant finishColor : std_logic_vector(7 downto 0) := "11111111"; --finish line color
     
     
     constant enemy1addr : std_logic_vector(3 downto 0) := x"1";
     constant enemy2addr : std_logic_vector(3 downto 0) := x"2";
     constant enemy3addr : std_logic_vector(3 downto 0) := x"3";
     constant pu1addr : std_logic_vector(3 downto 0) := x"4";
     constant pu2addr : std_logic_vector(3 downto 0) := x"5";
     constant pu3addr : std_logic_vector(3 downto 0) := x"6";
     constant emptyaddr : std_logic_vector(3 downto 0) := x"0"; 
     constant finishaddr : std_logic_vector(3 downto 0) := x"7";
     constant finishEaddr : std_logic_vector(3 downto 0) := x"8";
     
     signal enemy1 : std_logic := '1'; 
     signal enemy2 : std_logic := '1';  
     signal enemy3 : std_logic := '1';  
     signal pu1 : std_logic := '1'; 
     signal pu2 : std_logic := '1'; 
     signal pu3 : std_logic := '1'; 
     signal empty : std_logic := '0';
     signal finish : std_logic := '1';
     
     signal countvamp: unsigned(1 downto 0):="00"; --for monopulser
     signal winSig: std_logic:= '0'; --are we winning?

begin


--monopulser to limit this signal to a one clock cycle pulse
process(Clk)
begin
   if rising_edge(Clk) then
      if winSig = '0' then
         countvamp <= "00";
      elsif countvamp /= "10" then
         countvamp <= countvamp +1;
      end if;
   end if;
end process;
WIN <= '1' when countvamp = "01" else '0';

--disaple powerups here
process(Clk)
begin
   if rising_edge(Clk) then
      if rstPU = '1' then
         enemy1 <= '1';
         enemy2 <= '1';
         enemy3 <= '1';
         pu1 <= '1';
         pu2 <= '1';
         pu3 <= '1';
         empty <= '0';
         finish <= '1';
      elsif disablePU = '1' then
         case WriteAddr is
            when x"1" => enemy1 <= '1';
            when x"2" => enemy2 <= '0';  --THIS IS ON PURPOSE these can get EATEN
            when x"3" => enemy3 <= '1';
            when x"4" => pu1 <= '0'; -- we really only need these
            when x"5" => pu2 <= '0';
            when x"6" => pu3 <= '0'; --
            when x"0" => empty <= '0';
            when x"7" => finish <= '1';
            when others => empty <= '0';
         end case;
      end if;
   end if;
end process;


--read appropriate type color here
process(ReadColor, enemy1, enemy2, enemy3, pu1, pu2, pu3, empty, finish)
begin
   Color <= emptyColor;
   case ReadColor is
      when x"1" =>
         if enemy1 = '1' then
            Color <= enemy1Color;
         end if;
      when x"2" =>
         if enemy2 = '1' then
            Color <= enemy2Color;
         end if;
      when x"3" =>
         if enemy3 = '1' then
            Color <= enemy3Color;
         end if;
      when x"4" =>
         if pu1 = '1' then
            Color <= pu1Color;
         end if;
      when x"5" =>
         if pu2 = '1' then
            Color <= pu2Color;
         end if;
      when x"6" =>
         if pu3 = '1' then
            Color <= pu3Color;
         end if;
      when x"0" =>
         if empty = '1' then
            Color <= emptyColor;
         end if;
      when x"7" =>
         if finish = '1' then
            Color <= finishColor;
         end if;
      when others =>
         Color <= emptycolor;
   end case;
end process;

--read whether location is enabled and if we've won!
process(ReadEnabled, enemy1, enemy2, enemy3, pu1, pu2, pu3, empty, finish)
begin
   winSig <= '0';
   case ReadEnabled is
      when x"1" => Enabled <= enemy1; 
      when x"2" => Enabled <= enemy2;
      when x"3" => Enabled <= enemy3;
      when x"4" => Enabled <= pu1;
      when x"5" => Enabled <= pu2;
      when x"6" => Enabled <= pu3;
      when x"0" => Enabled <= empty;
      when x"7" => 
         Enabled <= finish;
         winSig <= '1';
      when others => Enabled <= empty;
   end case;
end process;

end Behavioral;

