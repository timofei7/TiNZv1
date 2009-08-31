----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009

-- Create Date:    19:54:44 08/08/2009 
-- Module Name:    GameLogic - Behavioral 
-- Project Name: 	 TINZ (This Is Not Zelda)

-- Description: Finite state machine that looks up the collision data for the player's
-- current location and evaluates the player status (shielded, unshielded, death, etc.)
-- based on the collision data and the player's current state.
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
			  collisionData : in  STD_LOGIC_VECTOR (1 downto 0);	--from Gameboard Module
           logicEN : in  STD_LOGIC;		--from MainController
           gameOver : in  STD_LOGIC;	--from Play module
			  activeSeeker : in STD_LOGIC; --from HeatSeeker Module
			  seekerHit : IN STD_LOGIC; --from HeatSeeker Module
			  initHeatSeeker : OUT STD_LOGIC; --to HeatSeeker Module
           disablePU : out  STD_LOGIC;		--to Gameboard module
           death : out  STD_LOGIC;			--to MainController
			  makeSoundLogic : out STD_LOGIC_VECTOR(2 downto 0); --to Noises module
			  soundSelect : out STD_LOGIC; --to Noises module, gives priority to sounds from GameLogic
			  playerColor : out STD_LOGIC_VECTOR (1 downto 0));	--to the PlayerColor module
end GameLogicFSM;

architecture Behavioral of GameLogicFSM is

	constant NCLKDIV: integer := 27; 					--assuming clock freq of 50 MHz
   constant MAXCLKDIV: integer := 2**NCLKDIV-1; 

   signal disableShieldTimer:  unsigned(NCLKDIV-1 downto 0) := (others=>'0'); 	-- timer count value
	signal startShieldTimer : std_logic;							--signal to start shieldDisableTimer
   signal shieldDepleted:       std_logic;                    -- signal to set shield to 0 after 
																				  --hitting enemy with shield
																			
	--States and signals for FSM
	type stateType is (Unshielded, DeathState, GetShield, Shielded, LoseToPU, LoseToEnemy, DoNothing, WaitBeforeLose);
   signal currState, nextState: stateType;

	--Timer signal to convert levels into pulses
   signal countvamp: unsigned(1 downto 0):="00";
	
	signal soundSig : std_logic_vector(2 downto 0) := "000"; --for Noises module
   signal currPlayerColor : std_logic_vector(1 downto 0) := "00";	--for PlayerColor module
   signal disableSig : std_logic := '0';	--for Gameboard module
	signal deathSig: std_logic:= '0';	--for MainController

begin


--This is a monopulser for death signal
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
         if gameOver = '1' or (activeSeeker='1' and seekerHit='1') then
            currState <= DeathState;
         else
            currState <= nextState;
         end if;
      else
         currState <= DoNothing; --do nothing if logic disabled 
      end if;
   else
      currState <= currState;
   end if;
end process stateUpdate;

disablePU <= disableSig;
makeSoundLogic <= soundSig;

--FSM for GameLogic
GameLogic: process(currState, collisionData, logicEN, shieldDepleted, activeSeeker)
begin
	nextState <= currState;							
   --Defaults
   disableSig <='0';
   deathSig <='0';
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
	initHeatSeeker <= '0'; --for HeatSeeker module
   case currState is
		--If logicEN is high, transition to Unshielded state
      when DoNothing =>
         if logicEN = '1' then
            nextState <= Unshielded;
         else
            nextState <= currState; 
         end if;
		--Player has no shield
      when Unshielded =>		
         if (collisionData="00" or collisionData="01") then --if Player is on unoccupied location
            nextState <= Unshielded;								--remain Unshielded
         elsif collisionData = "10" then							--if Player hits powerup
            nextState <= GetShield;									--transition to GetShield state
         else 
            nextState <= DeathState;								--Else player hit enemy, transition to Death
         end if;
		--Game over or player hit enemy without shield; deadend state
      when DeathState => 	
         deathSig <= '1';		--assert death signal for MainController
			soundSig <= "011";	--Sound for beginning of death siren
			soundSelect <= '1';	--for Noises module
         nextState <= DeathState;	--remain in DeathState
		--Got powerup while Unshielded
      when GetShield =>		
         disableSig <= '1';	--disable powerup
         currPlayerColor <= "01";	--set color to Shielded color
			soundSig <= "010";  --Sound for getting power-up
			soundSelect <= '1'; --for Noises module
			if activeSeeker='0' then	--If no HeatSeekers are active, initialize one 
				initHeatSeeker <= '1';	--Only allow one active HeatSeeker at a given time
			end if;
         nextState <= Shielded;
		--Player is shielded
      when Shielded =>	
         currPlayerColor <= "01";	--player color set to Shielded color
         startShieldTimer <='1';		
         if (collisionData ="00" or collisionData="01") then	--If player hits unoccupied loc
            nextState <= Shielded;										
         elsif collisionData="11" then									--If player hits enemy
            nextState <= WaitBeforeLose;
         elsif collisionData="10" and shieldDepleted='1' then	--If player hits powerup
            nextState <= LoseToPU;
         end if;
      when WaitBeforeLose =>
         nextState <= LoseToEnemy;  --allow shieldtimer to reset
		--Lose shield by hitting enemy while shielded
      when LoseToEnemy =>	
         currPlayerColor <= "10";	--set player color to losing shield color
         disableSig <= '1';			--disable enemy
         startShieldTimer <= '1';	--enable shield depletion timer, player invincible until shield depleted
			soundSig <= "001";			--sound for losing power-up
			soundSelect <= '1'; 			--for Noises module
         if shieldDepleted='0' then	
            nextState <= LoseToEnemy;
         else 
            nextState <= Unshielded; --transition to Unshielded when shieldDepleted asserted
         end if;
		--Lose shield by hitting powerup while shielded; also disables powerup 
      when LoseToPU =>		
         currPlayerColor <= "00";	--set player color to Unshielded
         disableSig <= '1';			--disable power-up
			soundSig <= "001"; 			--sound for losing power-up
			soundSelect <= '1'; 			--for Noises module
         nextState <= Unshielded;
      when others =>
         nextState <= currState;
   end case;
end process GameLogic;
playerColor <= currPlayerColor;


end Behavioral;

