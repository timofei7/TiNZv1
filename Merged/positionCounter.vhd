----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009

-- Create Date:    13:05:02 08/09/2009 
-- Module Name:    positionCounter - Behavioral 
-- Project Name: 	TINZ (This Is Not Zelda)


-- Description: This module keeps track of position along one axis. Is instantiated
-- in Player and Heatseeker modules. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity positionCounter is
	 Port ( UP : in  STD_LOGIC;
			  DOWN: in STD_LOGIC;
			  initValue: IN STD_LOGIC_VECTOR(2 downto 0) := "000";
			  set : IN STD_LOGIC := '0';
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
		--Reset to position 0
		if rst = '1' then
			D <= "000";
         soundMove <= "000";
		--Set to initValue
		elsif set='1' then
			D <= unsigned(initValue);
		else
			--If move up and position at 7
			if UP='1' and DOWN='0' then
				if D="111" then
					D <= D;
					soundMove <= "001"; --sound signal for getting stuck
			--If move up and position not at 7
				else
					D <= D + 1;
					soundMove <= "101"; --sound signal for moving freely
				end if;
			--If move down and position at 0
			elsif DOWN='1' and UP='0' then
				if D="000" then
					D <= D;
					soundMove <= "001";	--sound signal for getting stuck
			--If move down and position not at 0
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

