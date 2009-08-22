--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:49:12 08/14/2009
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
         ReadENColor : IN  std_logic;
         RowA : IN  std_logic_vector(2 downto 0);
         ColA : IN  std_logic_vector(2 downto 0);
         ColorOUT : OUT  std_logic_vector(7 downto 0);
         ColorDONE : OUT  std_logic;
         --ReadENCollision : IN  std_logic;
         RowB : IN  std_logic_vector(2 downto 0);
         ColB : IN  std_logic_vector(2 downto 0);
         CollisionData : OUT  std_logic_vector(1 downto 0)
         --CollisionDone : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal SeqReset : std_logic := '0';
   signal ResetPUs : std_logic := '0';
   signal DisablePU : std_logic := '0';
   signal ReadENColor : std_logic := '0';
   signal RowA : std_logic_vector(2 downto 0) := (others => '0');
   signal ColA : std_logic_vector(2 downto 0) := (others => '0');
   --signal ReadENCollision : std_logic := '0';
   signal RowB : std_logic_vector(2 downto 0) := (others => '0');
   signal ColB : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal ColorOUT : std_logic_vector(7 downto 0);
   signal ColorDONE : std_logic;
   signal CollisionData : std_logic_vector(1 downto 0);
   --signal CollisionDone : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GameBoard PORT MAP (
          Clk => Clk,
          SeqReset => SeqReset,
          ResetPUs => ResetPUs,
          DisablePU => DisablePU,
          ReadENColor => ReadENColor,
          RowA => RowA,
          ColA => ColA,
          ColorOUT => ColorOUT,
          ColorDONE => ColorDONE,
          --ReadENCollision => ReadENCollision,
          RowB => RowB,
          ColB => ColB,
          CollisionData => CollisionData
          --CollisionDone => CollisionDone
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
            ReadENColor <='1';
            wait for Clk_period;
            ReadENColor <='0';
            Wait for Clk_period*2;
         end loop;
      end loop;
      

      wait;
   end process;
   
--   stim2:
--   process
--      begin
--      wait for Clk_period*3.25;
--         for i in 0 to 7 loop
--            for j in 0 to 7 loop
--               RowB <= std_logic_vector(to_unsigned(i, 3));
--               ColB <= std_logic_vector(to_unsigned(j, 3));
--               --ReadENCollision <='1';
--               --wait for Clk_period;
--               --ReadENCollision <='0';
--               Wait for Clk_period*2;
--            end loop;
--         end loop;
--   end process stim2;

END;
