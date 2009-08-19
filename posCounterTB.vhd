--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:39:46 08/09/2009
-- Design Name:   
-- Module Name:   C:/Engs31/Project/posCounterTB.vhd
-- Project Name:  Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: positionCounter
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
 
ENTITY posCounterTB IS
END posCounterTB;
 
ARCHITECTURE behavior OF posCounterTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT positionCounter
    PORT(
         UP : IN  std_logic;
         DOWN : IN  std_logic;
         rst : IN  std_logic;
         Clk : IN  std_logic;
         count : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal UP : std_logic := '0';
   signal DOWN : std_logic := '0';
   signal rst : std_logic := '0';
   signal Clk : std_logic := '0';

 	--Outputs
   signal count : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: positionCounter PORT MAP (
          UP => UP,
          DOWN => DOWN,
          rst => rst,
          Clk => Clk,
          count => count
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
      UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		 UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		 UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		DOWN <= '1';
		wait for Clk_period;
		DOWN <= '0';
		wait for Clk_period;
		DOWN <= '1';
		wait for Clk_period;
		DOWN <= '0';
		wait for Clk_period;
		DOWN <= '1';
		wait for Clk_period;
		DOWN <= '0';
		wait for Clk_period;
		DOWN <= '1';
		wait for Clk_period;
		DOWN <= '0';
		wait for Clk_period;
		DOWN <= '1';
		wait for Clk_period;
		DOWN <= '0';
		wait for Clk_period;
		UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		 UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		 UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		 UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		 UP <= '1';
		 DOWN <= '1';
		 wait for Clk_period;
		 DOWN <= '0';
		 wait for Clk_period;
		 UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		 UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		 UP <= '1';
      wait for Clk_period;	
		UP <= '0';
      wait for Clk_period;
		rst <= '1';
		wait for Clk_period;


      wait;
   end process;

END;
