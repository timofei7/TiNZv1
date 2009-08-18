--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:53:42 08/10/2009
-- Design Name:   
-- Module Name:   C:/Engs31/Project/PlayerTB.vhd
-- Project Name:  Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Player
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
 
ENTITY PlayerTB IS
END PlayerTB;
 
ARCHITECTURE behavior OF PlayerTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Player
    PORT(
         Clk : IN  std_logic;
         xPlus : IN  std_logic;
         xMinus : IN  std_logic;
         yPlus : IN  std_logic;
         yMinus : IN  std_logic;
         resetPlayer : IN  std_logic;
         --shieldSet : IN  std_logic;
         playerX : OUT  std_logic_vector(2 downto 0);
         playerY : OUT  std_logic_vector(2 downto 0);
			moveCountOnes : out STD_LOGIC_VECTOR(3 downto 0);
			moveCountTens : out STD_LOGIC_VECTOR(3 downto 0);
			moveCountHundreds : out STD_LOGIC_VECTOR(3 downto 0)
         --numMoves : OUT  std_logic_vector(7 downto 0);
         --shieldStatus : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal xPlus : std_logic := '0';
   signal xMinus : std_logic := '0';
   signal yPlus : std_logic := '0';
   signal yMinus : std_logic := '0';
   signal resetPlayer : std_logic := '0';
  -- signal shieldSet : std_logic := '0';

 	--Outputs
   signal playerX : std_logic_vector(2 downto 0);
   signal playerY : std_logic_vector(2 downto 0);
	signal moveCountOnes : STD_LOGIC_VECTOR(3 downto 0);
	signal moveCountTens : STD_LOGIC_VECTOR(3 downto 0) := "1001";
	signal moveCountHundreds : STD_LOGIC_VECTOR(3 downto 0);
  -- signal numMoves : std_logic_vector(7 downto 0);
   --signal shieldStatus : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Player PORT MAP (
          Clk => Clk,
          xPlus => xPlus,
          xMinus => xMinus,
          yPlus => yPlus,
          yMinus => yMinus,
          resetPlayer => resetPlayer,
          --shieldSet => shieldSet,
          playerX => playerX,
          playerY => playerY,
			 moveCountOnes => moveCountOnes,
			 moveCountTens => moveCountTens,
			 moveCountHundreds => moveCountHundreds
          --numMoves => numMoves,
          --shieldStatus => shieldStatus
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
      xPlus <= '1';
		wait for Clk_period*4.25;
		xPlus <= '0';
		wait for Clk_period;
		xMinus <= '1';
		wait for Clk_period*6;
		xMinus <= '0';
		xPlus <= '1';
		wait for Clk_period*2;
		xMinus <= '1';
		wait for Clk_period*2;
		xMinus <= '0';
		wait for Clk_period*9;
		xPlus <= '0';
		yPlus <= '1';
		wait for Clk_period*4.25;
		yPlus <= '0';
	--	shieldSet <= '1';
		wait for Clk_period;
		yMinus <= '1';
		wait for Clk_period*6;
		yMinus <= '0';
		yPlus <= '1';
		wait for Clk_period*2;
		yMinus <= '1';
		wait for Clk_period*2;
		yMinus <= '0';
		wait for Clk_period*9;
		--shieldSet <= '0';
		yPlus <= '0';
		yMinus <= '1'; 
		wait for Clk_period;
		xMinus <= '1';
		wait for Clk_period*2;
		xMinus <= '0';
		yMinus <= '0';
		wait for Clk_period;
		xPlus <= '1';
		yPlus <= '1';
		wait for Clk_period*2;
		yPlus <= '0';
		yMinus <= '1';
		wait for Clk_period*2;
		xPlus <= '0';
		xMinus <= '1';
		yMinus <= '0';
		yPlus <= '1';
		--shieldSet <= '1';
		wait for Clk_period*2;
		yPlus <= '0';
		xMinus <= '0';
		yMinus<='1';
		wait for Clk_period*6;
		
		resetPlayer <= '1';
		wait for Clk_period;
		resetPlayer<= '0';
      wait;
   end process;

END;
