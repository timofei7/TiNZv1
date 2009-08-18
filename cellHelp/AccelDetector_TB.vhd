--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:55:04 08/18/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/cellHELP/AccelDetector_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AccelDetector
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
 
ENTITY AccelDetector_TB IS
END AccelDetector_TB;
 
ARCHITECTURE behavior OF AccelDetector_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AccelDetector
    PORT(
         Clk : IN  std_logic;
         SigIn : IN  std_logic;
         T1out : OUT  std_logic_vector(7 downto 0);
         T2out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal SigIn : std_logic := '0';

 	--Outputs
   signal T1out : std_logic_vector(7 downto 0);
   signal T2out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AccelDetector PORT MAP (
          Clk => Clk,
          SigIn => SigIn,
          T1out => T1out,
          T2out => T2out
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
      
      SigIn <= '0';
      
      wait for 5ms;
      
      SigIn <= '1';
      wait for 5ms;
      SigIn <= '0';
      wait for 5ms;
      
      SigIn <= '1';
      wait for 5ms;
      SigIn <= '0';
      wait for 5ms;
      
      SigIn <= '1';
      wait for 10ms;
      SigIn <= '0';
      wait for 10ms;
            
      SigIn <= '1';
      wait for 7ms;
      SigIn <= '0';
      wait for 7ms;
      
      

      wait;
   end process;

END;
