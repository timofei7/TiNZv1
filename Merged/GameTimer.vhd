----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:48:55 08/16/2009 
-- Design Name: 
-- Module Name:    GameTimer - Behavioral 
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


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GameTimer is
    Port ( Clk : in STD_LOGIC;
			  resetGameT : in  STD_LOGIC;
			  sevenSegEN : in STD_LOGIC;
           numMovesOnes : in  std_logic_vector(3 downto 0);
			  numMovesTens : in  std_logic_vector(3 downto 0);
			  numMovesHundreds: in  std_logic_vector(3 downto 0);
           sevenSegSelector : in  STD_LOGIC;
           gameOver : out  STD_LOGIC;
			  an : out STD_LOGIC_VECTOR(3 downto 0);
           segDisplay : out  STD_LOGIC_VECTOR (0 to 6));
end GameTimer;

architecture Behavioral of GameTimer is

COMPONENT unitCounter
	GENERIC(START_VALUE : unsigned(3 downto 0));
	PORT(
		Clk : IN std_logic;
		timerEN : IN std_logic; 
		reset : IN std_logic;
		currTime : OUT std_logic_vector(3 downto 0);
		DOUT : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT AnodeDriver
	PORT(
		displayEN : IN std_logic;
		reset : IN std_logic;
		Clk50 : IN std_logic;          
		count : OUT std_logic_vector(1 downto 0);
		an : OUT std_logic_vector(3 downto 0)
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

signal anodeCount : std_logic_vector(1 downto 0) := "00";
signal Yh : std_logic_vector(0 to 6) := "0000000";
signal O : std_logic_vector(3 downto 0) := "0000";
signal runTimer : std_logic := '0';
signal DOUT10 : std_logic := '0';
signal DOUT100 : std_logic :='0';
signal decrementTens : std_logic := '0';
signal decrementHundreds : std_logic := '0';
signal Ones : std_logic_vector(3 downto 0) := "0000";
signal Tens : std_logic_vector(3 downto 0) := "0000";
signal Hundreds : std_logic_vector(3 downto 0) := "0000";

begin

runTimer <= '1' when (sevenSegEN='1' and sevenSegSelector='0') else '0';
decrementHundreds <= '1' when (DOUT10='1' and decrementTens='1') else '0';


OnesCounter: unitCounter 
GENERIC MAP(START_VALUE => "0000")
PORT MAP(
		Clk => Clk,
		timerEN => runTimer,
		reset => resetGameT,
		currTime => Ones,
		DOUT => decrementTens
	);


TensCounter: unitCounter 
GENERIC MAP(START_VALUE => "0010")
PORT MAP(
		Clk => Clk,
		timerEN => decrementTens,
		reset => resetGameT,
		currTime => Tens,
		DOUT => DOUT10
	);

HundredsCounter: unitCounter 
GENERIC MAP(START_VALUE => "0001")
PORT MAP(
		Clk => Clk,
		timerEN => decrementHundreds,
		reset => resetGameT,
		currTime => Hundreds,
		DOUT => DOUT100
	);
	
AnodeDriverDevice: AnodeDriver PORT MAP(
		displayEN => sevenSegEN,
		reset => resetGameT,
		Clk50 => Clk,
		count => anodeCount,
		an => an
	);
	
	

timeUp: process(Clk, Ones, Tens, Hundreds)
begin
	if rising_edge(Clk) then
		if sevenSegEN='1' then
			if Ones="0000" and Tens="0000" and Hundreds="0000" then
				gameOver<='1';
			else
				gameOver<='0';
			end if;
		end if;
	end if;
end process timeUp;

sevenSegDisplay: process(sevenSegSelector, Ones, Tens, Hundreds, numMovesHundreds, numMovesTens, numOnes, anodeCount)
begin
	if sevenSegSelector='0' then	--display timer on seven seg display
		case anodeCount is
         when "00" => O <= "0000";
         when "01" => O <= Hundreds;
         when "10" => O <= Tens;
         when "11" => O <= Ones;
         when others => O <= "0000";
      end case;
	else
		case anodeCount is					--display score on seven seg display
         when "00" => O <= "0000";
         when "01" => O <= numMovesHundreds;
         when "10" => O <= numMovesTens;
         when "11" => O <= numMovesOnes;
         when others => O <= "0000";
		end case;
	end if;
end process sevenSegDisplay;

--7-SEGMENT DISPLAY
seg_display: process(O, Yh)
begin
	case O is
		when "0000" => Yh <= "1111110";	--active high definitions in case statement
		when "0001" => Yh <= "0110000";
		when "0010" => Yh <= "1101101"; 
		when "0011" => Yh <= "1111001"; 
		when "0100" => Yh <= "0110011"; 
		when "0101" => Yh <= "1011011"; 
		when "0110" => Yh <= "1011111"; 
		when "0111" => Yh <= "1110000"; 
		when "1000" => Yh <= "1111111"; 
		when "1001" => Yh <= "1111011"; 
		when "1010" => Yh <= "1110111"; 
		when "1011" => Yh <= "0011111"; 
		when "1100" => Yh <= "1001110"; 
		when "1101" => Yh <= "0111101"; 
		when "1110" => Yh <= "1001111"; 
		when "1111" => Yh <= "1000111"; 
		when others => Yh <= "0000000"; 
	end case;
	segDisplay <= not(Yh);	--convert to active low
end process seg_display;


end Behavioral;

