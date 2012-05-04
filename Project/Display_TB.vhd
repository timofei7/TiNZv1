--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:30:08 08/21/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/Merged/Display_TB.vhd
-- Project Name:  Merged
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Display
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
 
ENTITY Display_TB IS
END Display_TB;
 
ARCHITECTURE behavior OF Display_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Display
    PORT(
         Clk : IN  std_logic;
         displayEN : IN  std_logic;
         shiftToLED : IN  std_logic;
         playerX : IN  std_logic_vector(2 downto 0);
         playerY : IN  std_logic_vector(2 downto 0);
         colorByte : IN  std_logic_vector(7 downto 0);
         introByte : IN  std_logic_vector(7 downto 0);
         deathByte : IN  std_logic_vector(7 downto 0);
         playerColor : IN  std_logic_vector(7 downto 0);
         selectDisplay : IN  std_logic_vector(1 downto 0);
         displayDone : IN  std_logic;
         getRow : OUT  std_logic_vector(2 downto 0);
         getColumn : OUT  std_logic_vector(2 downto 0);
         displayReady : OUT  std_logic;
         displayBit : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal displayEN : std_logic := '0';
   signal shiftToLED : std_logic := '0';
   signal playerX : std_logic_vector(2 downto 0) := (others => '0');
   signal playerY : std_logic_vector(2 downto 0) := (others => '0');
   signal colorByte : std_logic_vector(7 downto 0) := "11100000";
   signal introByte : std_logic_vector(7 downto 0) := (others => '0');
   signal deathByte : std_logic_vector(7 downto 0) := (others => '0');
   signal playerColor : std_logic_vector(7 downto 0) := (others => '0');
   signal selectDisplay : std_logic_vector(1 downto 0) := (others => '0');
   signal displayDone : std_logic := '0';

 	--Outputs
   signal getRow : std_logic_vector(2 downto 0);
   signal getColumn : std_logic_vector(2 downto 0);
   signal displayReady : std_logic;
   signal displayBit : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 1us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Display PORT MAP (
          Clk => Clk,
          displayEN => displayEN,
          shiftToLED => shiftToLED,
          playerX => playerX,
          playerY => playerY,
          colorByte => colorByte,
          introByte => introByte,
          deathByte => deathByte,
          playerColor => playerColor,
          selectDisplay => selectDisplay,
          displayDone => displayDone,
          getRow => getRow,
          getColumn => getColumn,
          displayReady => displayReady,
          displayBit => displayBit
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

   displayEN <= '1';


      wait;
   end process;

END;
