--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:27:51 08/17/2009
-- Design Name:   
-- Module Name:   C:/Engs31/Project/moveCounterTB.vhd
-- Project Name:  Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: moveCounter
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
 
ENTITY moveCounterTB IS
END moveCounterTB;
 
ARCHITECTURE behavior OF moveCounterTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT moveCounter
    PORT(
         Clk : IN  std_logic;
         move : IN  std_logic;
         reset : IN  std_logic;
         onesMove : OUT  std_logic_vector(3 downto 0);
         DOUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal move : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal onesMove : std_logic_vector(3 downto 0);
   signal DOUT : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: moveCounter PORT MAP (
          Clk => Clk,
          move => move,
          reset => reset,
          onesMove => onesMove,
          DOUT => DOUT
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
      move<='1';
		wait for Clk_period*11.25;
		reset <= '1';
		wait for Clk_period;
		reset <= '0';
		wait;
   end process;

END;
