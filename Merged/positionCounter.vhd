----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:05:02 08/09/2009 
-- Design Name: 
-- Module Name:    positionCounter - Behavioral 
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

entity positionCounter is
	 Port ( UP : in  STD_LOGIC;
			  DOWN: in STD_LOGIC;
			  rst : 	in   STD_LOGIC;
			  Clk : in STD_LOGIC;
			  count : out STD_LOGIC_VECTOR(2 downto 0);
			  makeSoundMove : out STD_LOGIC_VECTOR(2 downto 0));
          
end positionCounter;

architecture Behavioral of positionCounter is
	-- # bits in clock divider  
	-- Output frequency = Input frequency / 2^NCLKDIV
	--NCLKDIV=25 with 50 MHz clock gives 50 MHz / 2^25 = 1.49 Hz
--	constant NCLKDIV:	integer := 1;	 
--	constant MAXCLKDIV: integer := 2**NCLKDIV-1;	-- max count of clock divider, 1...11

	-- internal signals
	--signal clkdivcount: 	unsigned(NCLKDIV-1 downto 0);	-- clock divider count value
	signal D : unsigned (2 downto 0) := "000";
	signal soundMove : std_logic_vector(2 downto 0) := "000";
	
	
begin

--Clock signal
--ClockDivider: process( Clk )	
--	begin 
--		if rising_edge(Clk) then 
--			clkdivcount <= clkdivcount+1;	
--		end if;
--	end process ClockDivider; 
	

--3-bit up/down counter
Counter: process(UP, DOWN, rst, D, Clk)
begin
	if rising_edge(Clk) then
		if rst = '1' then
			D <= "000";
         soundMove <= "000";
		else
			if UP='1' and DOWN='0' then
				if D="111" then
					D <= D;
					soundMove <= "001"; --sound signal for getting stuck
				else
					D <= D + 1;
					soundMove <= "101"; --sound signal for moving freely
				end if;
			elsif DOWN='1' and UP='0' then
				if D="000" then
					D <= D;
					soundMove <= "001";	--sound signal for getting stuck
				else
					D <= D - 1;
					soundMove <= "101";	--sound signal for moving freely
				end if;
			else 
				D <= D;
            soundMove <= "000";
			end if;
		end if;
	end if;
end process Counter;
count <= std_logic_vector(D);
makeSoundMove <= soundMove;

end Behavioral;

