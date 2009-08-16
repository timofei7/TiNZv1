--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:17:24 08/15/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/cellHELP/LEDDriver_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: LEDDriver
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
 
ENTITY LEDDriver_TB IS
END LEDDriver_TB;
 
ARCHITECTURE behavior OF LEDDriver_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LEDDriver
    PORT(
         Clk : IN  std_logic;
         Data: IN std_logic;
         GoDisplay : IN  std_logic;
         MISO : IN  std_logic;
         MOSI : OUT  std_logic;
         SCLK : OUT  std_logic;
         CS : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Data: std_logic := '0';
   signal GoDisplay : std_logic := '0';
   signal MISO : std_logic := '0';

 	--Outputs
   signal MOSI : std_logic;
   signal SCLK : std_logic;
   signal CS : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
   constant SCLK_period : time := 0.5ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: LEDDriver PORT MAP (
          Clk => Clk,
          Data => Data,
          GoDisplay => GoDisplay,
          MISO => MISO,
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
 
   SCLK_process :process
   begin
		SCLK <= '0';
		wait for SCLK_period/2;
		SCLK <= '1';
		wait for SCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		

      wait for Clk_period*2.25;
      GoDisplay <= '1';
      --wait for Clk_period;
      --GoDisplay <= '0';


      wait;
   end process;

END;
