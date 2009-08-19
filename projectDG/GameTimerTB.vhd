--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:52:37 08/17/2009
-- Design Name:   
-- Module Name:   C:/Engs31/Project/GameTimerTB.vhd
-- Project Name:  Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GameTimer
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
 
ENTITY GameTimerTB IS
END GameTimerTB;
 
ARCHITECTURE behavior OF GameTimerTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GameTimer
    PORT(
         Clk : IN  std_logic;
         resetGameT : IN  std_logic;
         sevenSegEN : IN  std_logic;
         numMovesOnes : in  std_logic_vector(3 downto 0);
			numMovesTens : in  std_logic_vector(3 downto 0);
			numMovesHundreds: in  std_logic_vector(3 downto 0);
         sevenSegSelector : IN  std_logic;
         gameOver : OUT  std_logic;
         an : OUT  std_logic_vector(3 downto 0);
         segDisplay : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal resetGameT : std_logic := '0';
   signal sevenSegEN : std_logic := '0';
   signal sevenSegSelector : std_logic := '0';
	signal numMovesOnes : std_logic_vector(3 downto 0) := "1001";
	signal numMovesTens : std_logic_vector(3 downto 0) := "0010";
	signal numMovesHundreds: std_logic_vector(3 downto 0) := "0001";

 	--Outputs
   signal gameOver : std_logic;
   signal an : std_logic_vector(3 downto 0);
   signal segDisplay : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GameTimer PORT MAP (
          Clk => Clk,
          resetGameT => resetGameT,
          sevenSegEN => sevenSegEN,
          numMovesOnes => numMovesOnes,
			 numMovesTens => numMovesTens,
			 numMovesHundreds => numMovesHundreds,
          sevenSegSelector => sevenSegSelector,
          gameOver => gameOver,
          an => an,
          segDisplay => segDisplay
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
      sevenSegEN <= '1';
		sevenSegSelector <= '0';
		wait for Clk_period*10.25;
		resetGameT <= '1';
		wait for Clk_period*4;
		resetGameT <= '0';
		wait for Clk_period*100;
		sevenSegEn <= '0';
		wait for Clk_period*5;
		sevenSegEn <= '1';
		wait for Clk_period;
		sevenSegSelector <= '1';
		wait;
   end process;

END;
