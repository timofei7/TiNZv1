--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:40:50 08/18/2009
-- Design Name:   
-- Module Name:   C:/DigitalDesigns/dt/TresHysteresis_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ThresHysteresis
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
 
ENTITY TresHysteresis_TB IS
END TresHysteresis_TB;
 
ARCHITECTURE behavior OF TresHysteresis_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ThresHysteresis
    PORT(
         Clk : IN  std_logic;
         SIN : IN  std_logic_vector(7 downto 0);
         UP : OUT  std_logic;
         DOWN : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal SIN : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal UP : std_logic;
   signal DOWN : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ThresHysteresis PORT MAP (
          Clk => Clk,
          SIN => SIN,
          UP => UP,
          DOWN => DOWN
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
		
		wait for clk_period*2.25;
		
		SIN <= "10000000";
		
		wait for clk_period*5;
		
		SIN <= "01000011";

	
      wait;
   end process;

END;
