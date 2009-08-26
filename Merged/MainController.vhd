----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    18:27:09 08/17/2009 
-- Design Name: 
-- Module Name:    MainController - Behavioral 
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


entity MainController is
    Port ( Clk : in STD_LOGIC;
           death : in  STD_LOGIC;
           seqDone : in  STD_LOGIC;
			  WIN : in STD_LOGIC;
           ResetALL : in STD_LOGIC;
           GameOver : in STD_LOGIC;
           Level    : out  STD_LOGIC_VECTOR(1 downto 0);
           LevelDifficulty: out STD_LOGIC_VECTOR(1 downto 0);
           seqReset : out  STD_LOGIC;
           TESTOUT: out std_logic_vector(7 downto 0);
           displaySelector : out  STD_LOGIC_VECTOR(1 downto 0);
           sevenSegEN : out  STD_LOGIC;
           winSound : out std_logic;
           resetGameT : out  STD_LOGIC;
           resetPlayer : out  STD_LOGIC;
			  moveEN : out STD_LOGIC;
           displayEN : out  STD_LOGIC;
           gameLogicEN : out  STD_LOGIC;
			  soundEN : out STD_LOGIC; 	--for Noises module
           sevenSegSelector : out  STD_LOGIC);
end MainController;

architecture Behavioral of MainController is
	constant NCLKDIV: integer := 28;					--assuming clock freq of 50 MHz
   constant MAXCLKDIV: integer := 2**NCLKDIV-1; -- max count of clock divider, 1...11
	
	signal startResetTimer : std_logic := '0';
	signal gameReset : std_logic := '0';
	signal gameResetCount : unsigned(NCLKDIV-1 downto 0) := (others=>'0');

	type stateType is (Start, IntroDisplay, Reset, Play, StartDeath, DeathDisplay, StartWin, WinDisplay, Waiting);
   signal currState, nextState: stateType;
   
   signal teststate: std_logic_vector(2 downto 0):= "000";
   signal statesig: std_logic_vector(2 downto 0):= "000";
   
   signal LevelSig: unsigned(1 downto 0):= "00";
   signal LevelDifficultySig: unsigned(1 downto 0):= "00";

begin

TESTOUT <= "0000" & death & teststate;

Level <= std_logic_vector(LevelSig);


--level and difficulty counter
process(Clk)
   begin
      if rising_edge(Clk) then
--         if gameOver = '1' then  --reset to level 1 if you timeout
--            LevelSig <= "00";
         if WIN = '1' then --increment da level!  we just roll over to level 0 if person is awesome
            if LevelSig = "11" then
               LevelDifficultySig <= LevelDifficultySig + 1;
            end if;
            LevelSig <= LevelSig + 1; --implement something cooler like switching accelerometer axis!
         end if;
      end if;
end process;

--test stuff remove
process(Clk)
   begin
      if rising_edge(Clk) then
         if teststate = statesig then
            teststate <= teststate;
         else
            teststate <= statesig;
         end if;
      end if;
end process;

--Timer for game reset
--Timer starts FSM enters Waiting state
gameResetTimer: process(Clk, startResetTimer) 
   begin 
		if startResetTimer='1' then
			if rising_edge(Clk) then 
				gameResetCount <= gameResetCount+1;
			else
				gameResetCount <= gameResetCount;
			end if;
		else 
			gameResetCount <= (others=>'0');
		end if;
end process gameResetTimer; 
-- Clock enable pulse, once per 2^NCLKDIV
gameReset <= '1' when gameResetCount = MAXCLKDIV else '0'; --CHANGE so that gameReset is given active high
																				--when WIN sequence is done

--Synchronize state transitions with rising clock edge
stateUpdate: process(Clk)
begin
   if rising_edge(Clk) then
      if resetALL = '1' then
         currState <= Reset; --reset stuffs
      else
         currState <= nextState;
      end if;
	else
		currState <= currState;
   end if;
end process stateUpdate;


--FSM for Controller
ControllerFSM: process(currState, death, seqDone, gameReset, WIN)
begin
	--Defaults
	seqReset <= '0';
	displaySelector <= "00";
	sevenSegEN <= '0';
	resetGameT <= '0';
	resetPlayer <= '0';
	moveEN <= '0';
	displayEN <= '0';
	gameLogicEN <= '0';
	sevenSegSelector <= '0';
	startResetTimer <= '0';
	soundEN <= '0';
   winSound <= '0'; --this is hack.... rethink
   statesig <= "000"; --FOR TESTING ONLY
	case currState is
		when Start =>
			seqReset <= '1';
			nextState <= IntroDisplay;
         statesig <= "000";
		when IntroDisplay =>
         statesig <= "001";
			displaySelector <= "01";
			displayEN <= '1';
			if seqDone='1' then
				nextState <= Reset;
			else
				nextState <= IntroDisplay;
			end if;
		when Reset =>
         statesig <= "010";
			sevenSegEN <= '1';
			resetGameT <= '1';
			resetPlayer <= '1';
			seqReset <= '1';
         nextState <= Play;
		when Play =>
         statesig <= "011";
			sevenSegEN <= '1';
			displayEN <= '1';
			gameLogicEN <= '1';
			moveEN <= '1';
			soundEN <= '1';
			if death='1' then
				nextState <= StartDeath;
			elsif WIN='1' then
				nextState <= StartWin;		--Change to win sequence state?? for now, keep in Waiting
			else
				nextState <= Play;
			end if;
		when StartDeath =>
         statesig <= "100";
         gameLogicEN <= '1';
         soundEN <= '1';
			seqReset <= '1';
			nextState <= DeathDisplay;
		when DeathDisplay =>
         statesig <= "101";
			displaySelector <= "10";
			displayEN <= '1';
			soundEN <= '1';
			if seqDone='1' then
				nextState <= Waiting;
			else 
				nextState <= DeathDisplay;
			end if;
      when StartWin =>
         gameLogicEN <= '1';
         soundEN <= '1';
			seqReset <= '1';
			nextState <= WinDisplay;
		when WinDisplay =>
         statesig <= "111";
			displaySelector <= "11";
			displayEN <= '1';
			soundEN <= '1';
         winSound <= '1';
			if seqDone='1' then
				nextState <= Waiting;
			else 
				nextState <= winDisplay;
			end if;
		when Waiting =>
         statesig <= "110";
			displayEN <= '1';
			displaySelector <= "10";
			sevenSegEN <= '1';
			sevenSegSelector <= '1';
			startResetTimer <= '1';
			if gameReset='1' then
				nextState <= Reset;
			else
				nextState <= Waiting;
			end if;
		when others =>
			nextState <= currState;
		end case;
end process ControllerFSM;


end Behavioral;

