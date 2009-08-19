--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:31:43 08/12/2009
-- Design Name:   
-- Module Name:   C:/Engs31/Project/shiftRegistersTB.vhd
-- Project Name:  Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shiftRegisters
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY shiftRegistersTB IS
END shiftRegistersTB;
 
ARCHITECTURE behavior OF shiftRegistersTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shiftRegisters
    PORT(
         Clk : IN  std_logic;
         dataInReady_tick : IN  std_logic;
         dataIn : IN  std_logic_vector(7 downto 0);
			shiftOut : IN std_logic;
         dataShifted8 : OUT  std_logic;
         regFilled : OUT  std_logic;
         outBit : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal dataInReady_tick : std_logic := '0';
   signal dataIn : std_logic_vector(7 downto 0) := (others => '0');
	signal shiftOut : std_logic := '0';

 	--Outputs
   signal dataShifted8 : std_logic;
   signal regFilled : std_logic;
   signal outBit : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shiftRegisters PORT MAP (
          Clk => Clk,
          dataInReady_tick => dataInReady_tick,
          dataIn => dataIn,
			 shiftOut => shiftOut,
          dataShifted8 => dataShifted8,
          regFilled => regFilled,
          outBit => outBit
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for Clk_period*4.25;
		dataIn <= "10101010";
		wait for Clk_period;
		dataInReady_tick <= '1';
		wait for Clk_period;
		dataInReady_tick <= '0';
		wait for Clk_period*12;
		dataIn <= "10010011";
		wait for Clk_period;
		dataInReady_tick <= '1';
		wait for Clk_period;
		dataInReady_tick <= '0';
      wait for Clk_period*12;
		shiftOut <= '1';
		wait for Clk_period;
		shiftOut <= '0';
		wait;
   end process;

END;
