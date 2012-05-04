--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:06:37 08/18/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/cellHELP/ACCELDecoder_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ACCELDecoder
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
 
ENTITY ACCELDecoder_TB IS
END ACCELDecoder_TB;
 
ARCHITECTURE behavior OF ACCELDecoder_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ACCELDecoder
    PORT(
         Xin : IN  std_logic;
         Yin : IN  std_logic;
         Clk : IN  std_logic;
         Xout : OUT  std_logic_vector(7 downto 0);
         Yout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Xin : std_logic := '0';
   signal Yin : std_logic := '0';
   signal Clk : std_logic := '0';

 	--Outputs
   signal Xout : std_logic_vector(7 downto 0);
   signal Yout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ACCELDecoder PORT MAP (
          Xin => Xin,
          Yin => Yin,
          Clk => Clk,
          Xout => Xout,
          Yout => Yout
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
   stim_procX: process
   begin		
   
      Xin <= '0';
      wait for 5ms;
      Xin <= '1';
      wait for 5ms;
      Xin <= '0';
      wait for 5ms;
      Xin <= '1';
      wait for 5ms;
      Xin <= '0';
      wait for 5ms;
      Xin <= '1';
      wait for 5ms;
      Xin <= '0';
      wait for 5ms;
      Xin <= '1';
      wait for 5ms;

      wait;
   end process;
   
      -- Stimulus process
   stim_procY: process
   begin		
   
      Yin <= '0';
      wait for 7ms;
      Yin <= '1';
      wait for 3ms;
      Yin <= '0';
      wait for 7ms;
      Yin <= '1';
      wait for 3ms;
      Yin <= '0';
      wait for 7ms;
      Yin <= '1';
      wait for 3ms;
      Yin <= '0';
      wait for 7ms;
      Yin <= '1';
      wait for 3ms;

      wait;
   end process;

END;
