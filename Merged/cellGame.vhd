----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    23:19:55 08/18/2009 
-- Design Name: 
-- Module Name:    cellGame - Behavioral 
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

entity cellGame is
    Port ( Clk : in  STD_LOGIC;
           ResetALL : in  STD_LOGIC; --needs more work, do we need it?
           MOSI : out  STD_LOGIC;  --out to display
           SCLK : out  STD_LOGIC;  --''
           CS : out  STD_LOGIC;    --''
           Difficulty: in std_logic_vector(2 downto 0); --cheat difficulty set
           SoundON: in std_logic; --disalbe sound switch
           Xin : IN std_logic;  --from accelerometer
           Yin : IN std_logic;  -- ''
           XAnalogIn : IN std_logic;  --this is to prevent rando signals
           YAnalogIn : IN std_logic;  --''
           XAnalogOut : OUT std_logic;--''
           YAnalogOut : OUT std_logic;--''
           Xout: OUT std_logic_vector(2 downto 0);
           Yout: OUT std_logic_vector(2 downto 0);
           NoiseOut: out std_logic;   --to piezo
           an : OUT std_logic_vector(3 downto 0);
           seg : OUT std_logic_vector(0 to 6)
); 
end cellGame;

architecture Behavioral of cellGame is

COMPONENT MainController
	PORT(
		Clk : IN std_logic;
		death : IN std_logic;
		seqDone : IN std_logic;
		WIN : IN std_logic;
      ResetALL: IN std_logic;
      GameOver: IN std_logic;
      Level : OUT std_logic_vector(1 downto 0);
      LevelDifficulty: out STD_LOGIC_VECTOR(1 downto 0);
		seqReset : OUT std_logic;
		displaySelector : OUT std_logic_vector(1 downto 0);
		sevenSegEN : OUT std_logic;
		resetGameT : OUT std_logic;
		resetPlayer : OUT std_logic;  
		moveEN : OUT std_logic;
      winSound: out std_logic;
	--	resetPU : OUT std_logic;		--This output directed through ~displayEN
		displayEN : OUT std_logic;
		gameLogicEN : OUT std_logic;
		soundEN : OUT std_logic;
		sevenSegSelector : OUT std_logic
		);
	END COMPONENT;

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


COMPONENT PlayerColor
PORT(
   Clk : IN std_logic;
   Selector : IN std_logic_vector(1 downto 0);          
   PlayerColor : OUT std_logic_vector(7 downto 0)
   );
END COMPONENT;


COMPONENT Display
	PORT(
		Clk : IN std_logic;
		displayEN : IN std_logic;
	--	resetDisplay : IN std_logic;
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
	--	colorReady : IN std_logic;      
      displayDone : IN std_logic;
		getRow : OUT std_logic_vector(2 downto 0);
		getColumn : OUT std_logic_vector(2 downto 0);
--		getColor : OUT std_logic;
		displayReady : OUT std_logic;
		displayBit : OUT std_logic
		);
END COMPONENT;


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
   
signal resetDisplay : std_logic := '0';
signal resetTimer : std_logic := '0';
signal colorDisplay : std_logic_vector(7 downto 0) := "00000001";
signal ColorReady : std_logic := '0';
signal dataReady : std_logic := '0';
signal shiftToDisplay : std_logic := '0';
signal playerX : std_logic_vector(2 downto 0) := "000";
signal playerY : std_logic_vector(2 downto 0) := "000";
signal playerColorColor : std_logic_vector(7 downto 0) := "00001111";
signal introColor : std_logic_vector(7 downto 0) := "00000000";
signal deathColor : std_logic_vector(7 downto 0) := "00000000";
signal winColor : std_logic_vector(7 downto 0) := "00000000";
signal selectBoard : std_logic_vector(1 downto 0) := "00";
signal row : std_logic_vector(2 downto 0) := "000";
signal col : std_logic_vector(2 downto 0) := "000";
signal memEN : std_logic := '1';
signal displayBit : std_logic := '0';
signal startDisplay : std_logic := '0';
signal displayDone : std_logic := '0';

signal disablePU : std_logic := '0';
signal collisiondata : std_logic_vector(1 downto 0) := "00";

signal playerSelector: std_logic_vector(1 downto 0) := "00";

signal resetGameT: std_logic:='0';
signal sevenSegEN: std_logic:='1';
signal gameOver: std_logic:='0';
signal death: std_logic;
--signal logicen: std_logic:= '1';
signal shieldstatus: std_logic:='0';
signal shieldset: std_logic:='0';
signal WIN: std_logic:='0';
signal seqDone: std_logic:='0';


signal endGame : std_logic := '0';
signal logicEN : std_logic := '0';
signal displayEN : std_logic := '0';
signal sevenSegSelector : std_logic := '0'; 
signal resetPlayer : std_logic := '0';
signal moveEN : std_logic := '0';

--Sound signals
signal soundEN : std_logic := '0';
signal soundENSig : std_logic := '0'; 
signal soundSelect : std_logic := '0';
signal makeSoundLogic : std_logic_vector(2 downto 0) := "000";
signal makeSoundMove : std_logic_vector(2 downto 0) := "000";

--Heat seeking powerup signals
signal initHeatSeeker : std_logic := '0';
signal activeSeeker : std_logic := '0';
signal seekerHit : std_logic := '0';
signal heatSeekerColor : std_logic_vector(7 downto 0) := "00000000";
signal heatSeekerX : std_logic_vector(2 downto 0) := "000";
signal heatSeekerY : std_logic_vector(2 downto 0) := "000";

signal LevelDifficulty: std_logic_vector(1 downto 0):= "00";
signal LevelDifficultySig: std_logic_vector(1 downto 0):="00";
signal winSound : std_logic; --this is hack rethink this

signal Level: std_logic_vector(1 downto 0);

begin

--override difficulty counter with switches if switch 6 is enabled
LevelDifficultySig <= LevelDifficulty when Difficulty(0) = '0' else Difficulty(2 downto 1);
soundENSig <= soundEN when soundON = '1' else '0';

resetDisplay <= '1' when displayEN='0' else '0';
Xout<=playerX;
Yout<=playerY;


endGame <= death or gameOver;
--resetDisplay <= not(displayEN); --there are 2 versions...

GameController: MainController PORT MAP(
		Clk => Clk,
		seqDone => seqDone,
		death => endGame,
		WIN => WIN,
      ResetALL => ResetALL,
      GameOver => GameOver,
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
      winSOund => winSound
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
		PlayerColor => PlayerColorColor
	);

thedisplay: Display PORT MAP(
		Clk => Clk,
		displayEN => displayEN,
	--	resetDisplay => resetDisplay,
		shiftToLED => shiftToDisplay,
		playerX => playerX,
		playerY => playerY,
		colorByte => colorDisplay,
		introByte => introColor,
		deathByte => deathColor,
      winByte   => winColor,
		playerColor => playerColorColor,
		selectDisplay => selectBoard,
		heatSeekerColor => heatSeekerColor,
		activeSeeker => activeSeeker,
		heatSeekerX => heatSeekerX,
		heatSeekerY => heatSeekerY,
	--	colorReady => ColorReady,
      displayDone => displayDone,
		getRow => row,
		getColumn => col,
	--	getColor => memEN,
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
		ReadENColor => memEN,
		RowA => row,
		ColA => col,
		ColorOUT => colorDisplay,
		ColorDONE => dataReady,
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



