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
          -- displayEN : in  STD_LOGIC; --Included as signal rather than port
         --  resetDisplay : in  STD_LOGIC;
           MOSI : out  STD_LOGIC;
           SCLK : out  STD_LOGIC;
           CS : out  STD_LOGIC;
           TESTOUT: out std_logic_vector(7 downto 0);
           Xin : IN std_logic;
           Yin : IN std_logic;
           XAnalogIn : IN std_logic;
           YAnalogIn : IN std_logic;
           XAnalogOut : OUT std_logic;
           YAnalogOut : OUT std_logic;
           Xout: OUT std_logic_vector(2 downto 0);
           Yout: OUT std_logic_vector(2 downto 0);
           deathout: out std_logic;
           NoiseOut: out std_logic;
           NoiseType: in std_logic_vector(2 downto 0);
         --  NoiseON: in std_logic; --Included as signal, rather than port
			--  sevenSegSelector: in std_logic; --Included as signal rather than port, can use port for testing
           an : OUT std_logic_vector(3 downto 0);
           seg : OUT std_logic_vector(0 to 6)
); 
end cellGame;

architecture Behavioral of cellGame is

COMPONENT MainController
	PORT(
		Clk : IN std_logic;
		introDone : IN std_logic;
		death : IN std_logic;
		deathDone : IN std_logic;
		WIN : IN std_logic;          
		seqReset : OUT std_logic;
		displaySelector : OUT std_logic_vector(1 downto 0);
		sevenSegEN : OUT std_logic;
		resetGameT : OUT std_logic;
		resetPlayer : OUT std_logic;  
		moveEN : OUT std_logic;
      TESTOUT: out std_logic_vector(7 downto 0);
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
   --shieldStatus : IN std_logic;
   logicEN : IN std_logic;
   gameOver : IN std_logic;
   --isEN : IN std_logic;  
   TESTOUT: OUT std_logic_vector(7 downto 0);
   disablePU : OUT std_logic;
   death : OUT std_logic;
   --shieldSet : OUT std_logic;
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
   TESTOUT: out std_logic_vector(7 downto 0);
   deathColor : OUT std_logic_vector(7 downto 0);
   introColor : OUT std_logic_vector(7 downto 0)
   );
END COMPONENT;


COMPONENT Noises
PORT(
   Clk : IN std_logic;
  -- NoiseType : IN std_logic_vector(2 downto 0);
 --  NoiseON : IN std_logic; 
	soundEN : IN STD_LOGIC;		 --enables sound, sent from Controller
	soundSelect : IN STD_LOGIC;  --chooses between sound cmd from GameLogic or Player
	makeSoundLogic : IN STD_LOGIC_VECTOR(2 downto 0);
	makeSoundMove : IN STD_LOGIC_VECTOR(2 downto 0); 
   NoiseOut : OUT std_logic;
	TESTOUT : OUT STD_LOGIC_VECTOR(7 downto 0)
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
   TESTOUT: out std_logic_vector(7 downto 0);
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
		playerColor : IN std_logic_vector(7 downto 0);
		selectDisplay : IN std_logic_vector(1 downto 0);
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
		ColorOUT : OUT std_logic_vector(7 downto 0);
		ColorDONE : OUT std_logic;
		CollisionData : OUT std_logic_vector(1 downto 0)
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
signal soundEN : std_logic := '0'; --HARDCODING for TESTING
signal soundSelect : std_logic := '0';
signal makeSoundLogic : std_logic_vector(2 downto 0) := "000";
signal makeSoundMove : std_logic_vector(2 downto 0) := "000";

begin
deathout<=death;
resetDisplay <= '1' when displayEN='0' else '0';
Xout<=playerX;
Yout<=playerY;

--TESTOUT <= "000000" & gameOver & death;

endGame <= death or gameOver;
--resetDisplay <= not(displayEN); --there are 2 versions...

GameController: MainController PORT MAP(
		Clk => Clk,
		introDone => seqDone,
		death => endGame,
		deathDone => seqDone,
		WIN => WIN,
		seqReset => OPEN,
		displaySelector => selectBoard,
		sevenSegEN => sevenSegEN,
		resetGameT => resetTimer,
		resetPlayer => resetPlayer,
		moveEN => moveEN,
      TESTOUT => OPEN,
	--	resetPU => resetDisplay,
		displayEN => displayEN,
		gameLogicEN => logicEN,
		soundEN => soundEN,
		sevenSegSelector => sevenSegSelector
	);

thegamelogic: GameLogicFSM PORT MAP(
		Clk => Clk,
		collisionData => collisionData,
		--shieldStatus => shieldStatus, --BOGUS
		logicEN => logicEN,
		gameOver => gameOver,
		--isEN => collisiondata(1),
      TESTOUT => TESTOUT,
		disablePU => disablePU,
		death => death,
		makeSoundLogic => makeSoundLogic,
		soundSelect => soundSelect,
		--shieldSet => shieldSet, --BOGUS
		playerColor => playerSelector
	);
   
thesequences: Sequences PORT MAP(
		Clk => Clk,
		row => row,
      col => col,
      TESTOUT => OPEN,
		seqReset => ResetDisplay,
		seqDone => seqDone,
		deathColor => deathColor,
		introColor => introColor
	);   
   
thenoises: Noises PORT MAP(
		Clk => Clk,
		--NoiseType => NoiseType,
		--NoiseON => NoiseON,
		soundEN => soundEN,
		soundSelect => soundSelect,
		makeSoundLogic => makeSoundLogic,
		makeSoundMove => makeSoundMove,
		NoiseOut => NoiseOut,
		TESTOUT => OPEN
	);


theplay: Play PORT MAP(
		Clk => Clk,
		Xin => Xin,
		Yin => Yin,
		XAnalogIn => XAnalogIn,
		YAnalogIn => YAnalogIn,
		XAnalogOut => XAnalogOUt,
		YAnalogOut => YAnalogOut,
      TESTOUT => OPEN,
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
		playerColor => playerColorColor,
		selectDisplay => selectBoard,
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
		CollisionData => collisiondata
	);


end Behavioral;



