--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:02:37 08/18/2009
-- Design Name:   
-- Module Name:   C:/Engs31/Project/MainControllerTB.vhd
-- Project Name:  Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MainController
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
 
ENTITY MainControllerTB IS
END MainControllerTB;
 
ARCHITECTURE behavior OF MainControllerTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MainController
    PORT(
         Clk : IN  std_logic;
         introDone : IN  std_logic;
         death : IN  std_logic;
         deathDone : IN  std_logic;
         WIN : IN std_logic;
         seqReset : OUT  std_logic;
         TESTOUT: OUT  std_logic_vector(7 downto 0);
         displaySelector : OUT  std_logic_vector(1 downto 0);
         sevenSegEN : OUT  std_logic;
         resetGameT : OUT  std_logic;
         resetPlayer : OUT  std_logic;
         moveEN : OUT std_logic;
         displayEN : OUT  std_logic;
         gameLogicEN : OUT  std_logic;
         soundEN : OUT std_logic;
         sevenSegSelector : OUT  std_logic
        );
   
    

   --Inputs
   signal Clk : std_logic := '0';
   signal introDone : std_logic := '0';
   signal death : std_logic := '0';
   signal deathDone : std_logic := '0';
   signal WIN : std_logic := '0';

 	--Outputs
   signal seqReset : std_logic;
   signal TESTOUT : std_logic_vector(7 downto 0);
   signal moveEN : std_logic;
   signal displaySelector : std_logic_vector(1 downto 0);
   signal sevenSegEN : std_logic;
   signal resetGameT : std_logic;
   signal resetPlayer : std_logic;
   signal soundEN : std_logic;
   signal displayEN : std_logic;
   signal gameLogicEN : std_logic;
   signal sevenSegSelector : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MainController PORT MAP (
          Clk => Clk,
          introDone => introDone,
          death => death,
          deathDone => deathDone,
          seqReset => seqReset,
          moveEN => moveEN,
          displaySelector => displaySelector,
          sevenSegEN => sevenSegEN,
          resetGameT => resetGameT,
          resetPlayer => resetPlayer,
          soundEN => soundEN,
          displayEN => displayEN,
          gameLogicEN => gameLogicEN,
          sevenSegSelector => sevenSegSelector
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
      wait for Clk_period*4.25;
		introDone <= '1';
		wait for Clk_period;
		introDone <= '0';
		wait for Clk_period*10;
		death <= '1';
		wait for Clk_period;
		death <= '0';
		wait for Clk_period*5;
		deathDone <= '1';
		wait for Clk_period;
		deathDone <= '0';
      wait;
   end process;

END;
