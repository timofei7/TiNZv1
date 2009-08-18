--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:34:39 08/16/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/cellHELP/ACEELDecoder2_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ACCELDecoderSimple
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
 
ENTITY ACEELDecoder2_TB IS
END ACEELDecoder2_TB;
 
ARCHITECTURE behavior OF ACEELDecoder2_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ACCELDecoderSimple
    PORT(
         Xin : IN  std_logic;
         Yin : IN  std_logic;
         Clk : IN  std_logic;
         --Xout : OUT  std_logic_vector(7 downto 0);
         --Yout : OUT  std_logic_vector(7 downto 0);
         T2Out : OUT  std_logic_vector(7 downto 0)
         --T1yOut : OUT  std_logic_vector(7 downto 0);
         --T1xOut : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Xin : std_logic := '0';
   signal Yin : std_logic := '0';
   signal Clk : std_logic := '0';

 	--Outputs
   --signal Xout : std_logic_vector(7 downto 0);
   --signal Yout : std_logic_vector(7 downto 0);
   signal T2Out : std_logic_vector(7 downto 0);
   --signal T1yOut : std_logic_vector(7 downto 0);
   --signal T1xOut : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 1us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ACCELDecoderSimple PORT MAP (
          Xin => Xin,
          Yin => Yin,
          Clk => Clk,
          --Xout => Xout,
          --Yout => Yout,
          T2Out => T2Out
          --T1yOut => T1yOut,
          --T1xOut => T1xOut
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
      wait for 2.25us;
      
      Yin <= '1';
      wait for 2us;
      
      Xin <= '1';
      wait for 3us;
      
      Xin <= '0';
      wait for 2us;
      
      Yin <= '0';
      
      wait for 2.25us;
      
      Yin <= '1';
      wait for 2us;
      
      Xin <= '1';
      wait for 3us;
      
      Xin <= '0';
      wait for 2us;
      
      Yin <= '0';
      
      wait for 2.25us;
      
      Yin <= '1';
      wait for 2us;
      
      Xin <= '1';
      wait for 3us;
      
      Xin <= '0';
      wait for 2us;
      
      Yin <= '0';
      
      wait for 2.25us;
      
      Yin <= '1';
      wait for 2us;
      
      Xin <= '1';
      wait for 3us;
      
      Xin <= '0';
      wait for 2us;
      
      Yin <= '0';
      

      wait;
   end process;

END;
