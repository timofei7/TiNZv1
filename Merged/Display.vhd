----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009

-- Create Date:    04:51:52 08/12/2009 
-- Module Name:    Display - Behavioral 
-- Project Name: 	 TINZ (This Is Not Zelda)

-- Description: This module is the interface between the ROMs containing
-- color data for each location on the board and the LED driver that communicates
-- to the LED backpack. Has a finite state machine to coordinate exchange of
-- data from the ROMs to the LED driver.

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Display is
    Port ( Clk : in STD_LOGIC;
			  displayEN : in  STD_LOGIC;	--from Controller
			  shiftToLED : in STD_LOGIC;	--from LED driver
           playerX : in  STD_LOGIC_VECTOR(2 downto 0);	--from Player
           playerY : in  STD_LOGIC_VECTOR(2 downto 0);	--from Player
           colorByte : in  STD_LOGIC_VECTOR (7 downto 0);	--from Gameboard
           introByte : in  STD_LOGIC_VECTOR (7 downto 0);	--from Sequences
           deathByte : in  STD_LOGIC_VECTOR (7 downto 0);	--from Sequences
           winByte   : in  STD_LOGIC_VECTOR (7 downto 0);	--from Sequences
           playerColor : in  STD_LOGIC_VECTOR (7 downto 0);	--from playerColor
			  selectDisplay : in STD_LOGIC_VECTOR(1 downto 0);	--from MainController
           displayDone : in STD_LOGIC;								--from LED driver		
			  heatSeekerColor : IN STD_LOGIC_VECTOR(7 downto 0); --from Heatseeker Module
			  heatSeekerX : IN STD_LOGIC_VECTOR(2 downto 0);	--from Heatseeker Module
			  heatSeekerY : IN STD_LOGIC_VECTOR(2 downto 0);	--from Heatseeker Module
			  activeSeeker : IN STD_LOGIC;							--from Heatseeker Module
           getRow : out  STD_LOGIC_VECTOR(2 downto 0);		--to Gameboard
           getColumn : out  STD_LOGIC_VECTOR(2 downto 0);	--to Gameboard
			  displayReady : out STD_LOGIC;							--to LED driver
           displayBit : out  STD_LOGIC);							--to LED driver
end Display;

architecture Behavioral of Display is

signal colorSelected : std_logic_vector(7 downto 0); --color output by 4x1 mux
signal incrementPosition : std_logic := '0';
signal row : unsigned(2 downto 0) := "111";  --row
signal col :unsigned(2 downto 0) := "111"; --column
signal resetWorld : std_logic := '0';
signal regFilled : std_logic := '0';

signal colorReady : std_logic := '0';

type stateType is (DoNothing, LoadData, WaitforMem, WaitforLED, CheckReg, IncrementPos, WaitForMemMore);
signal currState, nextState : stateType;

COMPONENT shiftRegisters
	PORT(
		Clk : IN std_logic;
		dataInReady_tick : IN std_logic;
		dataIn : IN std_logic_vector(7 downto 0);  
		shiftOut : IN std_logic;
		reset : IN std_logic;
		regFilled : OUT std_logic;
		outBit : OUT std_logic
		);
END COMPONENT;

begin

displayReady <= regFilled;

--64-byte right shift register containing color data for LED display
colorRegisters: shiftRegisters PORT MAP(
		Clk => Clk,
		dataInReady_tick => colorReady,
		dataIn => colorSelected,
		shiftOut => shiftToLED,
		reset => resetWorld,
		regFilled => regFilled,
		outBit => displayBit
	);

--Transition between states for finite state machine
transitionStates: process (Clk)
begin
	if rising_edge(Clk) then 
      if displayEN='0' then 
         currState <= DoNothing;
      else 
         currState <= nextState;
      end if;
	else
		currState <= currState;
	end if;
end process transitionStates;

--Finite state machine to coordinate communication between shift register and LED driver
DisplayFSM : process(Clk, currState, displayEN, regFilled, displayDone)
begin
	resetWorld <= '0';
	colorReady <= '0';
	incrementPosition <= '0';
	case currState is
		when DoNothing => --display not enabled
			resetWorld <= '1';
			if displayEN='1' then 
				nextState <= IncrementPos;
			else 
				nextState <= DoNothing;
			end if;
		when LoadData =>	--load register 
			colorReady <= '1';
		   nextState <= CheckReg;
		when CheckReg=>	--Check if 64-byte register is full
			if regFilled='1' then
				nextState <= WaitforLED;
			else
				nextState <= IncrementPos;
         end if;
		when IncrementPos =>				--increment position to get color data for next loc on board
			incrementPosition <= '1';
         nextState <= WaitforMem;
      when WaitforMem =>				--give time for new position data to propagate to Gameboard
         nextState <= WaitForMemMore;
      when WaitforMemMore =>			--give ROM time to output correct data for new position
         nextState <= LoadData;
		when WaitforLED =>	--64-byte register filled; wait for displayDone tick from LED driver
			if displayDone='1' then
				nextState <= IncrementPos;
			else
				nextState <= WaitforLED;
			end if;
		when others =>
			nextState <= currState;
	end case;
end process DisplayFSM;


--Counter that sends row and column number to ROM to get color information
LocationCounter: process(Clk, displayEN, incrementPosition, displayDone)
begin
if rising_edge(Clk) then
	if resetWorld='1' then
		row <= "111";
		col <= "111";
	elsif incrementPosition='1' then					
		if col="111" then
			row <= row + 1;
			col <= col + 1;
		else 
			col <= col + 1;
		end if;
	else
		row <= row;
		col <= col;
	end if;
end if;
end process LocationCounter;	
getRow <= std_logic_vector(row);
getColumn <= std_logic_vector(col);


--Select which color byte to load into register becased on selectDisplay input
DisplaySelector: process(selectDisplay, playerX, playerY, row, col, playerColor, colorByte, introByte, deathByte, winByte, activeSeeker, heatSeekerX, heatSeekerY, heatSeekerColor)
begin
	--Color data from Gameboard
	if selectDisplay="00" then
		--Put in player color
		if row=unsigned(playerX) and col=unsigned(playerY) then
			colorSelected <= playerColor;
		--Put in heatseeker color if heatseeker is active
		elsif row=unsigned(heatSeekerX) and col=unsigned(heatSeekerY) and activeSeeker='1' then
			colorSelected <= heatSeekerColor;
		else
			colorSelected <= colorByte;
		end if;
	--Put in color data from intro sequence
	elsif selectDisplay="01" then
		colorSelected <= introByte;
	--Put in color data from death sequence
	elsif selectDisplay="10" then
		colorSelected <= deathByte;
	--Put in color data from win sequence
   elsif selectDisplay="11" then
		colorSelected <= winByte;
	else
		colorSelected <= colorByte;
	end if;
end process DisplaySelector;


end Behavioral;

