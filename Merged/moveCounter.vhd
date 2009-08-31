----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009

-- Create Date:    04:57:53 08/17/2009 
-- Module Name:    moveCounter - Behavioral 
-- Project Name: 	TINZ (This Is Not Zelda)


-- Description: This module keeps track of the number of moves made for a single digit.
-- Counts from 0 to 9 and rolls over from 9 to 0. Sends out signal to increment the next
-- digit when rolling over from 9 to 0. Is instantiated in the Player module. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity moveCounter is
    Port ( Clk : in STD_LOGIC;
			  move : in  STD_LOGIC;
			  reset : in STD_LOGIC;
           onesMove : out  STD_LOGIC_VECTOR (3 downto 0);
			  DOUT : out STD_LOGIC);
end moveCounter;

architecture Behavioral of moveCounter is

	signal DOnes : unsigned(3 downto 0) := "0000";

begin

--4-bit up/down counter
--Represents ones digit
--Only counts to 9, but rolls over
CounterOnes: process(Clk, reset, DOnes, move)
begin
if rising_edge(Clk) then
	if reset='1' then
		DOnes <= "0000";
	else
		if move='1' then
			if DOnes="1001" then
				DOnes <= "0000";
			else
				DOnes <= DOnes + 1;
			end if;
		else 
			DOnes<=DOnes;
		end if;
	end if;
end if;
end process CounterOnes;

onesMove <= std_logic_vector(DOnes);
--Counter rolling over from 9 to 0, need to increment next digit
DOUT <= '1' when (Dones = "1001" and move='1') else '0';



end Behavioral;

