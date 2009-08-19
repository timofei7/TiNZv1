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
-- Description: Alternative version of GameLogic module. Coded as FSM. Includes timer for shield disable.
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

entity GameLogicFSM is
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
end GameLogicFSM;

architecture Behavioral of GameLogicFSM is

	constant NCLKDIV: integer := 1; --26;					--assuming clock freq of 50 MHz
   constant MAXCLKDIV: integer := 2**NCLKDIV-1; -- max count of clock divider, 1...11

-- internal signals
   signal disableShieldTimer:  unsigned(NCLKDIV-1 downto 0) := (others=>'0'); 	-- timer count value
	signal startShieldTimer : std_logic;							--signal to start shieldDisableTimer
   signal shieldDepleted:       std_logic;                    -- signal to set shield to 0 after 
																				  --hitting enemy with shield
	signal currPlayerColor : std_logic_vector(1 downto 0) := "00";

	type stateType is (Unshielded, DeathState, GetShield, Shielded, LoseToPU, LoseToEnemy);
   signal currState, nextState: stateType;


begin

--Timer for shield disable
--Timer starts when player hits enemy when shielded
shieldDisableTimer: process(Clk, startShieldTimer)
   begin 
		if startShieldTimer='1' then
			if rising_edge(Clk) then 
				disableShieldTimer <= disableShieldTimer+1;
			else
				disableShieldTimer <= disableShieldTimer;
			end if;
		else 
			disableShieldTimer <= (others=>'0');
		end if;
end process shieldDisableTimer; 
-- Clock enable pulse, once per 2^NCLKDIV
shieldDepleted <= '1' when disableShieldTimer = MAXCLKDIV else '0';


--Synchronize state transitions with rising clock edge
stateUpdate:
process(Clk)
begin
   if rising_edge(Clk) then
      currState <= nextState;
   end if;
end process stateUpdate;


--FSM for GameLogic
GameLogic: process(Clk, currState, collisionData, logicEN, gameOver, isEN, shieldDepleted, shieldStatus)
begin
	if logicEN='1' then													--if GameLogic enabled
		--Defaults
		disablePU <='0';
		death <='0';
		shieldSet <= shieldStatus;
		currPlayerColor <= "00";
		startShieldTimer <= '0';
		case currState is
			when Unshielded =>		--no shield
				shieldSet <= '0';
				if (collisionData="00" or collisionData="01" or (collisionData="11" and isEN='0')) and gameOver='0' then
					nextState <= Unshielded;
				elsif (collisionData = "11" and isEN='1') and gameOver='0' then
					nextState <= getShield;
				else 
					nextState <= DeathState;
				end if;
			when DeathState => 	--game over or hit enemy without shield
				death <= '1';
				nextState <= DeathState;
			when GetShield =>		--got powerup while unshielded
				shieldSet <= '1';
				disablePU <= '1';
				currPlayerColor <= "01";
				if gameOver='0' then
					nextState <= Shielded;
				else
					nextState <= DeathState;
				end if;
			when Shielded =>		--shielded
				shieldSet <= '1';
				currPlayerColor <= "01";
				startShieldTimer <='1';
				if (collisionData ="00" or collisionData="01" or (collisionData="11" and isEN='0')) and gameOver='0' then
					nextState <= Shielded;
				elsif collisionData="10" and gameOver='0' then
					nextState <= LoseToEnemy;
				elsif collisionData="11" and isEn='1' and gameOver='0' and shieldDepleted='1' then
					nextState <= LoseToPU;
				else
					nextState <= DeathState;
				end if;
			when LoseToEnemy =>	--lose shield by hitting enemy while shielded
				currPlayerColor <= "10";
				shieldSet <= '1';
				startShieldTimer <= '1';
				if gameOver='0' and shieldDepleted='0' then
					nextState <= LoseToEnemy;
				elsif gameOver='0' and shieldDepleted='1' then
					nextState <= Unshielded;
				else
					nextState <= DeathState;
				end if;
			when LoseToPU =>		--lose shield by hitting powerup while shielded; also disables powerup 
				currPlayerColor <= "00";
				disablePU <= '1';
				shieldSet <= '0';
				if gameOver='0' then
					nextState <= Unshielded;
				else
					nextState <= DeathState;
				end if;
			when others =>
				nextState <= currState;
		end case;
	else						--logicEN='0'
		disablePU <='0';
		death <='0';
		shieldSet <= '0';
		currPlayerColor <= "00";
		startShieldTimer <= '0';
		nextState <= Unshielded;
	end if;
end process GameLogic;
playerColor <= currPlayerColor;


end Behavioral;

