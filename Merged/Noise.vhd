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
    Port ( Clk : in  STD_LOGIC;
           NoiseType : in  STD_LOGIC_VECTOR (1 downto 0);
           NoiseON : in  STD_LOGIC;
           SIGOUT : out  STD_LOGIC);
end Noise;

architecture Behavioral of Noise is

   COMPONENT ClockDivider
   GENERIC (DIV : integer);
   PORT(
      Clk : IN std_logic;          
      slowCE : OUT std_logic
      );
   END COMPONENT;

signal annoyingCE: std_logic:='0';
signal pleasantCE: std_logic:='0';
signal highpitchCE: std_logic:='0';


begin



   
   
process(Clk)
begin
      if rising_edge(Clk) then
         if annoyingCE = '1' then
         
         

end Behavioral;

