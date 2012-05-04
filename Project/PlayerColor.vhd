----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009
-- 
-- Create Date:    21:17:41 08/14/2009 
-- Design Name: 
-- Module Name:    PlayerColor - Behavioral
-- Project Name: 	 TINZ (This Is Not Zelda)
-- 
-- Description:   changes the player color to appear for 'breath' effect
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity PlayerColor is
    Port ( Clk : in  STD_LOGIC;
           Selector : in  STD_LOGIC_VECTOR (1 downto 0);
           PlayerColor : out  STD_LOGIC_VECTOR (7 downto 0));
end PlayerColor;

architecture Behavioral of PlayerColor is

COMPONENT ClockDivider
GENERIC (DIV : integer);
PORT(
   Clk : IN std_logic;          
   slowCE : OUT std_logic
   );
END COMPONENT;

type colorArray is array(0 to 5) of std_logic_vector(7 downto 0);
constant unshielded: colorArray := (
   "00000100", "00010000", "00011100", "00011100", "00010000", "00000100"); --dark to light green
constant shielded: colorArray := (
   "00000001", "00000010", "00001111", "00100111", "01001011", "01101111"); --dark blue to.. light blue? with added colors?
constant onenemy: std_logic_vector(7 downto 0) := "11100011"; --bright purple

signal breathCounter: unsigned(3 downto 0) := "0000"; --for indexing into the color arrays
signal breathDirection: std_logic:='1'; --up or down?
signal breathSlow: std_logic := '0'; --slow count enable
signal color: std_logic_vector(7 downto 0):= "00000000"; --internal color signal for choice

begin

myclockdiv: ClockDivider
   GENERIC MAP (DIV => 23)
   PORT MAP(
		Clk => Clk,
		slowCE => breathSlow
	);


breathycounter:
process(Clk)
   begin
      if rising_edge(Clk) and breathSlow = '1' then
         if breathDirection = '1' then
            breathCounter <= breathCounter + 1;
         else
            breathCounter <= breathCounter - 1;
         end if;
      end if;
end process breathycounter;

breathDir:
process(Clk)
   begin
      if rising_edge(Clk) then
         if breathCounter = x"5" and breathDirection = '1' then
            breathDirection <= not breathDirection;
         elsif breathCounter = x"0" and breathDirection = '0' then
            breathDirection <= not breathDirection;
         else
            breathDirection <= breathDirection;
         end if;
      end if;
end process breathDir;

colorMux:
process(breathCounter, Selector)
   begin
      case Selector is
         when "00" => color <= unshielded(to_integer(breathCounter(2 downto 0)));
         when "01" => color <= shielded(to_integer(breathCounter(2 downto 0)));
         when "10" => color <= onenemy;
         when others => color <= unshielded(to_integer(breathCounter(2 downto 0)));
       end case;
end process colorMux;
PlayerColor <= color;

end Behavioral;

