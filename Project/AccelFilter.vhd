----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009
-- 
-- Create Date:    00:39:45 08/22/2009 
-- Design Name: 
-- Module Name:    AccelFilter - Behavioral
-- Project Name: 	 TINZ (This Is Not Zelda)
-- 
-- Description:  averages the accelerometer input to smooth out jitters
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity AccelFilter is
    Port ( Clk : in  STD_LOGIC;
           CE: in STD_LOGIC;
           SIGIN : in  STD_LOGIC_VECTOR (7 downto 0);
           SIGOUT : out  STD_LOGIC_VECTOR (7 downto 0));
end AccelFilter;

architecture Behavioral of AccelFilter is

signal accreg: unsigned(12 downto 0):=(others => '0'); --accumulator register
signal outsig: unsigned(7 downto 0):=(others => '0'); --register to hold output
signal count: unsigned(5 downto 0):=(others => '0'); --counter for num of samples
signal countTC: std_logic:= '0'; --terminal count of counter
constant countfinal: unsigned(5 downto 0):= "100000"; --take 32 samples

begin

--accumulator
process(Clk)
begin
   if rising_edge(Clk) then
      if countTC = '1' then
         accreg <= (others => '0');
      elsif CE = '1' then
         accreg <= accreg + unsigned(SIGIN);
      end if;
   end if;
end process;


--register for setting output         
process(Clk)
begin
   if rising_edge(Clk) then
      if countTC = '1' then
         outsig <= accreg(12 downto 5);
      end if;
   end if;
end process;
SIGOUT <= std_logic_vector(outsig);
      
      
--counter for how many signals we want to average      
process(Clk)
begin
   if rising_edge(Clk) then
      if countTC ='1' then
         count <= (others => '0');
      elsif CE = '1' then
         count <= count +1;
      end if;
   end if;
end process;
countTC <= '1' when count = countfinal else '0';

end Behavioral;

