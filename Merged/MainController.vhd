----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009

-- Create Date:    18:27:09 08/17/2009 
-- Module Name:    MainController - Behavioral 
-- Project Name: 	TINZ (This Is Not Zelda)

-- Description: This is the controller, coded as a finite state machine, for the 
--	entire game. Handles starting the game, resetting, and ending the game appropriately,
-- either in a death sequence or a win sequence, depending on input signals.
-- If game ends due to the player losing or the timing running out, death sequence is
-- played and game resets on that level. If player wins, win sequence is played
-- and game resets to next level. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MainController is
    Port ( Clk : in STD_LOGIC;
           death : in  STD_LOGIC;	--from GameLogicFSM or Play module
           seqDone : in  STD_LOGIC;	--from Sequences
			  WIN : in STD_LOGIC;		--from Gameboard
           ResetALL : in STD_LOGIC;	--from switch on FPGA
           Level    : out  STD_LOGIC_VECTOR(1 downto 0);	--to Gameboard
           LevelDifficulty: out STD_LOGIC_VECTOR(1 downto 0);	--to Play
           seqReset : out  STD_LOGIC;	--to Sequences
           displaySelector : out  STD_LOGIC_VECTOR(1 downto 0);	--to Display
           displayEN : out  STD_LOGIC;	--to Display
			  sevenSegEN : out  STD_LOGIC;	--to Play
           sevenSegSelector : out  STD_LOGIC; --to Play
			  resetGameT : out  STD_LOGIC;	--to Play
           resetPlayer : out  STD_LOGIC;	--to Play
			  moveEN : out STD_LOGIC;			--to Play
           gameLogicEN : out  STD_LOGIC;	--to GameLogicFSM
			  winSound : out std_logic;		--to Noises
			  soundEN : out STD_LOGIC); 	--for Noises module
           
end MainController;

architecture Behavioral of MainController is
	--Constants and signals for delaying game reset after winning/losing a level
	constant NCLKDIV: integer := 28;					--assuming clock freq of 50 MHz
   constant MAXCLKDIV: integer := 2**NCLKDIV-1; 
	
	signal startResetTimer : std_logic := '0';
	signal gameReset : std_logic := '0';
	signal gameResetCount : unsigned(NCLKDIV-1 downto 0) := (others=>'0');

	--Game states for FSM
	type stateType is (Start, IntroDisplay, Reset, Play, StartDeath, DeathDisplay, StartWin, WinDisplay, Waiting);
   signal currState, nextState: stateType;
   
   --Signals for switching levels and increasing difficulty
   signal LevelSig: unsigned(1 downto 0):= "00";
   signal LevelDifficultySig: unsigned(1 downto 0):= "00";

begin


Level <= std_logic_vector(LevelSig);

--level and difficulty counter
--Increments level if previous one is won and increases difficulty
--if all four are won
process(Clk)
   begin
      if rising_edge(Clk) then
         if WIN = '1' then --increment level!  
            if LevelSig = "11" then
               LevelDifficultySig <= LevelDifficultySig + 1; --if all four levels beaten, roll over
            end if;														 --to level 0, but increase difficulty
            LevelSig <= LevelSig + 1; 
			else
				LevelSig <= LevelSig;
         end if;
      end if;
end process;


--Timer for game reset
--Timer starts when FSM enters Waiting state
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
gameReset <= '1' when gameResetCount = MAXCLKDIV else '0'; 
																				

--Synchronize state transitions with rising clock edge
stateUpdate: process(Clk)
begin
   if rising_edge(Clk) then
      if resetALL = '1' then
         currState <= Reset; --reset state
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
   winSound <= '0'; 
	case currState is
		--Start of game, reset sequences and automatically go to IntroDisplay state
		when Start =>
			seqReset <= '1';
			nextState <= IntroDisplay;
		--Select and display intro sequence; advance to Reset state when seqDone is asserted
		when IntroDisplay =>
			displaySelector <= "01";
			displayEN <= '1';
			if seqDone='1' then
				nextState <= Reset;
			else
				nextState <= IntroDisplay;
			end if;
		--Reset game timer, player location and sequences and enable seven segment display
		--Automatically transition to Play state
		when Reset =>
			sevenSegEN <= '1';
			resetGameT <= '1';
			resetPlayer <= '1';
			seqReset <= '1';
         nextState <= Play;
		--Enable display, GameLogic, player moves and sound
		--Change to different state based on whether player won or lost
		when Play =>
			sevenSegEN <= '1';
			displayEN <= '1';
			gameLogicEN <= '1';
			moveEN <= '1';
			soundEN <= '1';
			if death='1' then
				nextState <= StartDeath; --If player loses, StartDeath state is entered
			elsif WIN='1' then
				nextState <= StartWin;	--If player wins, StartWin state is entered
			else
				nextState <= Play;
			end if;
		--GameLogic and sound are still enabled; death sequence is reset
		--Automatically transition to DeathDisplay state
		when StartDeath =>
         gameLogicEN <= '1';
         soundEN <= '1';
			seqReset <= '1';
			nextState <= DeathDisplay;
		--Death sequence is selected and displayed
		--Transition to Waiting state when seqDone is asserted
		when DeathDisplay =>
			displaySelector <= "10";
			displayEN <= '1';
			soundEN <= '1';
			if seqDone='1' then
				nextState <= Waiting;
			else 
				nextState <= DeathDisplay;
			end if;
		--GameLogic and sound are still enabled; win sequence is reset
		--Automatically transition to WinDisplay state
      when StartWin =>
         gameLogicEN <= '1';
         soundEN <= '1';
			seqReset <= '1';
			nextState <= WinDisplay;
		--Win sequence is selected and displayed
		--Transition to Waiting state when seqDone is asserted
		when WinDisplay =>
			displaySelector <= "11";
			displayEN <= '1';
			soundEN <= '1';
         winSound <= '1';
			if seqDone='1' then
				nextState <= Waiting;
			else 
				nextState <= winDisplay;
			end if;
		--Display last frame of either death or win sequence while displaying score
		--Enable gameResetTimer and transition to Reset state when gameReset is asserted
		when Waiting =>
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

