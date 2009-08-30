----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009
-- 
-- Create Date:    23:19:55 08/18/2009 
-- Module Name:    cellGame - Behavioral 
-- Project Name:  TINZ (This Is Not Zelda)


-- Description: This is the top-level module for the entire design. Here, the 
--	components for all the main modules are instantiated and wired together.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cellGame is
    Port ( Clk : in  STD_LOGIC;
           ResetALL : in  STD_LOGIC; --needs more work, do we need it?
           Difficulty: in std_logic_vector(2 downto 0); --cheat difficulty set
           SoundON: in std_logic; --disable sound switch
           Xin : IN std_logic;  --from accelerometer
           Yin : IN std_logic;  -- from accelerometer
           XAnalogIn : IN std_logic;  --this is to prevent interference from unused signals
           YAnalogIn : IN std_logic;  --''
           XAnalogOut : OUT std_logic;--''
           YAnalogOut : OUT std_logic;--''
           Xout: OUT std_logic_vector(2 downto 0); --to LED lights on FPGA for fun
           Yout: OUT std_logic_vector(2 downto 0); --to LED lights on FPGA for fun
           MOSI : out  STD_LOGIC;  --out to LED display
           SCLK : out  STD_LOGIC;  --out to LED display
           CS : out  STD_LOGIC;    --out to LED display
			  NoiseOut: out std_logic;   --to piezo
           an : OUT std_logic_vector(3 downto 0); --for seven segment display on FPGA
           seg : OUT std_logic_vector(0 to 6)	--for seven segment display on FPGA
); 
end cellGame;

architecture Behavioral of cellGame is

--Controller for entire game
--Handles start, resetting and end
COMPONENT MainController
	PORT(
		Clk : IN std_logic;
		death : IN std_logic;
		seqDone : IN std_logic;
		WIN : IN std_logic;
      ResetALL: IN std_logic;
      Level : OUT std_logic_vector(1 downto 0);
      LevelDifficulty: out STD_LOGIC_VECTOR(1 downto 0);
		seqReset : OUT std_logic;
		displaySelector : OUT std_logic_vector(1 downto 0);
		sevenSegEN : OUT std_logic;
		resetGameT : OUT std_logic;
		resetPlayer : OUT std_logic;  
		moveEN : OUT std_logic;
      winSound: out std_logic;
		displayEN : OUT std_logic;
		gameLogicEN : OUT std_logic;
		soundEN : OUT std_logic;
		sevenSegSelector : OUT std_logic
		);
	END COMPONENT;

--FSM to evaluate player positions and collisions 
COMPONENT GameLogicFSM
PORT(
   Clk : IN std_logic;
   collisionData : IN std_logic_vector(1 downto 0);
   logicEN : IN std_logic;
   gameOver : IN std_logic;
   disablePU : OUT std_logic;
   death : OUT std_logic;
	activeSeeker : in STD_LOGIC; --from HeatSeeker Module
   seekerHit : IN STD_LOGIC; --from HeatSeeker Module
   initHeatSeeker : OUT STD_LOGIC; --to HeatSeeker Module
	makeSoundLogic : OUT std_logic_vector(2 downto 0);
	soundSelect : OUT std_logic;
   playerColor : OUT std_logic_vector(1 downto 0)
   );
END COMPONENT;

--Holds ROMs containing color data for intro, death and win sequences 
COMPONENT Sequences
PORT(
   Clk : IN std_logic;
   row : IN std_logic_vector(2 downto 0);
   col : IN std_logic_vector(2 downto 0);
   seqReset : IN std_logic;          
   seqDone : OUT std_logic;
   deathColor : OUT std_logic_vector(7 downto 0);
   introColor : OUT std_logic_vector(7 downto 0);
   winColor   : OUT std_logic_vector(7 downto 0)
   );
END COMPONENT;

--Outputs a level and frequencies to piezo to create sound when appropriate
COMPONENT Noises
PORT(
   Clk : IN std_logic;
	soundEN : IN STD_LOGIC;		 --enables sound, sent from Controller
	soundSelect : IN STD_LOGIC;  --chooses between sound cmd from GameLogic or Player
	makeSoundLogic : IN STD_LOGIC_VECTOR(2 downto 0);
	makeSoundMove : IN STD_LOGIC_VECTOR(2 downto 0); 
   winSound: in std_logic;
   NoiseOut : OUT std_logic
   );
END COMPONENT;

--Combines Accelerometer, Player and GameTimer modules
COMPONENT Play
PORT(
   Clk : IN std_logic;
   Xin : IN std_logic;
   Yin : IN std_logic;
   XAnalogIn : IN std_logic;
   YAnalogIn : IN std_logic;
   resetPlayer : IN std_logic;
	moveEN : IN std_logic;
   resetGameT : IN std_logic;
   SpeedRate: IN std_logic_vector(1 downto 0);
   LevelDifficulty: in STD_LOGIC_VECTOR(1 downto 0);
   sevenSegEN : IN std_logic;
   sevenSegSelector : IN std_logic;          
   XAnalogOut : OUT std_logic;
   YAnalogOut : OUT std_logic;
   playerX : OUT std_logic_vector(2 downto 0);
   playerY : OUT std_logic_vector(2 downto 0);
   gameOver : OUT std_logic;
   an : OUT std_logic_vector(3 downto 0);
   seg : OUT std_logic_vector(0 to 6);
	makeSoundMove : OUT std_logic_vector(2 downto 0)
   );
END COMPONENT;

--Cycles through colors for to output as player color to Display
--This module is responsible for giving the impression that the player is "breathing"
COMPONENT PlayerColor
PORT(
   Clk : IN std_logic;
   Selector : IN std_logic_vector(1 downto 0);          
   PlayerColor : OUT std_logic_vector(7 downto 0)
   );
END COMPONENT;

--Interacts with the LED driver, Player Module, Heatseeker Module
--Cycles through each location on the LED matrix and 
--selects the appropriate colors to send to the LED driver
COMPONENT Display
	PORT(
		Clk : IN std_logic;
		displayEN : IN std_logic;
		shiftToLED : IN std_logic;
		playerX : IN std_logic_vector(2 downto 0);
		playerY : IN std_logic_vector(2 downto 0);
		colorByte : IN std_logic_vector(7 downto 0);
		introByte : IN std_logic_vector(7 downto 0);
		deathByte : IN std_logic_vector(7 downto 0);
      winByte   : IN std_logic_vector(7 downto 0);
		playerColor : IN std_logic_vector(7 downto 0);
		selectDisplay : IN std_logic_vector(1 downto 0);
		heatSeekerColor : IN STD_LOGIC_VECTOR(7 downto 0); --from Heatseeker Module
	   heatSeekerX : IN STD_LOGIC_VECTOR(2 downto 0);
	   heatSeekerY : IN STD_LOGIC_VECTOR(2 downto 0);
	   activeSeeker : IN STD_LOGIC;    
      displayDone : IN std_logic;
		getRow : OUT std_logic_vector(2 downto 0);
		getColumn : OUT std_logic_vector(2 downto 0);
		displayReady : OUT std_logic;
		displayBit : OUT std_logic
		);
END COMPONENT;

--Interface between the Display module and LED matrix
--Sends display data to LED matrix at appropriate rate
COMPONENT LEDDriver
	PORT(
		Clk : IN std_logic;          
		MOSI : OUT std_logic;
		SCLK : OUT std_logic;
      ShiftBitOut : out STD_LOGIC;
      Data: in STD_LOGIC;
      GoDisplay : in  STD_LOGIC;
      displayDone : OUT STD_LOGIC;
		CS : OUT std_logic
		);
END COMPONENT;
   
--Interface between ROM and Display module and GameLogicFSM module
--Given position row and column, looks up collision data for that position
COMPONENT GameBoard
	PORT(
		Clk : IN std_logic;
      WIN: out std_logic;
		SeqReset : IN std_logic;
		ResetPUs : IN std_logic;
		DisablePU : IN std_logic;
		ReadENColor : IN std_logic;
		RowA : IN std_logic_vector(2 downto 0);
		ColA : IN std_logic_vector(2 downto 0);
		RowB : IN std_logic_vector(2 downto 0);
		ColB : IN std_logic_vector(2 downto 0);
      Level: IN std_logic_vector(1 downto 0);
		ColorOUT : OUT std_logic_vector(7 downto 0);
		ColorDONE : OUT std_logic;
		CollisionData : OUT std_logic_vector(1 downto 0)
		);
END COMPONENT;

--When player gets power-up, converts used power-up into 
--"heatseeking ghost" that follows player on the display
COMPONENT HeatSeeker
	PORT(
		Clk : IN std_logic;
		reset : IN std_logic;
		playerX : IN std_logic_vector(2 downto 0);
		playerY : IN std_logic_vector(2 downto 0);
		initHeatSeeker : IN std_logic;          
		heatSeekerColor : OUT std_logic_vector(7 downto 0);
		activeSeeker : OUT std_logic;
		heatSeekerXOut : OUT std_logic_vector(2 downto 0);
		heatSeekerYOut : OUT std_logic_vector(2 downto 0);
		seekerHit : OUT std_logic
		);
END COMPONENT;


--GameController signals
signal resetDisplay : std_logic := '0';
signal resetTimer : std_logic := '0';
signal logicEN : std_logic := '0';
signal displayEN : std_logic := '0';
signal sevenSegEN: std_logic:='0';
signal sevenSegSelector : std_logic := '0'; 
signal resetPlayer : std_logic := '0';
signal moveEN : std_logic := '0';
signal selectBoard : std_logic_vector(1 downto 0) := "00";
signal endGame : std_logic := '0';
signal LevelDifficulty: std_logic_vector(1 downto 0):= "00";
signal LevelDifficultySig: std_logic_vector(1 downto 0):="00";
signal Level: std_logic_vector(1 downto 0);

--Display signals
signal row : std_logic_vector(2 downto 0) := "000";
signal col : std_logic_vector(2 downto 0) := "000";
signal colorDisplay : std_logic_vector(7 downto 0) := "00000001";
signal playerColorByte : std_logic_vector(7 downto 0) := "00001111"; 
signal introColor : std_logic_vector(7 downto 0) := "00000000";
signal deathColor : std_logic_vector(7 downto 0) := "00000000";
signal winColor : std_logic_vector(7 downto 0) := "00000000";
signal shiftToDisplay : std_logic := '0';

--Play signals
signal playerX : std_logic_vector(2 downto 0) := "000";
signal playerY : std_logic_vector(2 downto 0) := "000";
signal gameOver: std_logic:='0';

--LED Driver signals
signal displayBit : std_logic := '0';
signal startDisplay : std_logic := '0';
signal displayDone : std_logic := '0';

--GameLogicFSM signals
signal disablePU : std_logic := '0';
signal collisiondata : std_logic_vector(1 downto 0) := "00";
signal death: std_logic;
signal playerSelector: std_logic_vector(1 downto 0) := "00";

--Gameboard signals
signal WIN: std_logic:='0';

--Sequences signals
signal seqDone: std_logic:='0';

--Sound signals
signal soundEN : std_logic := '0';
signal soundENSig : std_logic := '0'; 
signal soundSelect : std_logic := '0';
signal makeSoundLogic : std_logic_vector(2 downto 0) := "000";
signal makeSoundMove : std_logic_vector(2 downto 0) := "000";
signal winSound : std_logic; --this is hack rethink this

--Heat seeking powerup signals
signal initHeatSeeker : std_logic := '0';
signal activeSeeker : std_logic := '0';
signal seekerHit : std_logic := '0';
signal heatSeekerColor : std_logic_vector(7 downto 0) := "00000000";
signal heatSeekerX : std_logic_vector(2 downto 0) := "000";
signal heatSeekerY : std_logic_vector(2 downto 0) := "000";


begin

--override difficulty counter with switches if switch 6 is enabled
LevelDifficultySig <= LevelDifficulty when Difficulty(0) = '0' else Difficulty(2 downto 1);
soundENSig <= soundEN when soundON = '1' else '0';

--resetDisplay when displayEN is low
resetDisplay <= '1' when displayEN='0' else '0';

Xout<=playerX;
Yout<=playerY;

--Controller gets gameOver signal from GameLogicFSM or Play
endGame <= death or gameOver;


GameController: MainController PORT MAP(
		Clk => Clk,
		seqDone => seqDone,
		death => endGame,
		WIN => WIN,
      ResetALL => ResetALL,
      Level => Level,
      LevelDifficulty => LevelDifficulty,
		seqReset => OPEN,
		displaySelector => selectBoard,
		sevenSegEN => sevenSegEN,
      winSound => winSound,
		resetGameT => resetTimer,
		resetPlayer => resetPlayer,
		moveEN => moveEN,
		displayEN => displayEN,
		gameLogicEN => logicEN,
		soundEN => soundEN,
		sevenSegSelector => sevenSegSelector
	);

thegamelogic: GameLogicFSM PORT MAP(
		Clk => Clk,
		collisionData => collisionData,
		logicEN => logicEN,
		gameOver => gameOver,
		disablePU => disablePU,
		death => death,
		makeSoundLogic => makeSoundLogic,
		soundSelect => soundSelect,
		activeSeeker => activeSeeker,
		initHeatSeeker => initHeatSeeker,
		seekerHit => seekerHit,
		playerColor => playerSelector
	);
   
thesequences: Sequences PORT MAP(
		Clk => Clk,
		row => row,
      col => col,
		seqReset => ResetDisplay,
		seqDone => seqDone,
		deathColor => deathColor,
		introColor => introColor,
      winColor => winColor
	);   
   
thenoises: Noises PORT MAP(
		Clk => Clk,
		soundEN => soundENSig,
		soundSelect => soundSelect,
		makeSoundLogic => makeSoundLogic,
		makeSoundMove => makeSoundMove,
		NoiseOut => NoiseOut,
      winSound => winSound
	);


theplay: Play PORT MAP(
		Clk => Clk,
		Xin => Xin,
		Yin => Yin,
		XAnalogIn => XAnalogIn,
		YAnalogIn => YAnalogIn,
		XAnalogOut => XAnalogOUt,
		YAnalogOut => YAnalogOut,
      SpeedRate => Level, --direct correspondence
      LevelDifficulty => LevelDifficultySig,      
		resetPlayer => ResetPlayer,
		moveEN => moveEN,
		playerX => playerX,
		playerY => playerY,
		resetGameT => resetTimer,
		sevenSegEN => sevenSegEN,
		sevenSegSelector => sevenSegSelector,
		gameOver => gameOver,
		makeSoundMove => makeSoundMove,
		an => an,
		seg => seg
	);

theplayercolor: PlayerColor PORT MAP(
		Clk => Clk,
		Selector => playerSelector,
		PlayerColor => PlayerColorByte
	);

thedisplay: Display PORT MAP(
		Clk => Clk,
		displayEN => displayEN,
		shiftToLED => shiftToDisplay,
		playerX => playerX,
		playerY => playerY,
		colorByte => colorDisplay,
		introByte => introColor,
		deathByte => deathColor,
      winByte   => winColor,
		playerColor => playerColorByte,
		selectDisplay => selectBoard,
		heatSeekerColor => heatSeekerColor,
		activeSeeker => activeSeeker,
		heatSeekerX => heatSeekerX,
		heatSeekerY => heatSeekerY,
      displayDone => displayDone,
		getRow => row,
		getColumn => col,
		displayReady => startDisplay,
		displayBit => displayBit
	);
   
theleddriver: LEDDriver PORT MAP(
		Clk => Clk,
		MOSI => MOSI,
		SCLK => SCLK,
      shiftBitOut => shiftToDisplay,
      Data => displayBit,
      GoDisplay => startDisplay,
      displayDone => displayDone,
		CS => CS
	);
   
thegameboard: GameBoard PORT MAP(
		Clk => Clk,
      WIN => WIN,
		SeqReset => resetDisplay,
		ResetPUs => resetDisplay,
		DisablePU => disablePU,
		RowA => row,
		ColA => col,
		ColorOUT => colorDisplay,
		RowB => playerX,
		ColB => playerY,
      Level => Level,
		CollisionData => collisiondata
	);

VengefulPUGhost: HeatSeeker PORT MAP(
		Clk => Clk,
		reset => not(displayEN),
		playerX => playerX,
		playerY => playerY,
		initHeatSeeker => initHeatSeeker,
		heatSeekerColor => heatSeekerColor,
		activeSeeker => activeSeeker,
		heatSeekerXOut => heatSeekerX,
		heatSeekerYOut => heatSeekerY,
		seekerHit => seekerHit
	);



end Behavioral;



