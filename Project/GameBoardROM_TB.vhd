--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:31:31 08/13/2009
-- Design Name:   
-- Module Name:   C:/engs31_cellHELP/cellHELP/GameBoardROM_TB.vhd
-- Project Name:  cellHELP
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GameBoardROM
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
 
ENTITY GameBoardROM_TB IS
END GameBoardROM_TB;
 
ARCHITECTURE behavior OF GameBoardROM_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GameBoardROM
    PORT(
         clka : IN  std_logic;
         addra : IN  std_logic_vector(9 downto 0);
         douta : OUT  std_logic_vector(7 downto 0);
         clkb : IN  std_logic;
         addrb : IN  std_logic_vector(9 downto 0);
         doutb : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clka : std_logic := '0';
   signal addra : std_logic_vector(9 downto 0) := (others => '0');
   signal clkb : std_logic := '0';
   signal addrb : std_logic_vector(9 downto 0) := (others => '0');

 	--Outputs
   signal douta : std_logic_vector(7 downto 0);
   signal doutb : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clka_period : time := 20ns;
   constant clkb_period : time := 20ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GameBoardROM PORT MAP (
          clka => clka,
          addra => addra,
          douta => douta,
          clkb => clkb,
          addrb => addrb,
          doutb => doutb
        );

   -- Clock process definitions
   clka_process :process
   begin
		clka <= '0';
		wait for clka_period/2;
		clka <= '1';
		wait for clka_period/2;
   end process;
 
   clkb_process :process
   begin
		clkb <= '0';
		wait for clkb_period/2;
		clkb <= '1';
		wait for clkb_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		

      wait for clka_period*2.25;

      for f in 0 to 16 loop
         for r in 0 to 7 loop
            for c in 0 to 7 loop
               addra <= std_logic_vector(to_unsigned(f, 4)) & std_logic_vector(to_unsigned(r, 3)) & std_logic_vector(to_unsigned(c, 3));
               wait for Clka_period*2;
            end loop;
         end loop;   
      end loop;
      wait;
   end process;

END;
