--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:02:31 08/17/2009
-- Design Name:   
-- Module Name:   C:/Engs31/Project/unitCounterTB.vhd
-- Project Name:  Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: unitCounter
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
 
ENTITY unitCounterTB IS
END unitCounterTB;
 
ARCHITECTURE behavior OF unitCounterTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT unitCounter
    PORT(
         Clk : IN  std_logic;
         timerEN : IN  std_logic;
         reset : IN  std_logic;
         currTime : OUT  std_logic_vector(3 downto 0);
         DOUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal timerEN : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal currTime : std_logic_vector(3 downto 0);
   signal DOUT : std_logic;

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: unitCounter PORT MAP (
          Clk => Clk,
          timerEN => timerEN,
          reset => reset,
          currTime => currTime,
          DOUT => DOUT
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
      timerEN <= '1';
		wait for Clk_period*12.25;
		reset <= '1';
		wait for Clk_period*2;
		reset <= '0';
      wait;
   end process;

END;
