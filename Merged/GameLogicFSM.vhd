----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
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
 

entity GameLogicFSM is
    Port ( Clk: in STD_LOGIC;
			  collisionData : in  STD_LOGIC_VECTOR (1 downto 0);
          -- shieldStatus : in  STD_LOGIC;
           logicEN : in  STD_LOGIC;
           gameOver : in  STD_LOGIC;
			 -- isEN : in STD_LOGIC;
           TESTOUT: out std_logic_vector(7 downto 0);
           disablePU : out  STD_LOGIC;
           death : out  STD_LOGIC;
          -- shieldSet : out  STD_LOGIC;
			  makeSoundLogic : out STD_LOGIC_VECTOR(2 downto 0); --for Noises module
			  soundSelect : out STD_LOGIC; --for Noises module, gives priority to sounds from GameLogic
			  playerColor : out STD_LOGIC_VECTOR (1 downto 0));
end GameLogicFSM;

architecture Behavioral of GameLogicFSM is

	constant NCLKDIV: integer := 27; 					--assuming clock freq of 50 MHz
   constant MAXCLKDIV: integer := 2**NCLKDIV-1; -- max count of clock divider, 1...11

-- internal signals
   signal disableShieldTimer:  unsigned(NCLKDIV-1 downto 0) := (others=>'0'); 	-- timer count value
	signal startShieldTimer : std_logic;							--signal to start shieldDisableTimer
   signal shieldDepleted:       std_logic;                    -- signal to set shield to 0 after 
																				  --hitting enemy with shield
	signal currPlayerColor : std_logic_vector(1 downto 0) := "00";
   signal disableSig : std_logic := '0';
	
	signal soundSig : std_logic_vector(2 downto 0) := "000"; --for Noises module
	
   signal deathTest : std_logic := '0';
	signal unshieldedState, deathStateSig, GetShieldState, ShieldedState, LoseToPUState, LoseToEnemyState : std_logic;

	type stateType is (Unshielded, DeathState, GetShield, Shielded, LoseToPU, LoseToEnemy);
   signal currState, nextState: stateType;

   signal countvamp: unsigned(1 downto 0):="00";
   signal vampTC: std_logic;

   signal deathSig: std_logic:= '0';

begin

TESTOUT <= deathTest & disableSig & unshieldedState & deathStateSig & GetShieldState & ShieldedState & LoseToPUState & LoseToEnemyState; --FOR TESTING

--this is a monopulser for this signal
process(Clk)
begin
   if rising_edge(Clk) then
      if deathSig = '0' then
         countvamp <= "00";
      elsif countvamp /= "10" then
         countvamp <= countvamp +1;
      end if;
   end if;
end process;
death <= '1' when countvamp = "01" else '0';

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
      if logicEN = '1' then
         if gameOver = '1' then
            currState <= DeathState;
         else
            currState <= nextState;
         end if;
      else
         currState <= UnShielded;
      end if;
   else
      currState <= currState;
   end if;
end process stateUpdate;


disablePU <= disableSig;
makeSoundLogic <= soundSig;

--FSM for GameLogic
GameLogic: process(currState, collisionData, logicEN, shieldDepleted)
begin
	nextState <= currState;							
   --Defaults
   disableSig <='0';
   deathSig <='0';
   deathTest <= '0';
   --shieldSet <= shieldStatus;
   currPlayerColor <= "00";
   startShieldTimer <= '0';
   unshieldedState <= '0';
   deathStateSig <= '0';
   GetShieldState <= '0';
   ShieldedState <= '0';
   LoseToPUState <= '0';
   LoseToEnemyState <= '0';
	soundSig<= "000"; --for Noises module
	soundSelect <= '0'; --for Noises module
   case currState is
      when Unshielded =>		--no shield
         --shieldSet <= '0';
         unshieldedState <= '1'; --TeSTING
         if (collisionData="00" or collisionData="01") then
            nextState <= Unshielded;
         elsif collisionData = "10" then
            nextState <= getShield;
         else 
            nextState <= DeathState;
         end if;
      when DeathState => 	--game over or hit enemy without shield
         deathStateSig <= '1'; --TESTING
         deathSig <= '1';
         deathTest <= '1'; --for testing purposes REMOVE
			soundSig <= "011";	--sound for beginning of death siren
			soundSelect <= '1';	--for Noises module
         nextState <= DeathState;
      when GetShield =>		--got powerup while unshielded
         getShieldState <= '1'; --TESTING
         --shieldSet <= '1';
         disableSig <= '1';
         currPlayerColor <= "01";
			soundSig <= "010";  --sound for getting power-up
			soundSelect <= '1'; --for Noises module
         nextState <= Shielded;
      when Shielded =>		--shielded
         shieldedState <= '1'; --TESTING
         --shieldSet <= '1';
         currPlayerColor <= "01";
         startShieldTimer <='1';
         if (collisionData ="00" or collisionData="01") then
            nextState <= Shielded;
         elsif collisionData="11" then
            nextState <= LoseToEnemy;
         elsif collisionData="10" and shieldDepleted='1' then
            nextState <= LoseToPU;
         end if;
      when LoseToEnemy =>	--lose shield by hitting enemy while shielded
         LoseToEnemyState <= '1'; --TESTING
         currPlayerColor <= "10";
         disableSig <= '1';
         --shieldSet <= '1';
         startShieldTimer <= '1';
			soundSig <= "001";	--sound for losing power-up
			soundSelect <= '1'; --for Noises module
         if shieldDepleted='0' then
            nextState <= LoseToEnemy;
         else 
            nextState <= Unshielded;
         end if;
      when LoseToPU =>		--lose shield by hitting powerup while shielded; also disables powerup 
         LoseToPUState <= '1'; --TESTING
         currPlayerColor <= "00";
         disableSig <= '1';
			soundSig <= "001"; --sound for losing power-up
			soundSelect <= '1'; --for Noises module
         --shieldSet <= '0';
         nextState <= Unshielded;
      when others =>
         nextState <= currState;
   end case;
end process GameLogic;
playerColor <= currPlayerColor;


end Behavioral;

