----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31 
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    12:59:57 08/09/2009 
-- Design Name: 
-- Module Name:    Player - Behavioral 
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



entity Player is
    Port ( Clk : in STD_LOGIC;
			  xPlus : in  STD_LOGIC;
           xMinus : in  STD_LOGIC;
           yPlus : in  STD_LOGIC;
           yMinus : in  STD_LOGIC;
           resetPlayer : in  STD_LOGIC;
			  moveEN : in STD_LOGIC; 		--from Controller
           --shieldSet : in  STD_LOGIC;
           playerX : out  STD_LOGIC_VECTOR(2 downto 0);
           playerY : out  STD_LOGIC_VECTOR(2 downto 0);
			  moveCountOnes : out STD_LOGIC_VECTOR(3 downto 0);
			  moveCountTens : out STD_LOGIC_VECTOR(3 downto 0);
			  moveCountHundreds : out STD_LOGIC_VECTOR(3 downto 0);
			  makeSoundMove : out STD_LOGIC_VECTOR(2 downto 0)
           --numMoves : out  STD_LOGIC_VECTOR(7 downto 0)
           --shieldStatus : out  STD_LOGIC
			  );
end Player;

architecture Behavioral of Player is

signal moveSig : std_logic := '0';
--signal shieldSig : STD_LOGIC := '0';
signal playerXSig : std_logic_vector(2 downto 0) := "000";
signal playerYSig : std_logic_vector(2 downto 0) := "000";
signal incrementTens : std_logic := '0';
signal DOUT10 : std_logic := '0';
signal incrementHundreds : std_logic := '0';	
signal DOUT100 : std_logic := '0'; --unused
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
		DOUT => DOUT100
	);

--Shield status of player
--shield: process(shieldSet, resetPlayer)
--begin
--	if resetPlayer = '1' then
--		shieldStatus <= '0';
--	else
--		shieldStatus <= shieldSet;
--	end if;
--end process shield;
--shieldStatus <= shieldSig;


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

