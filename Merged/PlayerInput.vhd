----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    08:51:16 08/19/2009 
-- Design Name: 
-- Module Name:    PlayerInput - Behavioral 
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

entity PlayerInput is
    Port ( 
      Clk : in  STD_LOGIC;
      Xin : IN std_logic; --from accelerometer
      Yin : IN std_logic; --''
      XAnalogIn : IN std_logic; --need to hook up to analog input pins
      YAnalogIn : IN std_logic; --''
      XAnalogOut : OUT std_logic; --need to hook up to something to prevent errors
      YAnalogOut : OUT std_logic; --''
      resetPlayer : IN std_logic; --resets player pos
      playerX : OUT std_logic_vector(2 downto 0); --current pos
      playerY : OUT std_logic_vector(2 downto 0); --''
      moveCountOnes : OUT std_logic_vector(3 downto 0); --move counter for displaying score
      moveCountTens : OUT std_logic_vector(3 downto 0); --''
      moveCountHundreds : OUT std_logic_vector(3 downto 0) --''
    );
end PlayerInput;

architecture Behavioral of PlayerInput is

COMPONENT ACCELDecoder
PORT(
   Clk : IN std_logic;
   Xin : IN std_logic;
   Yin : IN std_logic;
   XAnalogIn : IN std_logic;
   YAnalogIn : IN std_logic;
   XAnalogOut : OUT std_logic;
   YAnalogOut : OUT std_logic;
   XMinus : OUT std_logic;
   XPlus : OUT std_logic;
   YMinus : OUT std_logic;
   YPlus : OUT std_logic
   );
END COMPONENT;

COMPONENT Player
PORT(
   Clk : IN std_logic;
   xPlus : IN std_logic;
   xMinus : IN std_logic;
   yPlus : IN std_logic;
   yMinus : IN std_logic;
   resetPlayer : IN std_logic;          
   playerX : OUT std_logic_vector(2 downto 0);
   playerY : OUT std_logic_vector(2 downto 0);
   moveCountOnes : OUT std_logic_vector(3 downto 0);
   moveCountTens : OUT std_logic_vector(3 downto 0);
   moveCountHundreds : OUT std_logic_vector(3 downto 0)
   );
END COMPONENT;

signal XMinus : std_logic; --internal pulse of detected move from accelerometer
signal XPlus : std_logic;  --''
signal YMinus : std_logic; --''
signal YPlus : std_logic;  --''

begin

theaccelerometer: ACCELDecoder PORT MAP(
		Clk => Clk,
		Xin => Xin,
		Yin => Yin,
		XAnalogIn => XAnalogIn,
		YAnalogIn => YAnalogIn,
		XAnalogOut => XAnalogOut,
		YAnalogOut => YAnalogOut,
		XMinus => XMinus,
		XPlus => XPlus,
		YMinus => YMinus,
		YPlus => YPlus
	);
   
theplayer: Player PORT MAP(
		Clk => Clk,
		xPlus => XPlus,
		xMinus => XMinus,
		yPlus => YPlus,
		yMinus => YMinus,
		resetPlayer => resetPlayer,
		playerX => playerX,
		playerY => playerY,
		moveCountOnes => moveCountOnes,
		moveCountTens => moveCountTens,
		moveCountHundreds => moveCountHundreds 
	);
end Behavioral;

