----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    04:51:52 08/12/2009 
-- Design Name: 
-- Module Name:    Display - Behavioral 
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


entity Display is
    Port ( Clk : in STD_LOGIC;
			  displayEN : in  STD_LOGIC;
			  resetDisplay : in STD_LOGIC;
			  shiftToLED : in STD_LOGIC;
           playerX : in  STD_LOGIC_VECTOR(2 downto 0);
           playerY : in  STD_LOGIC_VECTOR(2 downto 0);
           colorByte : in  STD_LOGIC_VECTOR (7 downto 0);
           introByte : in  STD_LOGIC_VECTOR (7 downto 0);
           deathByte : in  STD_LOGIC_VECTOR (7 downto 0);
           playerColor : in  STD_LOGIC_VECTOR (7 downto 0);
			  selectDisplay : in STD_LOGIC_VECTOR(1 downto 0);
			  colorReady : in STD_LOGIC;
           displayDone : in STD_LOGIC;
           getRow : out  STD_LOGIC_VECTOR(2 downto 0);
           getColumn : out  STD_LOGIC_VECTOR(2 downto 0);
			  getColor : out STD_LOGIC;
			  displayReady : out STD_LOGIC;
           displayBit : out  STD_LOGIC);
end Display;

architecture Behavioral of Display is

signal colorSelected : std_logic_vector(7 downto 0); --color output by 4x1 mux
signal incrementPosition : std_logic := '0';
signal row : unsigned(2 downto 0) := "000";  --row
signal col :unsigned(2 downto 0) := "000"; --column

COMPONENT shiftRegisters
	PORT(
		Clk : IN std_logic;
		dataInReady_tick : IN std_logic;
		dataIn : IN std_logic_vector(7 downto 0);  
		shiftOut : IN std_logic;
		reset : IN std_logic;
		dataShifted8 : OUT std_logic;
		regFilled : OUT std_logic;
		outBit : OUT std_logic
		);
END COMPONENT;

begin

colorRegisters: shiftRegisters PORT MAP(
		Clk => Clk,
		dataInReady_tick => colorReady,
		dataIn => colorSelected,
		shiftOut => shiftToLED,
		reset => resetDisplay,
		dataShifted8 => incrementPosition,
		regFilled => displayReady,
		outBit => displayBit
	);
	
--Counter that sends row and column number to ROM to get color information
LocationCounter: process(Clk, displayEN, incrementPosition, displayDone)
begin
	if rising_edge(Clk) then
		getColor <= '0';
		if resetDisplay='1' then
			row <= "000";
			col <= "000";
      elsif displayEN ='1' then 
			if displayDone='1' then	
				if incrementPosition='1' then					
					if col="111" then
						row <= row + 1;
						col <= col + 1;
						getColor <= '1';
					else 
						col <= col + 1;
						getColor <= '1';
					end if;
				end if;
			else
				col <= col;
				row <= row;
			end if;
		else
			row <= "000";
			col <= "000";
			getColor <= '0';
		end if;
	end if;
end process LocationCounter;	
getRow <= std_logic_vector(row);
getColumn <= std_logic_vector(col);


DisplaySelector: process(selectDisplay, playerX, playerY, row, col, playerColor, colorByte, introByte, deathByte)
begin
	if selectDisplay="00" then
		if row=unsigned(playerX) and col=unsigned(playerY) then
			colorSelected <= playerColor;
		else 
			colorSelected <= colorByte;
		end if;
	elsif selectDisplay="01" then
		colorSelected <= introByte;
	elsif selectDisplay="10" then
		colorSelected <= deathByte;
	else
		colorSelected <= colorByte;
	end if;
end process DisplaySelector;


end Behavioral;

