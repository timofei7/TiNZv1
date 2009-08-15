--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:56:56 08/14/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/cellHELP/PlayerColor_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PlayerColor
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
 
ENTITY PlayerColor_TB IS
END PlayerColor_TB;
 
ARCHITECTURE behavior OF PlayerColor_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PlayerColor
    PORT(
         Clk : IN  std_logic;
         Selector : IN  std_logic_vector(1 downto 0);
         PlayerColor : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Selector : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal PlayerColore : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PlayerColor PORT MAP (
          Clk => Clk,
          Selector => Selector,
          PlayerColor => PlayerColore
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

      Selector <= "00";
      wait for Clk_period*2;
      Selector <= "01";
      wait for Clk_period*2;
      Selector <= "10";
      wait for Clk_period*2;
      Selector <= "11";
      wait for Clk_period*2;

      wait;
   end process;

END;
