--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:45:03 08/13/2009
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
         WriteAddr : IN  std_logic_vector(3 downto 0);
         ReadAAddr : IN  std_logic_vector(3 downto 0);
         ReadBAddr : IN  std_logic_vector(3 downto 0);
         RstPU : IN  std_logic;
         DisablePU : IN  std_logic;
         DataA : OUT  std_logic_vector(8 downto 0);
         DataB : OUT  std_logic_vector(8 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal WriteAddr : std_logic_vector(3 downto 0) := (others => '0');
   signal ReadAAddr : std_logic_vector(3 downto 0) := (others => '0');
   signal ReadBAddr : std_logic_vector(3 downto 0) := (others => '0');
   signal RstPU : std_logic := '0';
   signal DisablePU : std_logic := '0';

 	--Outputs
   signal DataA : std_logic_vector(8 downto 0);
   signal DataB : std_logic_vector(8 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AttrLookup PORT MAP (
          Clk => Clk,
          WriteAddr => WriteAddr,
          ReadAAddr => ReadAAddr,
          ReadBAddr => ReadBAddr,
          RstPU => RstPU,
          DisablePU => DisablePU,
          DataA => DataA,
          DataB => DataB
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
      
      ReadAAddr <= "0010";

      -- insert stimulus here 

      wait;
   end process;

END;
