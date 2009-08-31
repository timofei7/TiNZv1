----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009

-- Create Date:    12:59:57 08/09/2009 
-- Module Name:    Player - Behavioral 
-- Project Name: 	TINZ (This Is Not Zelda)

-- Description: This module receives signals from the ACCELDecoder to increment
-- or decrement the player's x and y position and keep track of the number of moves
-- the player makes. Has instantiations of positionCounter and moveCounter.

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Player is
    Port ( Clk : in STD_LOGIC;
			  xPlus : in  STD_LOGIC;	--from Accelerometer
           xMinus : in  STD_LOGIC;	--from Accelerometer
           yPlus : in  STD_LOGIC;	--from Accelerometer
           yMinus : in  STD_LOGIC;	--from Accelerometer
           resetPlayer : in  STD_LOGIC;	--from Controller
			  moveEN : in STD_LOGIC; 		--from Controller
           playerX : out  STD_LOGIC_VECTOR(2 downto 0);	--to Gameboard and Display
           playerY : out  STD_LOGIC_VECTOR(2 downto 0);	--to Gameboard and Display
			  moveCountOnes : out STD_LOGIC_VECTOR(3 downto 0);	--to GameTimer
			  moveCountTens : out STD_LOGIC_VECTOR(3 downto 0);	--to GameTimer
			  moveCountHundreds : out STD_LOGIC_VECTOR(3 downto 0);	--to GameTimer
			  makeSoundMove : out STD_LOGIC_VECTOR(2 downto 0)	--to Noises
			  );
end Player;

architecture Behavioral of Player is

signal moveSig : std_logic := '0';
signal playerXSig : std_logic_vector(2 downto 0) := "000";
signal playerYSig : std_logic_vector(2 downto 0) := "000";
signal incrementTens : std_logic := '0';
signal DOUT10 : std_logic := '0';
signal incrementHundreds : std_logic := '0';	
signal xSound : std_logic_vector(2 downto 0) := "000";
signal ySound : std_logic_vector(2 downto 0) := "000";

COMPONENT positionCounter
	PORT(
		UP : IN std_logic;
		DOWN : IN std_logic;
		rst : IN std_logic;
		Clk : IN std_logic;          
		count : OUT std_logic_vector(2 downto 0);
		makeSoundMove : out STD_LOGIC_VECTOR(2 downto 0)
		);
	END COMPONENT;
	
	COMPONENT moveCounter
	PORT(
		Clk : IN std_logic;
		move : IN std_logic;
		reset : IN std_logic;          
		onesMove : OUT std_logic_vector(3 downto 0);
		DOUT : OUT std_logic
		);
	END COMPONENT;

begin

--Row number of player
locationX: positionCounter PORT MAP(
		UP => xPlus,
		DOWN => xMinus,
		rst => resetPlayer,
		Clk => Clk,
		count => playerXSig,
		makeSoundMove => xSound
	);
playerX <= playerXSig;


--Column number of player
locationY: positionCounter PORT MAP(
		UP => yPlus,
		DOWN => yMinus,
		rst => resetPlayer,
		Clk => Clk,
		count => playerYSig,
		makeSoundMove => ySound
	);
playerY <= playerYSig;
makeSoundMove <= xSound or ySound;
	
incrementHundreds <= '1' when (DOUT10='1' and incrementTens='1') else '0';

--Ones digit for move counter
onesPlayerMoves: moveCounter PORT MAP(
		Clk => Clk,
		move => moveSig,
		reset => resetPlayer,
		onesMove => moveCountOnes,
		DOUT => incrementTens
	);

--Tens digit for move counter
tensPlayerMoves: moveCounter PORT MAP(
		Clk => Clk,
		move => incrementTens,
		reset => resetPlayer,
		onesMove => moveCountTens,
		DOUT => DOUT10
	);

--Hundreds digit for move counter
hundredsPlayerMoves: moveCounter PORT MAP(
		Clk => Clk,
		move => incrementHundreds,
		reset => resetPlayer,
		onesMove => moveCountHundreds,
		DOUT => OPEN
	);


--Sends signals to moveCounters when appropriate
countMoves: process(xPlus, xMinus, yPlus, yMinus, resetPlayer, moveSig, Clk)
begin
	if rising_edge(Clk) then
		if moveEN='1' then
			if ((xPlus = '1' and playerXSig /= "111") xor (xMinus = '1' and playerXSig /= "000")) or ((yPlus = '1' and playerYSig /= "111") xor (yMinus = '1' and playerYSig /= "000")) then
				moveSig <= '1';
			else
				moveSig <= '0';
			end if;
		else
			moveSig <= '0';
		end if;
	end if;
end process countMoves;
	
end Behavioral;

