--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:52:42 08/23/2009
-- Design Name:   
-- Module Name:   C:/Engs31/engs31Project/Merged/NoisesTB.vhd
-- Project Name:  Merged
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Noises
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
 
ENTITY NoisesTB IS
END NoisesTB;
 
ARCHITECTURE behavior OF NoisesTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Noises
    PORT(
         Clk : IN  std_logic;
         soundEN : IN  std_logic;
         soundSelect : IN  std_logic;
         makeSoundLogic : IN  std_logic_vector(2 downto 0);
         makeSoundMove : IN  std_logic_vector(2 downto 0);
         TESTOUT : OUT  std_logic_vector(7 downto 0);
         NoiseOut : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal soundEN : std_logic := '0';
   signal soundSelect : std_logic := '0';
   signal makeSoundLogic : std_logic_vector(2 downto 0) := (others => '0');
   signal makeSoundMove : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal TESTOUT : std_logic_vector(7 downto 0);
   signal NoiseOut : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Noises PORT MAP (
          Clk => Clk,
          soundEN => soundEN,
          soundSelect => soundSelect,
          makeSoundLogic => makeSoundLogic,
          makeSoundMove => makeSoundMove,
          TESTOUT => TESTOUT,
          NoiseOut => NoiseOut
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
      soundEN <= '1';
		soundSelect <= '1';
		makeSoundLogic <= "011";
		makeSoundMove <= "101";
		wait for Clk_period*12;
      wait;
   end process;

END;
