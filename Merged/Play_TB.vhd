--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:29:03 08/19/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/Merged/PlayerInput_TB.vhd
-- Project Name:  Merged
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PlayerInput
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
 
ENTITY Play_TB IS
END Play_TB;
 
ARCHITECTURE behavior OF Play_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Play
    PORT(
         Clk : IN  std_logic;
         Xin : IN  std_logic;
         Yin : IN  std_logic;
         XAnalogIn : IN  std_logic;
         YAnalogIn : IN  std_logic;
         XAnalogOut : OUT  std_logic;
         YAnalogOut : OUT  std_logic;
         resetPlayer : IN  std_logic;
         playerX : OUT  std_logic_vector(2 downto 0);
         playerY : OUT  std_logic_vector(2 downto 0);
         moveCountOnes : OUT  std_logic_vector(3 downto 0);
         moveCountTens : OUT  std_logic_vector(3 downto 0);
         moveCountHundreds : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Xin : std_logic := '0';
   signal Yin : std_logic := '0';
   signal XAnalogIn : std_logic := '0';
   signal YAnalogIn : std_logic := '0';
   signal resetPlayer : std_logic := '0';

 	--Outputs
   signal XAnalogOut : std_logic;
   signal YAnalogOut : std_logic;
   signal playerX : std_logic_vector(2 downto 0);
   signal playerY : std_logic_vector(2 downto 0);
   signal moveCountOnes : std_logic_vector(3 downto 0);
   signal moveCountTens : std_logic_vector(3 downto 0);
   signal moveCountHundreds : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 1us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Play PORT MAP (
          Clk => Clk,
          Xin => Xin,
          Yin => Yin,
          XAnalogIn => XAnalogIn,
          YAnalogIn => YAnalogIn,
          XAnalogOut => XAnalogOut,
          YAnalogOut => YAnalogOut,
          resetPlayer => resetPlayer,
          playerX => playerX,
          playerY => playerY,
          moveCountOnes => moveCountOnes,
          moveCountTens => moveCountTens,
          moveCountHundreds => moveCountHundreds
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
   stim_procX: process
   begin		
   
      Xin <= '0';  --50% duty cycle
      wait for 5ms;
      Xin <= '1';
      wait for 5ms;
      Xin <= '0';
      wait for 5ms;
      Xin <= '1';
      wait for 5ms;
      Xin <= '0';
      wait for 5ms;
      Xin <= '1';
      wait for 5ms;
      Xin <= '0';
      wait for 5ms;
      Xin <= '1';
      wait for 5ms;
      
      Xin <= '0';  --move X down
      wait for 2ms;
      Xin <= '1';
      wait for 8ms;
      Xin <= '0';
      wait for 2ms;
      Xin <= '1';
      wait for 8ms;
      Xin <= '0';
      wait for 2ms;
      Xin <= '1';
      wait for 8ms;
      Xin <= '0';
      wait for 2ms;
      Xin <= '1';
      wait for 8ms;

      wait;
   end process;
   
      -- Stimulus process
   stim_procY: process
   begin		
   
      Yin <= '0';  --move Y
      wait for 8ms;
      Yin <= '1';
      wait for 2ms;
      Yin <= '0';
      wait for 8ms;
      Yin <= '1';
      wait for 2ms;
      Yin <= '0';
      wait for 8ms;
      Yin <= '1';
      wait for 2ms;
      Yin <= '0';
      wait for 8ms;
      Yin <= '1';
      wait for 2ms;
      
      Yin <= '0';  --50%duty
      wait for 5ms;
      Yin <= '1';
      wait for 5ms;
      Yin <= '0';
      wait for 5ms;
      Yin <= '1';
      wait for 5ms;
      Yin <= '0';
      wait for 5ms;
      Yin <= '1';
      wait for 5ms;
      Yin <= '0';
      wait for 5ms;
      Yin <= '1';
      wait for 5ms;
      

      wait;
   end process;

END;
