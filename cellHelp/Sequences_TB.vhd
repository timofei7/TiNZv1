--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:16:16 08/10/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/cellHELP/Sequences_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Sequences
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
 
ENTITY Sequences_TB IS
END Sequences_TB;
 
ARCHITECTURE behavior OF Sequences_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Sequences
    PORT(
         Clk : IN  std_logic;
         rowcol : IN  std_logic_vector(5 downto 0);
         seqReset : IN  std_logic;
         seqDone : OUT  std_logic;
         deathColor : OUT  std_logic_vector(7 downto 0);
         introColor : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal rowcol : std_logic_vector(5 downto 0) := (others => '0');
   signal seqReset : std_logic := '0';

 	--Outputs
   signal seqDone : std_logic;
   signal deathColor : std_logic_vector(7 downto 0);
   signal introColor : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Sequences PORT MAP (
          Clk => Clk,
          rowcol => rowcol,
          seqReset => seqReset,
          seqDone => seqDone,
          deathColor => deathColor,
          introColor => introColor
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

      seqReset <= '1';
      
      wait for Clk_period;
      
      seqReset <= '0';
      
      rowcol <= "000000";
      
      wait for Clk_period;
      
      rowcol <= "001001";
      
      wait for Clk_period;
      
      rowcol <= "111111";

      wait;
   end process;

END;
