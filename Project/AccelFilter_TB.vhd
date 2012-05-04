--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:14:12 08/22/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/Merged/AccelFilter_TB.vhd
-- Project Name:  Merged
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AccelFilter
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
 
ENTITY AccelFilter_TB IS
END AccelFilter_TB;
 
ARCHITECTURE behavior OF AccelFilter_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AccelFilter
    PORT(
         Clk : IN  std_logic;
         CE : IN  std_logic;
         SIGIN : IN  std_logic_vector(7 downto 0);
         SIGOUT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal CE : std_logic := '0';
   signal SIGIN : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal SIGOUT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AccelFilter PORT MAP (
          Clk => Clk,
          CE => CE,
          SIGIN => SIGIN,
          SIGOUT => SIGOUT
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

      wait for clk_period*2.25;
      
      sigin <= "00000001";
      
      wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
      wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
      wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
      wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
      wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
      wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
      wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
      wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
      wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";      
      wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
            wait for clk_period;
      CE <= '1';
      wait for clk_period;
      CE <= '0';
      
      sigin <= "00000001";
      
      
         
      wait;
   end process;

END;
