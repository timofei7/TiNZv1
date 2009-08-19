----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    05:33:53 08/12/2009 
-- Design Name: 
-- Module Name:    shiftRegisters - Behavioral 
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


entity shiftRegisters is

Port (	  Clk : in STD_LOGIC;
           dataInReady_tick : in  STD_LOGIC;
			  dataIn : in  STD_LOGIC_VECTOR(7 downto 0);
			  shiftOut : in STD_LOGIC;
           displayDone : in STD_LOGIC;
			  dataShifted8 : out STD_LOGIC;	--ready to get next color byte
			  regFilled : out STD_LOGIC;		--ready to output to LED backpack
           outBit : out  STD_LOGIC);
			  
end shiftRegisters;

architecture Behavioral of shiftRegisters is
	signal loadReg : std_logic := '0';
	signal D : std_logic_vector (7 downto 0) := "00000000"; --data in 8-bit shift register
	signal R : std_logic_vector(15 downto 0) := (others => '0'); --data in 64-byte shift register
																						--change from 511 to 15 for simul purposes
	signal bitShift : std_logic;
	signal shR : std_logic := '0';
	signal shR64 : std_logic := '0';
	signal shiftCount8 : unsigned(3 downto 0) := "0000";
	signal shiftCount64 : unsigned(3 downto 0) := "0000"; --Change from 8 to 3 for simul purposes

begin

loadReg <= '1' when (dataInReady_tick='1' and displayDone='1') else '0';

--8 bit parallel-load, left shift register
ShiftReg8: process (Clk, loadReg)
begin
	if rising_edge(Clk) then
		if loadReg='1' then
			D <= dataIn;
		elsif loadReg='0' and shR='1' then
			D <= D(6 downto 0) & '0';
			bitShift <= D(7);
		else
			D <= D(7 downto 0);
		end if;
	end if;
end process ShiftReg8;


--64-byte right shift register
--shRIn (bit that gets shifted in when right shifting) is bit output from 8-bit shift register
--serial output
ShiftReg64: process (Clk, shR64, shiftOut)
begin
	if rising_edge(Clk) then
		if shR64='1' or shiftOut='1' then
			R <= bitShift & R(15 downto 1); --change from 511 to 15 for simul purposes
			outBit <= R(0);
		else
			R <= R(15 downto 0); 				--change from 511 to 15 for simul purposes
		end if;
	end if;
end process ShiftReg64;

--Count from 0 to 8, send out 8 pulses to shR and 8 pulses to shR64
--Send out dataShifted8 pulse after 8
CountNumShifts8: process (Clk, shiftCount8)
begin
	if rising_edge(Clk) then
		dataShifted8 <= '0';
		shR <= '0';
		shR64 <= '0';
		if loadReg='1' then
			shiftCount8 <= shiftCount8 + 1;
			shR <= '1';
		elsif loadReg='0' and shiftCount8="0000" then
			shiftCount8 <= "0000";		
		elsif shiftCount8 = "1000" then
			shiftCount8 <= "0000";
			shR64 <= '1';
			dataShifted8 <= '1';
		else
			shiftCount8 <= shiftCount8 + 1;
			shR <= '1';
			shR64 <= '1';
		end if;
	else
		shiftCount8 <= shiftCount8;
	end if;
end process CountNumShifts8;

--Counts number of shifts in 64-byte shift register
--Sends out high pulse after 512 shifts and resets to 0
CountNumShifts64: process (Clk, shR64, shiftCount64)
begin
	if rising_edge(Clk) then
		regFilled <= '0';
		if shR64='1' then
			if shiftCount64 = "1111" then	--change to "1111" for simul purposes
				shiftCount64 <= (others=>'0');
				regFilled <= '1';
			else
				shiftCount64 <= shiftCount64 + 1;
			end if;
		else
			shiftCount64 <= shiftCount64;
		end if;
	end if;
end process CountNumShifts64;

end Behavioral;

