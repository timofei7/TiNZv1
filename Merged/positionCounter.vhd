----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    13:05:02 08/09/2009 
-- Design Name: 
-- Module Name:    positionCounter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;


entity positionCounter is
	 Port ( UP : in  STD_LOGIC;
			  DOWN: in STD_LOGIC;
			  rst : 	in   STD_LOGIC;
			  Clk : in STD_LOGIC;
			  count : out STD_LOGIC_VECTOR(2 downto 0);
			  makeSoundMove : out STD_LOGIC_VECTOR(2 downto 0));
          
end positionCounter;

architecture Behavioral of positionCounter is
	signal D : unsigned (2 downto 0) := "000";
	signal soundMove : std_logic_vector(2 downto 0) := "000";
	
	
begin
	

--3-bit up/down counter
Counter: process(UP, DOWN, rst, D, Clk)
begin
	if rising_edge(Clk) then
		if rst = '1' then
			D <= "000";
         soundMove <= "000";
		else
			if UP='1' and DOWN='0' then
				if D="111" then
					D <= D;
					soundMove <= "001"; --sound signal for getting stuck
				else
					D <= D + 1;
					soundMove <= "101"; --sound signal for moving freely
				end if;
			elsif DOWN='1' and UP='0' then
				if D="000" then
					D <= D;
					soundMove <= "001";	--sound signal for getting stuck
				else
					D <= D - 1;
					soundMove <= "101";	--sound signal for moving freely
				end if;
			else 
				D <= D;
            soundMove <= "000";
			end if;
		end if;
	end if;
end process Counter;
count <= std_logic_vector(D);
makeSoundMove <= soundMove;

end Behavioral;

