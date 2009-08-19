--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:27:18 08/16/2009
-- Design Name:   
-- Module Name:   C:/Engs31/Project/DisplayTB.vhd
-- Project Name:  Project
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
 
ENTITY DisplayTB IS
END DisplayTB;
 
ARCHITECTURE behavior OF DisplayTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Display
    PORT(
         Clk : IN  std_logic;
         displayEN : IN  std_logic;
         resetDisplay : IN  std_logic;
         playerX : IN  unsigned(2 downto 0);
         playerY : IN  unsigned(2 downto 0);
         colorByte : IN  std_logic_vector(7 downto 0);
         introByte : IN  std_logic_vector(7 downto 0);
         deathByte : IN  std_logic_vector(7 downto 0);
         playerColor : IN  std_logic_vector(7 downto 0);
         selectDisplay : IN  std_logic_vector(1 downto 0);
         colorReady : IN  std_logic;
         getRow : OUT  unsigned(2 downto 0);
         getColumn : OUT  unsigned(2 downto 0);
         getColor : OUT  std_logic;
         displayReady : OUT  std_logic;
         displayBit : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal displayEN : std_logic := '0';
   signal resetDisplay : std_logic := '0';
   signal playerX : unsigned(2 downto 0) := (others => '0');
   signal playerY : unsigned(2 downto 0) := (others => '0');
   signal colorByte : std_logic_vector(7 downto 0) := (others => '0');
   signal introByte : std_logic_vector(7 downto 0) := (others => '0');
   signal deathByte : std_logic_vector(7 downto 0) := (others => '0');
   signal playerColor : std_logic_vector(7 downto 0) := (others => '0');
   signal selectDisplay : std_logic_vector(1 downto 0) := (others => '0');
   signal colorReady : std_logic := '0';

 	--Outputs
   signal getRow : unsigned(2 downto 0);
   signal getColumn : unsigned(2 downto 0);
   signal getColor : std_logic;
   signal displayReady : std_logic;
   signal displayBit : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Display PORT MAP (
          Clk => Clk,
          displayEN => displayEN,
          resetDisplay => resetDisplay,
          playerX => playerX,
          playerY => playerY,
          colorByte => colorByte,
          introByte => introByte,
          deathByte => deathByte,
          playerColor => playerColor,
          selectDisplay => selectDisplay,
          colorReady => colorReady,
          getRow => getRow,
          getColumn => getColumn,
          getColor => getColor,
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
		deathByte<="10000001";
		introByte <="01111110";
		playerColor <= "10101010";
		colorByte <= "11110000";
		playerX <= "000";
		playerY <= "010";
      wait for Clk_period*4.25;
		displayEN <= '1';
		selectDisplay <= "00";
		wait for Clk_period*2;
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
		wait for Clk_period*12;
		colorByte <= "00001111";
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
		wait for Clk_period*12;
		colorByte <= "00110011";
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
		wait for Clk_period*12;
		colorByte <= "00001111";
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
		wait for Clk_period*12;
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
		wait for Clk_period*12;
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
		wait for Clk_period*12;
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
		wait for Clk_period*12;
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
		wait for Clk_period*12;
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
		wait for Clk_period*12;
		resetDisplay <= '1';
		wait for Clk_period*2;
		resetDisplay <= '0';
		selectDisplay <= "01";
		wait for Clk_period;
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
		wait for Clk_period*12;
		resetDisplay <= '0';
		selectDisplay <= "10";
		wait for Clk_period;
		colorReady <= '1';
		wait for Clk_period;
		colorReady <= '0';
      wait;
   end process;

END;
