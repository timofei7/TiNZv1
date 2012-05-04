--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:45:05 08/31/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/Merged/CellGame_TB.vhd
-- Project Name:  Merged
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cellGame
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
 
ENTITY CellGame_TB IS
END CellGame_TB;
 
ARCHITECTURE behavior OF CellGame_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cellGame
    PORT(
         Clk : IN  std_logic;
         ResetALL : IN  std_logic;
         Difficulty : IN  std_logic_vector(2 downto 0);
         SoundON : IN  std_logic;
         Xin : IN  std_logic;
         Yin : IN  std_logic;
         XAnalogIn : IN  std_logic;
         YAnalogIn : IN  std_logic;
         XAnalogOut : OUT  std_logic;
         YAnalogOut : OUT  std_logic;
         Xout : OUT  std_logic_vector(2 downto 0);
         Yout : OUT  std_logic_vector(2 downto 0);
         MOSI : OUT  std_logic;
         SCLK : OUT  std_logic;
         CS : OUT  std_logic;
         NoiseOut : OUT  std_logic;
         an : OUT  std_logic_vector(3 downto 0);
         seg : OUT  std_logic_vector(0 to 6)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal ResetALL : std_logic := '0';
   signal Difficulty : std_logic_vector(2 downto 0) := (others => '0');
   signal SoundON : std_logic := '0';
   signal Xin : std_logic := '0';
   signal Yin : std_logic := '0';
   signal XAnalogIn : std_logic := '0';
   signal YAnalogIn : std_logic := '0';

 	--Outputs
   signal XAnalogOut : std_logic;
   signal YAnalogOut : std_logic;
   signal Xout : std_logic_vector(2 downto 0);
   signal Yout : std_logic_vector(2 downto 0);
   signal MOSI : std_logic;
   signal SCLK : std_logic;
   signal CS : std_logic;
   signal NoiseOut : std_logic;
   signal an : std_logic_vector(3 downto 0);
   signal seg : std_logic_vector(0 to 6);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cellGame PORT MAP (
          Clk => Clk,
          ResetALL => ResetALL,
          Difficulty => Difficulty,
          SoundON => SoundON,
          Xin => Xin,
          Yin => Yin,
          XAnalogIn => XAnalogIn,
          YAnalogIn => YAnalogIn,
          XAnalogOut => XAnalogOut,
          YAnalogOut => YAnalogOut,
          Xout => Xout,
          Yout => Yout,
          MOSI => MOSI,
          SCLK => SCLK,
          CS => CS,
          NoiseOut => NoiseOut,
          an => an,
          seg => seg
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 
 

   process
   begin		

   wait for clk_period*10.25;
   
   for index in 0 to 10 loop
         Xin <= '1';
         wait for 2.5ms;
         Xin <= '0';
         wait for 2.5ms;
   end loop;
   
   wait;
   end process;
   
   process
   begin		

   wait for clk_period*10.25;
   
   for index in 0 to 10 loop
         Yin <= '1';
         wait for 4ms;
         Yin <= '0';
         wait for 1ms;
   end loop;
   wait;
   end process;

END;
