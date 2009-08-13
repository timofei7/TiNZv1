--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:22:56 08/13/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/cellHELP/GameBoard_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GameBoard
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
--use ieee.numeric_std.all; 
 
ENTITY GameBoard_TB IS
END GameBoard_TB;
 
ARCHITECTURE behavior OF GameBoard_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GameBoard
    PORT(
         Clk : IN  std_logic;
         SeqReset : IN  std_logic;
         ResetPUs : IN  std_logic;
         DisablePU : IN  std_logic;
         RowA : IN  std_logic_vector(2 downto 0);
         ColA : IN  std_logic_vector(2 downto 0);
         Color : OUT  std_logic_vector(7 downto 0);
         IsEnabled : OUT  std_logic;
         RowB : IN  std_logic_vector(2 downto 0);
         ColB : IN  std_logic_vector(2 downto 0);
         CollisionData : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal SeqReset : std_logic := '0';
   signal ResetPUs : std_logic := '0';
   signal DisablePU : std_logic := '0';
   signal RowA : std_logic_vector(2 downto 0) := (others => '0');
   signal ColA : std_logic_vector(2 downto 0) := (others => '0');
   signal RowB : std_logic_vector(2 downto 0) := (others => '0');
   signal ColB : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal Color : std_logic_vector(7 downto 0);
   signal IsEnabled : std_logic;
   signal CollisionData : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GameBoard PORT MAP (
          Clk => Clk,
          SeqReset => SeqReset,
          ResetPUs => ResetPUs,
          DisablePU => DisablePU,
          RowA => RowA,
          ColA => ColA,
          Color => Color,
          IsEnabled => IsEnabled,
          RowB => RowB,
          ColB => ColB,
          CollisionData => CollisionData
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

      SeqReset <= '1';
      wait for Clk_period;
      SeqReset <= '0';
      
      for i in 0 to 7 loop
         for j in 0 to 7 loop
            RowA <= std_logic_vector(to_unsigned(i, 3));
            ColA <= std_logic_vector(to_unsigned(j, 3));
            wait for Clk_period*2;
         end loop;
      end loop;
      

      wait;
   end process;

END;
