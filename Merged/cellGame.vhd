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
           displayEN : in  STD_LOGIC;
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
           sevenSegSelector: in std_logic;
           an : OUT std_logic_vector(3 downto 0);
           seg : OUT std_logic_vector(0 to 6)
); 
end cellGame;

architecture Behavioral of cellGame is

COMPONENT GameLogicFSM
PORT(
   Clk : IN std_logic;
   collisionData : IN std_logic_vector(1 downto 0);
   shieldStatus : IN std_logic;
   logicEN : IN std_logic;
   gameOver : IN std_logic;
   isEN : IN std_logic;          
   disablePU : OUT std_logic;
   death : OUT std_logic;
   shieldSet : OUT std_logic;
   playerColor : OUT std_logic_vector(1 downto 0)
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
   seg : OUT std_logic_vector(0 to 6)
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
signal colorDisplay : std_logic_vector(7 downto 0) := "00000001";
signal ColorReady : std_logic := '0';
signal dataReady : std_logic := '0';
--signal startDisplayProcess : std_logic := '0';
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
signal defunct3 : std_logic_vector(2 downto 0) := "000";
signal defunct3B : std_logic_vector(2 downto 0) := "000";
signal colorDefunct : std_logic_vector(7 downto 0) := "00000000";

signal playerSelector: std_logic_vector(1 downto 0) := "00";

signal resetGameT: std_logic:='0';
signal sevenSegEN: std_logic:='1';
signal gameOver: std_logic:='0';
signal death: std_logic;
signal logicen: std_logic:= '1';
signal shieldstatus: std_logic:='0';
signal shieldset: std_logic:='0';

begin
deathout<=death;
resetDisplay <= '1' when displayEN='0' else '0';
Xout<=playerX;
Yout<=playerY;

gamelogical: GameLogicFSM PORT MAP(
		Clk => Clk,
		collisionData => collisionData,
		shieldStatus => shieldStatus, --BOGUS
		logicEN => logicEN,
		gameOver => gameOver,
		isEN => collisiondata(1),
		disablePU => disablePU,
		death => death,
		shieldSet => shieldSet, --BOGUS
		playerColor => playerSelector
	);

playplay: Play PORT MAP(
		Clk => Clk,
		Xin => Xin,
		Yin => Yin,
		XAnalogIn => XAnalogIn,
		YAnalogIn => YAnalogIn,
		XAnalogOut => XAnalogOUt,
		YAnalogOut => YAnalogOut,
      TESTOUT => TESTOUT,
		resetPlayer => ResetDisplay,
		playerX => playerX,
		playerY => playerY,
		resetGameT => ResetGameT,
		sevenSegEN => sevenSegEN,
		sevenSegSelector => sevenSegSelector,
		gameOver => gameOver,
		an => an,
		seg => seg
	);

playacola: PlayerColor PORT MAP(
		Clk => Clk,
		Selector => playerSelector,
		PlayerColor => PlayerColorColor
	);

disp: Display PORT MAP(
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
   
leddrive: LEDDriver PORT MAP(
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
		SeqReset => resetDisplay,
		ResetPUs => resetDisplay,
		DisablePU => disablePU,
		ReadENColor => memEN,
		RowA => row,
		ColA => col,
		ColorOUT => colorDisplay,
		ColorDONE => dataReady,
		RowB => defunct3,
		ColB => defunct3B,
		CollisionData => collisiondata
	);


end Behavioral;



