--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:00:14 08/19/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/Merged/cellGame_TB.vhd
-- Project Name:  Merged
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cellGame
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
 
ENTITY cellGame_TB IS
END cellGame_TB;
 
ARCHITECTURE behavior OF cellGame_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cellGame
    PORT(
         Clk : IN  std_logic;
         displayEN : IN  std_logic;
--         resetDisplay : IN  std_logic;
         MOSI : OUT  std_logic;
         SCLK : OUT  std_logic;
         CS : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal displayEN : std_logic := '0';
 --  signal resetDisplay : std_logic := '0';

 	--Outputs
   signal MOSI : std_logic;
   signal SCLK : std_logic;
   signal CS : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cellGame PORT MAP (
          Clk => Clk,
          displayEN => displayEN,
     --     resetDisplay => resetDisplay,
          MOSI => MOSI,
          SCLK => SCLK,
          CS => CS
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

      displayEN <= '1';

      wait;
   end process;

END;
