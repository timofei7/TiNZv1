--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:39:38 08/22/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/Merged/Noise_TB.vhd
-- Project Name:  Merged
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Noise
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
 
ENTITY Noise_TB IS
END Noise_TB;
 
ARCHITECTURE behavior OF Noise_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Noise
    PORT(
         Clk : IN  std_logic;
         NoiseON : IN  std_logic;
         SIGOUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal NoiseON : std_logic := '0';

 	--Outputs
   signal SIGOUT : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Noise PORT MAP (
          Clk => Clk,
          NoiseON => NoiseON,
          SIGOUT => SIGOUT
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
      
      NoiseON <= '0';
      wait for clk_period*5;
      NoiseON <= '1';

      wait;
   end process;

END;
