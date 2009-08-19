----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:54:44 08/08/2009 
-- Design Name: 
-- Module Name:    GameLogic - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GameLogic is
    Port ( Clk: in STD_LOGIC;
			  collisionData : in  STD_LOGIC_VECTOR (1 downto 0);
           shieldStatus : in  STD_LOGIC;
           logicEN : in  STD_LOGIC;
           gameOver : in  STD_LOGIC;
			  isEN : in STD_LOGIC;
           disablePU : out  STD_LOGIC;
           death : out  STD_LOGIC;
           shieldSet : out  STD_LOGIC;
			  playerColor : out STD_LOGIC_VECTOR (1 downto 0));
end GameLogic;

architecture Behavioral of GameLogic is

signal currPlayerColor : std_logic_vector(1 downto 0) := "00";

begin

Logic: process(Clk, collisionData, shieldStatus, logicEN, gameOver, isEN)
begin
	
	if rising_edge(Clk) then
		if logicEN='1' then													--if GameLogic enabled
			--Defaults
			disablePU <='0';
			death <='0';
			shieldSet <= shieldStatus;
			if gameOver='1' then
				death <= '1';
			elsif collisionData(1)='1' then									--if location occupied
				if collisionData(0)='0' and shieldStatus='0' then		--if enemy and no shield
					death<='1';
				end if;
				if collisionData(0)='0' and shieldStatus='1' then		--if enemy and shield
					shieldSet <= '0';
					currPlayerColor <= "10";										--"on top of enemy" color
				end if;
				if collisionData(0)='1' and isEN ='1' and shieldStatus='0' then	--if powerup and no shield
					shieldSet <= '1';
					disablePU <= '1';
					currPlayerColor <= "01";										--shielded player color
				end if;
				if collisionData(0)='1' and isEN ='1' and shieldStatus='1' then 	--if powerup and shield
					shieldSet <= '0';
					disablePU <= '1';
					currPlayerColor <= "00";   									--lose shield, unshielded player color
				end if;
			else 
				if shieldStatus='1' then
					currPlayerColor <= "01";
				else
					currPlayerColor <= "00";
				end if;
			end if;
		else
			disablePU <='0';
			death <='0';
			shieldSet <= '0';
			currPlayerColor <= "00";
		end if;
	end if;
end process Logic;
playerColor <= currPlayerColor;

end Behavioral;

