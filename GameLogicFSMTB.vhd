--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:09:02 08/11/2009
-- Design Name:   
-- Module Name:   C:/Engs31/Project/GameLogicFSMTB.vhd
-- Project Name:  Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GameLogicFSM
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
 
ENTITY GameLogicFSMTB IS
END GameLogicFSMTB;
 
ARCHITECTURE behavior OF GameLogicFSMTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GameLogicFSM
    PORT(
         Clk : IN  std_logic;
         collisionData : IN  std_logic_vector(1 downto 0);
         shieldStatus : IN  std_logic;
         logicEN : IN  std_logic;
         gameOver : IN  std_logic;
         isEN : IN  std_logic;
         disablePU : OUT  std_logic;
         death : OUT  std_logic;
         shieldSet : OUT  std_logic;
         playerColor : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal collisionData : std_logic_vector(1 downto 0) := (others => '0');
   signal shieldStatus : std_logic := '0';
   signal logicEN : std_logic := '0';
   signal gameOver : std_logic := '0';
   signal isEN : std_logic := '0';

 	--Outputs
   signal disablePU : std_logic;
   signal death : std_logic;
   signal shieldSet : std_logic;
   signal playerColor : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GameLogicFSM PORT MAP (
          Clk => Clk,
          collisionData => collisionData,
          shieldStatus => shieldStatus,
          logicEN => logicEN,
          gameOver => gameOver,
          isEN => isEN,
          disablePU => disablePU,
          death => death,
          shieldSet => shieldSet,
          playerColor => playerColor
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
      logicEN <= '1';
		isEN <= '1';
		wait for Clk_period*2.25;
		collisionData <= "00";
		wait for Clk_period*2;
		collisionData <= "11";
		wait for Clk_period*2;
		collisionData <= "00";
		wait for Clk_period;
		isEN <= '0';
		wait for Clk_period;
		collisionData <= "11";
		wait for Clk_period*2;
		isEN <='1';
		collisionData <= "00";
		wait for Clk_period*3;
		collisionData <= "10";
		wait for Clk_period*4;
		collisionData <= "00";
		wait for Clk_period*6;
		collisionData <= "11";
		wait for Clk_period*2;
		collisionData <= "00";
		wait for Clk_period*5;
		collisionData <= "11";
		wait for Clk_period*2;
		collisionData <= "00";
		wait for Clk_period*2;
		collisionData <= "10";
		wait for Clk_period*2;
		collisionData <="00";
		logicEN <= '0';
		wait for Clk_period*4;
		collisionData <= "11";
		wait for Clk_period;
		logicEN <= '1';
		wait for Clk_period*3;
		gameOver <= '1';
      wait;
   end process;

END;
