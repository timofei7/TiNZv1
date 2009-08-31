----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009

-- Create Date:    05:33:53 08/12/2009 
-- Module Name:    shiftRegisters - Behavioral 
-- Project Name: 	 TINZ (This Is Not Zelda)


-- Description: This code models a 64-byte right shift register that can also do
-- 8-bit parallel load. Receives signals from Display to load 8-bits and to shift out
-- lsb. Also keeps track of number of bits loaded into register and outputs to Display
-- when the register is full.

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shiftRegisters is

Port (	  Clk : in STD_LOGIC;
           dataInReady_tick : in  STD_LOGIC;	--from Display
			  dataIn : in  STD_LOGIC_VECTOR(7 downto 0);	--from Display
			  shiftOut : in STD_LOGIC;	--from LED driver through Display
           reset : in STD_LOGIC;		--from MainController through Display
			  regFilled : out STD_LOGIC;	--to LED driver through Display
           outBit : out  STD_LOGIC);	--	to LED driver through Display
			  
end shiftRegisters;

architecture Behavioral of shiftRegisters is
	signal loadReg : std_logic := '0';
	signal R : std_logic_vector(511 downto 0) := (others => '0'); --data in 64-byte shift register
																							
	signal shiftCount64 : unsigned(6 downto 0) := "0000000"; 

begin

loadReg <= '1' when dataInReady_tick='1' else '0';

--64-byte right shift register
--Allows for parallel load of 8 bits at a time given loadReg signal
--Shifts out least significant bit when given shiftOut signal
--shiftCount64 counts number of bits shifted in
ShiftReg64: process (Clk, shiftCount64, loadReg, shiftOut, reset)
begin
	if rising_edge(Clk) then
		--Clear register
		if reset='1' then
			R <= (others => '0');
         shiftCount64 <= (others => '0');
		else
			--Parallel load 8 bits
         if loadReg='1' then
            R <= dataIn(0) & dataIn(1) & dataIn(2) & dataIn(3) & dataIn(4) & dataIn(5) & dataIn(6) & dataIn(7) & R(511 downto 8);
            shiftCount64 <= shiftCount64 + 1;
			--Reset counter after register is filled
         elsif shiftCount64="1000000" then
            shiftCount64 <= (others => '0');
			--Shift out lsb
			elsif shiftOut='1' then
				R <= '0' & R(511 downto 1); --change from 511 to 15 for simul purposes
				outBit <= R(0);
            shiftCount64 <= shiftCount64;
			else
				R <= R; 				
            shiftCount64 <= shiftCount64;
			end if;
		end if;
	end if;
end process ShiftReg64;
--Indicate register is filled when shiftCount64 reaches specified count of 64
regFilled <= '1' when shiftCount64="1000000" else '0';


end Behavioral;

