--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:23:33 08/10/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/cellHELP/AttrLookup_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AttrLookup
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
 
ENTITY AttrLookup_TB IS
END AttrLookup_TB;
 
ARCHITECTURE behavior OF AttrLookup_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AttrLookup
    PORT(
         Clk : IN  std_logic;
         Ident : IN  std_logic_vector(5 downto 0);
         rstPU : IN  std_logic;
         disablePU : IN  std_logic;
         isEN : OUT  std_logic;
         color : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Ident : std_logic_vector(5 downto 0) := (others => '0');
   signal rstPU : std_logic := '0';
   signal disablePU : std_logic := '0';

 	--Outputs
   signal isEN : std_logic;
   signal color : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AttrLookup PORT MAP (
          Clk => Clk,
          Ident => Ident,
          rstPU => rstPU,
          disablePU => disablePU,
          isEN => isEN,
          color => color
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

      wait for Clk_period*2.25; --reset/set
      rstPU <= '1';
      wait for Clk_period;
      rstPU <= '0';
      
      wait for Clk_period;
      Ident <= "000001";
      
      wait for Clk_period*2;
      
      Ident <= "000010";
      wait for Clk_period*2;
      Ident <= "001010";
      

      wait;
   end process;

END;
