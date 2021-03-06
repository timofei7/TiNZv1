----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009

-- Module Name:    AnodeDriver - Behavioral 
--	Project Name: TINZ (This Is Not Zelda)

-- Description: This is code to model a an anode driver consisting of a 2-bit 
--	counter and a 2-to-4 decoder.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity AnodeDriver is
Port ( reset : in STD_LOGIC; --from MainController through GameTimer
		 Clk50 : in STD_LOGIC;
		 displayEN : in STD_LOGIC;	--from MainController through GameTimer
		 count : out  STD_LOGIC_VECTOR(1 downto 0);			--passed to mux in GameTimer
		 an : out STD_LOGIC_VECTOR (3 downto 0));				--4-bit value passed to anodes out of GameTimer
end AnodeDriver;


architecture Behavioral of AnodeDriver is
-- # bits in clock divider  
	-- Output frequency = Input frequency / 2^NCLKDIV
	-- NCLKDIV=25 with 50 MHz clock gives 50 MHz / 2^25 = 1.49 Hz
	constant NCLKDIV:	integer := 18;
	constant MAXCLKDIV: integer := 2**NCLKDIV-1;	-- max count of clock divider, 1...11

	-- internal signals
	signal clkdivcount: 	unsigned(NCLKDIV-1 downto 0);	-- clock divider count value
   signal CE : std_logic := '0';
	signal C: unsigned(1 downto 0) := "00";
	signal D : STD_LOGIC_VECTOR (3 downto 0) := "0000";
	
	
begin

--Clock signal
ClockDivider: process( Clk50 )	
begin 
		if rising_edge(Clk50) then 
			clkdivcount <= clkdivcount+1;	
		end if;
end process ClockDivider; 
CE <= '1' when clkdivcount = MAXCLKDIV else '0';

--2-bit up counter
Counter: process(Clk50, reset)
	begin
		if rising_edge(Clk50) then
			if CE='1' and reset='0' then
				C <= C + 1;
			elsif reset='1' then
				C <= "00";
			else 
				C <= C;
			end if;
		end if;
		
end process Counter;
count <= std_logic_vector(not(C)); --active-low output

--2-to-4 decoder
Decoder: process(D, C, displayEN)
begin
	case C is
		when "00" => D <= "0001";	--active high definitions in case statement
		when "01" => D <= "0010";
		when "10" => D <= "0100";
		when "11" => D <= "1000";
		when others => D <= "0001";
	end case;
	if displayEN='1' then
		an <= not(D); --convert to active low
	else
		an <="1111";
	end if;
end process Decoder;

end Behavioral;

