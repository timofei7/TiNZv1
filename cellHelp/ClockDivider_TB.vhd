--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:11:01 08/12/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/cellHELP/ClockDivider_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ClockDivider
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
 
ENTITY ClockDivider_TB IS
END ClockDivider_TB;
 
ARCHITECTURE behavior OF ClockDivider_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ClockDivider
    PORT(
         Div : IN  std_logic_vector(7 downto 0);
         Clk : IN  std_logic;
         slowCE : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Div : std_logic_vector(7 downto 0) := (others => '0');
   signal Clk : std_logic := '0';

 	--Outputs
   signal slowCE : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ClockDivider PORT MAP (
          Div => Div,
          Clk => Clk,
          slowCE => slowCE
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

      wait for Clk_period*2.25;

      Div <= "00000010";

      wait;
   end process;

END;
