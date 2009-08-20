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
           resetDisplay : in  STD_LOGIC;
           MOSI : out  STD_LOGIC;
           SCLK : out  STD_LOGIC;
           CS : out  STD_LOGIC);
end cellGame;

architecture Behavioral of cellGame is

COMPONENT Display
	PORT(
		Clk : IN std_logic;
		displayEN : IN std_logic;
		resetDisplay : IN std_logic;
		shiftToLED : IN std_logic;
		playerX : IN std_logic_vector(2 downto 0);
		playerY : IN std_logic_vector(2 downto 0);
		colorByte : IN std_logic_vector(7 downto 0);
		introByte : IN std_logic_vector(7 downto 0);
		deathByte : IN std_logic_vector(7 downto 0);
		playerColor : IN std_logic_vector(7 downto 0);
		selectDisplay : IN std_logic_vector(1 downto 0);
		colorReady : IN std_logic;      
      displayDone : IN std_logic;
		getRow : OUT std_logic_vector(2 downto 0);
		getColumn : OUT std_logic_vector(2 downto 0);
		getColor : OUT std_logic;
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
   

signal colorDisplay : std_logic_vector(7 downto 0) := "11100000";
signal ColorReady : std_logic := '0';
signal dataReady : std_logic := '0';
signal startDisplayProcess : std_logic := '0';
signal shiftToDisplay : std_logic := '0';
signal playerX : std_logic_vector(2 downto 0) := "010";
signal playerY : std_logic_vector(2 downto 0) := "010";
signal playerColor : std_logic_vector(7 downto 0) := "00001111";
signal introColor : std_logic_vector(7 downto 0) := "00000000";
signal deathColor : std_logic_vector(7 downto 0) := "00000000";
signal selectBoard : std_logic_vector(1 downto 0) := "00";
signal row : std_logic_vector(2 downto 0) := "000";
signal col : std_logic_vector(2 downto 0) := "000";
signal memEN : std_logic := '0';
signal displayBit : std_logic := '0';
signal startDisplay : std_logic := '0';
signal displayDone : std_logic := '0';

signal defunct1 : std_logic := '0';
signal defunct2 : std_logic_vector(1 downto 0) := "00";
signal defunct3 : std_logic_vector(2 downto 0) := "000";
signal defunct3B : std_logic_vector(2 downto 0) := "000";
signal colorDefunct : std_logic_vector(7 downto 0) := "00000000";

-- state machine for controlling display parts
type state_type is (sStart, sIdle, sDisableWait, sResetWait, sDoneWait);	-- state machine
signal curr_state: state_type := sStart;
signal next_state: state_type;

begin

disp: Display PORT MAP(
		Clk => Clk,
		displayEN => displayEN,
		resetDisplay => resetDisplay,
		shiftToLED => shiftToDisplay,
		playerX => playerX,
		playerY => playerY,
		colorByte => colorDisplay,
		introByte => introColor,
		deathByte => deathColor,
		playerColor => playerColor,
		selectDisplay => selectBoard,
		colorReady => ColorReady,
      displayDone => displayDone,
		getRow => row,
		getColumn => col,
		getColor => memEN,
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
		ResetPUs => defunct1,
		DisablePU => defunct1,
		ReadENColor => memEN,
		RowA => row,
		ColA => col,
		ColorOUT => colorDefunct,
		ColorDONE => dataReady,
		RowB => defunct3,
		ColB => defunct3B,
		CollisionData => defunct2
	);
   


controlls: process(curr_state, DisplayDone, DisplayEN, resetDisplay)
begin
   --Defaults
   startDisplayProcess <= '0';
   next_state <= curr_state;
   
   case curr_state is
      when sStart =>
         startDisplayProcess <= '1';
         if DisplayDone = '1' then
            next_state <= sDoneWait;
         else
            next_state <= sIdle;
         end if;
      when sIdle =>
         if DisplayDone = '1' then
            next_state <= sStart;
         elsif DisplayEN = '0' then
            next_state <= sDisableWait;
         elsif resetDisplay = '1' then
            next_state <= sResetWait;
         end if;
      when sResetWait =>
         if ResetDisplay = '0' then
            next_state <= sIdle;
         elsif DisplayEN = '0' then
            next_state <=sDisableWait;
         end if;
      when sDoneWait =>
         if DisplayDone = '0' then
            next_state <= sIdle;
         elsif resetDisplay = '1' then
            next_state <= sResetWait;
         elsif DisplayEN = '0' then
            next_state <=sDisableWait;
         end if;
      when sDisableWait => 
         if DisplayEN ='1' then
            next_state <= sStart;
         end if;
      when others =>
         next_state <= sStart;
   end case;
end process controlls; 

ColorReady <= startDisplayProcess or dataReady;     
         
         
         

statechanger:
process (Clk)
begin
	if rising_edge(Clk) then --slow us down to at most 125khz
		curr_state <= next_state;
	end if;
end process statechanger;

end Behavioral;



