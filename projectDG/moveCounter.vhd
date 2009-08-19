----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:57:53 08/17/2009 
-- Design Name: 
-- Module Name:    moveCounter - Behavioral 
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
--Ones counter rolling over from 9 to 0, need to increment tens counter
DOUT <= '1' when (Dones = "1001" and move='1') else '0';



end Behavioral;

