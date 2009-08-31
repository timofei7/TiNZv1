----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009

-- Create Date:    13:35:17 08/16/2009 
-- Module Name:    unitCounter - Behavioral 
-- Project Name:	TINZ (This Is Not Zelda)


-- Description: This module is used to keep track of a single digit for the game 
-- timer. When timer is enabled, the count decrements and asserts a DOUT signal when
-- it rolls back from 0 to 9, indicating the next digit should decrement. Can be
-- initialized to a certain value. Is instantiated in the GameTimer module.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity unitCounter is
GENERIC (START_VALUE : unsigned(3 downto 0) := "0000");
Port ( 	  Clk : 	in   STD_LOGIC;
			  timerEN : in STD_LOGIC;	--from MainController through GameTimer
			  reset : in STD_LOGIC;		--from MainController through GameTimer
			  currTime : out STD_LOGIC_VECTOR(3 downto 0);	--to GameTimer
			  DOUT : out STD_LOGIC);	--to GameTimer
end unitCounter;

architecture Behavioral of unitCounter is
	constant NCLKDIV:	integer := 26;	 --Change to 26 to get freq of 1 Hz
	constant MAXCLKDIV: integer := 2**NCLKDIV-1;	-- max count of clock divider, 1...11

	-- internal signals
	signal clkdivcount: 	unsigned(NCLKDIV-1 downto 0) := (others => '0');	-- clock divider count value
	signal slowCE:       std_logic;                    -- slow clock enable
	signal DOnes : unsigned (3 downto 0) := START_VALUE;	--ones digit
	
	
begin

--Clock signal
ClockDivider: process( Clk )	
begin 
	if rising_edge(Clk) then 
		clkdivcount <= clkdivcount+1;	
	end if;
end process ClockDivider; 
-- Clock enable pulse, once per 2^NCLKDIV
slowCE <= '1' when (clkdivcount = MAXCLKDIV) else '0';


--4-bit up/down counter
--Represents single digit
--Counts down when enabled, and rolls over from 0 to 9
CounterOnes: process(Clk, timerEN, DOnes)
	begin
	if rising_edge(Clk) then 
		if reset='1' then
			DOnes <= START_VALUE;
		elsif timerEN='1' and slowCE='1' then
			if DOnes="0000" then
				DOnes <= "1001";
			else
				DOnes <= DOnes - 1;
			end if;
		else 
			DOnes<=DOnes;
		end if;
	end if;
	
end process CounterOnes;

currTime <= std_logic_vector(DOnes);
--Digit counter rolling back from 0 to 9, need to decrement next digit
DOUT <= '1' when (Dones = "0000" and timerEN='1') else '0';


end Behavioral;

